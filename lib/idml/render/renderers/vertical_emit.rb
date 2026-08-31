# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Vertical writing path (StoryOrientation="Vertical", CJK):
      # paragraphs flow as upright glyph columns advancing
      # right-to-left; each run starts a fresh column (run-mixing
      # within a column is not modeled). Runs whose columns would
      # cross the frame's left inset overflow to the next frame in
      # the chain. Paragraph spacing, rules, and decorations are
      # not applied in vertical mode.
      #
      # A class-methods module extended into TextFrameRenderer —
      # it shares the host's constants, font resolution, and
      # layout_frame helper (MECE: this module owns everything
      # vertical; the host owns the horizontal engine).
      module VerticalEmit
        def vertical_story?(story)
          story.inner&.story_preference&.story_orientation == "Vertical"
        end

        def vertical_render(canvas, state, context, box, font)
          layout_frame = layout_frame(context.item, box)
          left_limit = layout_frame.x + (layout_frame.inset_left || 0)
          resume_vertical_paragraph(state)
          entry_offset = state.column_offset || 0
          next_column = entry_offset
          pending = 0

          state.paragraphs.each_with_index do |paragraph, index|
            if vertical_keep_deferred?(paragraph, state.paragraphs[index + 1],
                                       layout_frame, font, left_limit,
                                       next_column, pending, entry_offset)
              state.current_paragraph = nil
              state.runs_remaining = []
              state.column_offset = 0
              break
            end

            remaining_runs, next_column = vertical_paragraph(
              canvas, paragraph, context, layout_frame, font,
              left_limit, next_column
            )
            if remaining_runs.empty?
              pending += 1
            else
              state.current_paragraph = paragraph
              state.runs_remaining = remaining_runs
              state.column_offset = next_column
              break
            end
          end

          state.paragraphs = state.paragraphs[pending..]
        end

        # Keep options in vertical mode (TODO 153, column-count
        # approximation — one column per run under-estimates runs
        # that span several columns, so deferral errs toward
        # placing): KeepAllLinesTogether defers the paragraph
        # wholly to the next frame; KeepWithNext also defers when
        # the follower (or its forced break) would strand. Never
        # defers the frame's first paragraph — the progress
        # guarantee, shared with KeepPolicy.
        def vertical_keep_deferred?(paragraph, next_paragraph,
                                    layout_frame, _font, left_limit,
                                    next_column, pending, entry_offset)
          placed = pending.positive? || entry_offset.positive?
          return false unless placed
          return false unless keep_flagged?(paragraph)

          needed = [paragraph.runs.length, 1].max
          room = vertical_room(layout_frame, paragraph, left_limit,
                               next_column)
          return true if keep_all_deferred?(paragraph, needed, room)
          return true if window_deferred?(paragraph, needed, room)

          with_next_deferred?(paragraph, next_paragraph, layout_frame,
                              left_limit, next_column, needed)
        end

        def keep_flagged?(paragraph)
          paragraph.keep_all_lines_together ||
            !paragraph.keep_with_next.nil? ||
            paragraph.keep_first_lines ||
            paragraph.keep_last_lines
        end

        def keep_all_deferred?(paragraph, needed, room)
          paragraph.keep_all_lines_together && needed > room
        end

        # Keep windows on the same column-count approximation:
        # defer a splitting paragraph when fewer than
        # KeepFirstLines columns fit, or when the stranded tail
        # would hold fewer than KeepLastLines columns.
        def window_deferred?(paragraph, needed, room)
          return false unless needed > room

          if paragraph.keep_first_lines &&
              room < paragraph.keep_first_lines
            return true
          end

          paragraph.keep_last_lines &&
            (needed - room) < paragraph.keep_last_lines
        end

        def with_next_deferred?(paragraph, next_paragraph, layout_frame,
                                left_limit, next_column, needed)
          return false if paragraph.keep_with_next.nil?

          follower_needed = [next_paragraph&.runs&.length || 1, 1].max
          follower_break = KeepPolicy.paragraph_break?(next_paragraph)
          room = vertical_room(layout_frame, paragraph, left_limit,
                               next_column)
          follower_break || needed + follower_needed > room
        end

        def vertical_room(layout_frame, paragraph, left_limit,
                          next_column)
          leading = TextEngine::VerticalLayout.leading_for(
            paragraph.auto_leading,
            paragraph.runs.first&.point_size ||
              TextFrameRenderer::DEFAULT_SIZE,
          )
          vertical_available_columns(layout_frame, leading, left_limit,
                                     next_column)
        end

        def vertical_available_columns(layout_frame, leading, left_limit,
                                       next_column)
          right = layout_frame.x + layout_frame.width -
            (layout_frame.inset_right || 0)
          (((right - left_limit) / leading).floor - next_column).to_i
        end

        # Folds a chain-resumed paragraph (runs_remaining) back to
        # the head of the paragraph list so the vertical path sees a
        # uniform sequence. The consumed column offset persists in
        # the state so the next frame continues right where this
        # frame's columns ended.
        def resume_vertical_paragraph(state)
          return unless state.current_paragraph

          state.current_paragraph.runs = state.runs_remaining
          state.paragraphs.unshift(state.current_paragraph)
          state.current_paragraph = nil
          state.runs_remaining = []
        end

        # Renders one paragraph's runs as vertical columns starting
        # at `start_column`. Returns [runs that did not fit (empty
        # when all placed), the next unused column index].
        def vertical_paragraph(canvas, paragraph, context,
                               layout_frame, font, left_limit,
                               start_column)
          next_column = start_column
          paragraph.runs.each_with_index do |run, index|
            size = run.point_size || TextFrameRenderer::DEFAULT_SIZE
            leading = TextEngine::VerticalLayout.leading_for(
              paragraph.auto_leading, size
            )
            glyphs = TextEngine::Shaper.shape(text: run.text, font: font,
                                              size: size)
            grouped = tatechuyoko_group(run, glyphs, layout_frame,
                                        leading, size, next_column)
            positioned, next_column = grouped ||
              TextEngine::VerticalTextLayout.layout(
                glyphs: glyphs, frame: layout_frame, leading: leading,
                size: size, start_column: next_column
              )
            unless vertical_fits?(layout_frame, leading, next_column,
                                  left_limit)
              return [paragraph.runs[index..], start_column]
            end

            emit_vertical_run(canvas, positioned, grouped, run, context,
                              size)
            emit_vertical_ruby(canvas, run, positioned, layout_frame,
                               size, context)
          end
          [[], next_column]
        end

        # A tate-chu-yoko group for runs that declare it (and whose
        # glyphs fit horizontally in a column slot); nil otherwise.
        def tatechuyoko_group(run, glyphs, layout_frame, leading,
                              size, start_column)
          return nil unless run.tatechuyoko

          TextEngine::VerticalTextLayout.tatechuyoko_group(
            glyphs: glyphs, frame: layout_frame, leading: leading,
            size: size, start_column: start_column
          )
        end

        # Emits a vertical run's glyphs: rotated/normal vertical
        # handling for stacked columns, plain upright emission for
        # tate-chu-yoko groups.
        def emit_vertical_run(canvas, positioned, grouped, run,
                              context, size)
          if grouped
            positioned.each do |glyph|
              emit_upright_glyph(canvas, glyph, run, context, size)
            end
          else
            emit_vertical_stack(canvas, positioned, run, context, size)
          end
        end

        # Vertical-stack emission: CJK glyphs stand upright per
        # glyph; consecutive non-CJK glyphs rotate as ONE group
        # (the whole Latin word sideways, as InDesign does). The
        # group's string renders as a single text op inside one
        # rotated graphics state — the font's advances land each
        # glyph exactly where per-glyph rotation placed it. A group
        # never spans columns (x reset) and shares the run's
        # styling, so one text op is lossless.
        def emit_vertical_stack(canvas, positioned, run, context,
                                size)
          segment = []
          positioned.each do |glyph|
            if TextEngine::CjkLayout.cjk?(glyph.codepoint)
              flush_vertical_segment(canvas, segment, run, context, size)
              emit_upright_glyph(canvas, glyph, run, context, size)
            else
              if !segment.empty? && segment.last.x != glyph.x
                flush_vertical_segment(canvas, segment, run, context, size)
              end
              segment << glyph
            end
          end
          flush_vertical_segment(canvas, segment, run, context, size)
        end

        def flush_vertical_segment(canvas, segment, run, context,
                                   size)
          return if segment.empty?

          text = segment.map { |g| [g.codepoint].pack("U") }.join
          first = segment.first
          canvas.save_graphics_state do
            # 90° clockwise: exact matrix (rotate would emit
            # cos/sin float noise like 6.1e-17).
            canvas.concat(0, -1, 1, 0, first.x, first.y)
            text_kwargs = CharacterStyle.text_kwargs(
              run,
              {
                at: [0, 0],
                font: font_for_run(run, context),
                size: size,
              },
            )
            canvas.text(text, **text_kwargs)
          end
        end

        def emit_upright_glyph(canvas, positioned, run, context,
                               size)
          text = [positioned.codepoint].pack("U")
          text_kwargs = CharacterStyle.text_kwargs(
            run,
            {
              at: [positioned.x, positioned.y],
              font: font_for_run(run, context),
              size: size,
            },
          )
          canvas.text(text, **text_kwargs)
        end

        def vertical_fits?(layout_frame, leading, columns, left_limit)
          right = layout_frame.x + layout_frame.width -
            (layout_frame.inset_right || 0)
          (right - (columns * leading)) >= left_limit
        end

        # Emits the run's ruby alongside its vertical glyphs:
        # stacked top-to-bottom beside the column — right side by
        # default, left for Below* RubyPosition values (the
        # horizontal above/below convention mirrored under
        # rotation).
        def emit_vertical_ruby(canvas, run, positioned, frame,
                               base_size, context)
          ruby_text = run.ruby_string
          return if ruby_text.nil? || ruby_text.empty?

          ruby_size = run.ruby_font_size ||
            (base_size * TextFrameRenderer::RUBY_SIZE_FACTOR)
          x = ruby_vertical_x(positioned.first, run, base_size)
          y = frame.y + frame.height - (frame.inset_top || 0)
          ruby_text.each_codepoint do |codepoint|
            text_kwargs = CharacterStyle.text_kwargs(
              run,
              {
                at: [x, y - ruby_size],
                font: font_for_run(run, context),
                size: ruby_size,
              },
            )
            canvas.text([codepoint].pack("U"), **text_kwargs)
            y -= ruby_size
          end
        end

        def ruby_vertical_x(positioned, run, base_size)
          offset = base_size * 0.9
          if run.ruby_position.to_s.include?("Below")
            positioned.x - offset
          else
            positioned.x + offset
          end
        end
      end
    end
  end
end
