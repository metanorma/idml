# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML TextFrame on a Pdfrb::Content::Canvas.
      #
      # Pipeline:
      #
      #   1. Resolve the linked Story via Package#story_by_id.
      #   2. Extract `Paragraph`s via StyleResolver (carries PSR
      #      attributes like SpaceBefore, FirstLineIndent, AutoLeading
      #      alongside the CSR runs).
      #   3. Build a layout `Frame` from the TextFrame's geometric
      #      bounds plus TextFramePreference insets.
      #   4. For each paragraph: shape glyphs (Shaper), wrap to the
      #      inset/indent-adjusted width (LineBreaker), align (Justifier),
      #      position vertically (VerticalLayout), and emit one
      #      `canvas.text` per line. Tracks the y cursor across
      #      paragraphs and runs so text flows top-to-bottom.
      #   5. Records each positioned line in PositionTracker so
      #      HyperlinkEmitter can compute precise per-source link rects.
      #
      # Falls back to a single `canvas.text_rich` per frame when no
      # FontMetrics is available (no shaper → no wrap → rough output).
      class TextFrameRenderer
        DEFAULT_SIZE = 12.0
        LEADING_FACTOR = 1.2

        def self.render(canvas, context)
          frame = context.item
          return unless frame.parent_story

          story = context.package&.story_by_id(frame.parent_story)
          return unless story

          box = frame_box(frame, context.page_height)
          render_inline_tables(canvas, story, box, context)

          state = initial_chain_state(frame, story, context)
          return unless state

          render_text(canvas, state, context, box)
          store_chain_state(frame, state, context)
        end

        # Returns the StoryChainController::State to render this frame
        # with. For chain heads (no predecessor), this is a fresh
        # state built from extract_paragraphs. For chain non-heads,
        # this is the leftover state from the previous frame in the
        # chain (nil when there's nothing left to render).
        def self.initial_chain_state(frame, story, context)
          controller = context.chain_controller
          return fresh_state(story, context) if chain_head?(frame)
          return nil unless controller

          controller.state_for(frame.parent_story)
        end
        private_class_method :initial_chain_state

        # Records the post-render state for the chain so the next
        # frame in the chain picks up where this one left off. Only
        # meaningful when a chain_controller is wired.
        def self.store_chain_state(frame, state, context)
          controller = context.chain_controller
          return unless controller

          controller.store_state(frame.parent_story, state)
        end
        private_class_method :store_chain_state

        def self.fresh_state(story, context)
          paragraphs = StyleResolver.extract_paragraphs(
            story, condition_filter: context.condition_filter
          )
          return nil if paragraphs.empty?

          StoryChainController::State.new(
            paragraphs: paragraphs,
            current_paragraph: nil,
            runs_remaining: [],
            char_cursor: 0,
          )
        end
        private_class_method :fresh_state

        # Discovers Tables inlined in the story (Story > PSR > CSR >
        # Table — the real IDML structure) and renders each within
        # the frame's bounds. Real IDML Tables have no own geometry,
        # so the containing TextFrame's box stands in. Synthetic
        # spread-level Tables dispatch separately via
        # PageItemRenderer.
        def self.render_inline_tables(canvas, story, box, context)
          tables = tables_in_story(story)
          return if tables.empty?

          tables.each do |table|
            TableRenderer.render_in_box(canvas, table, box, context)
          end
        end
        private_class_method :render_inline_tables

        def self.tables_in_story(story)
          inner = story&.inner
          return [] unless inner

          inner.paragraph_style_range.flat_map do |psr|
            psr.character_style_range.flat_map(&:table)
          end.compact
        end
        private_class_method :tables_in_story

        def self.render_text(canvas, state, context, box)
          font = context.font_metrics
          if font
            engine_render(canvas, state, context, box, font)
          else
            simple_render(canvas, state, context, box)
          end
        end
        private_class_method :render_text

        def self.chain_head?(frame)
          frame.previous_text_frame.nil? || frame.previous_text_frame == "n"
        end
        private_class_method :chain_head?

        def self.frame_box(frame, page_height)
          Placement.box(frame, page_height, fallback: true)
        end
        private_class_method :frame_box

        # Builds a layout Frame from the TextFrame's PDF-placement
        # box plus any TextFramePreference insets. Inset values fall
        # back to 0 when the preference is absent or doesn't declare
        # them.
        def self.layout_frame(frame_item, box)
          pref = frame_item.text_frame_preference&.first
          TextEngine::Frame.new(
            x: box[:x],
            y: box[:y],
            width: box[:width],
            height: box[:height],
            inset_top: pref&.inset_top,
            inset_bottom: pref&.inset_bottom,
            inset_left: pref&.inset_left,
            inset_right: pref&.inset_right,
          )
        end
        private_class_method :layout_frame

        # Walks the chain state's paragraphs/runs and emits one
        # `canvas.text` per line via the Shaper → LineBreaker →
        # Justifier → VerticalLayout pipeline. Cursor y descends
        # monotonically across paragraphs. When a paragraph partially
        # fits, its remaining runs go back into the state for the
        # next frame in the chain.
        def self.engine_render(canvas, state, context, box, font)
          layout_frame = layout_frame(context.item, box)
          cursor_y = box[:y] + box[:height] - (layout_frame.inset_top || 0)
          bottom_limit = TextEngine::VerticalLayout.bottom_limit(layout_frame)
          char_cursor = state.char_cursor

          if state.current_paragraph
            cursor_y, char_cursor = resume_paragraph(
              canvas, state, context, layout_frame, font,
              cursor_y, bottom_limit, char_cursor
            )
            return if state.current_paragraph
          end

          consume_paragraphs(canvas, state, context, layout_frame, font,
                             cursor_y, bottom_limit, char_cursor)
        end
        private_class_method :engine_render

        def self.resume_paragraph(canvas, state, context, layout_frame, font,
                                  cursor_y, bottom_limit, char_cursor)
          paragraph = state.current_paragraph
          remaining_runs, cursor_y, char_cursor = render_runs_for_paragraph(
            canvas, paragraph, state.runs_remaining, context,
            layout_frame, font, cursor_y, bottom_limit, char_cursor,
            first_paragraph: true
          )
          if remaining_runs.any?
            state.runs_remaining = remaining_runs
          else
            state.current_paragraph = nil
            state.runs_remaining = []
          end
          [cursor_y, char_cursor]
        end
        private_class_method :resume_paragraph

        def self.consume_paragraphs(canvas, state, context, layout_frame, font,
                                    cursor_y, bottom_limit, char_cursor)
          pending = 0
          state.paragraphs.each do |paragraph|
            break if cursor_y < bottom_limit

            remaining_runs, cursor_y, char_cursor = render_runs_for_paragraph(
              canvas, paragraph, paragraph.runs, context,
              layout_frame, font, cursor_y, bottom_limit, char_cursor,
              first_paragraph: pending.zero?
            )
            if remaining_runs.any?
              state.current_paragraph = paragraph
              state.runs_remaining = remaining_runs
              break
            end
            pending += 1
          end

          state.paragraphs = state.paragraphs[pending..]
          state.char_cursor = char_cursor
        end
        private_class_method :consume_paragraphs

        # Renders a paragraph's runs (a subset when resuming mid-para).
        # Returns [remaining_runs, cursor_y, char_cursor] where
        # remaining_runs is the runs that didn't fit (empty when all
        # done). Emits RuleAbove before the first run and RuleBelow
        # after the last successfully-rendered run.
        def self.render_runs_for_paragraph(canvas, paragraph, runs, context,
                                           layout_frame, font, cursor_y,
                                           bottom_limit, char_cursor,
                                           first_paragraph:)
          wrap_width = TextEngine::VerticalLayout.wrap_width(
            layout_frame, paragraph.right_indent || 0
          )
          para_attrs = paragraph_attrs(paragraph)
          frame_left, frame_right = paragraph_frame_extents(layout_frame)

          emit_paragraph_top_rule(canvas, paragraph, context, cursor_y,
                                  frame_left, frame_right, first_paragraph)

          rendered_count = 0
          runs.each do |run|
            break if cursor_y < bottom_limit

            space_before = paragraph_space_before(para_attrs, first_paragraph,
                                                  rendered_count)
            positioned, next_y = layout_run(
              canvas, run, paragraph, context, layout_frame, font,
              wrap_width, cursor_y, space_before,
              para_attrs[:first_line_indent], para_attrs[:left_indent],
              char_cursor
            )
            char_cursor += positioned.length
            cursor_y = next_y
            rendered_count += 1
          end

          remaining_runs = runs[rendered_count..]
          cursor_y = emit_paragraph_bottom_rule(canvas, paragraph, context,
                                                cursor_y, frame_left,
                                                frame_right, para_attrs,
                                                remaining_runs)
          [remaining_runs, cursor_y, char_cursor]
        end
        private_class_method :render_runs_for_paragraph

        def self.emit_paragraph_top_rule(canvas, paragraph, context, cursor_y,
                                         frame_left, frame_right,
                                         first_paragraph)
          return unless first_paragraph

          ParagraphRules.emit_rule_above(canvas, paragraph, context,
                                         cursor_y, frame_left, frame_right)
        end
        private_class_method :emit_paragraph_top_rule

        def self.paragraph_space_before(para_attrs, first_paragraph,
                                        rendered_count)
          return 0 unless first_paragraph && rendered_count.zero?

          para_attrs[:space_before]
        end
        private_class_method :paragraph_space_before

        # Emits RuleBelow after a paragraph's last run. Returns the
        # updated cursor_y (subtracting space_after when the paragraph
        # completed).
        def self.emit_paragraph_bottom_rule(canvas, paragraph, context,
                                            cursor_y, frame_left,
                                            frame_right, para_attrs,
                                            remaining_runs)
          return cursor_y unless remaining_runs.empty?

          after_y = cursor_y - para_attrs[:space_after]
          ParagraphRules.emit_rule_below(canvas, paragraph, context,
                                         after_y, frame_left, frame_right)
          after_y
        end
        private_class_method :emit_paragraph_bottom_rule

        def self.paragraph_frame_extents(layout_frame)
          inset_left = layout_frame.inset_left || 0
          inset_right = layout_frame.inset_right || 0
          [layout_frame.x + inset_left,
           layout_frame.x + layout_frame.width - inset_right]
        end
        private_class_method :paragraph_frame_extents

        def self.paragraph_attrs(paragraph)
          {
            space_before: paragraph.space_before || 0,
            space_after: paragraph.space_after || 0,
            first_line_indent: paragraph.first_line_indent || 0,
            left_indent: paragraph.left_indent || 0,
          }
        end
        private_class_method :paragraph_attrs

        # Shapes one run's text, wraps to the inset/indent-adjusted
        # width, justifies per paragraph alignment, and asks
        # VerticalLayout to position the lines. Emits each line via
        # `canvas.text` and records positions for hyperlink tracking.
        # Returns `[positioned_lines, next_y]`.
        def self.layout_run(canvas, run, paragraph, context, layout_frame,
                            font, wrap_width, cursor_y, space_before,
                            first_line_indent, left_indent,
                            char_cursor)
          size = run.point_size || DEFAULT_SIZE
          glyphs = TextEngine::Shaper.shape(
            text: run.text, font: font, size: size,
          )
          lines = TextEngine::LineBreaker.break(
            glyphs: glyphs, frame_width: wrap_width,
          )
          lines.each do |line|
            TextEngine::Justifier.justify(
              line: line, frame_width: wrap_width,
              alignment: paragraph.alignment || :left
            )
          end
          leading = leading_for(paragraph, size)

          positioned, next_y = TextEngine::VerticalLayout.layout_block(
            lines: lines,
            frame: layout_frame,
            font_size: size,
            leading: leading,
            cursor_y: cursor_y,
            space_before: space_before,
            first_line_indent: first_line_indent,
            left_indent: left_indent,
          )

          bottom_limit = TextEngine::VerticalLayout.bottom_limit(layout_frame)
          positioned.each do |line|
            break if line.y < bottom_limit

            emit_line(canvas, line, run, context, size)
            record_position(context, line, size, char_cursor)
          end
          [positioned, next_y]
        end
        private_class_method :layout_run

        # Emits one positioned line: applies character-level styling
        # (fill color + tint, capitalization, position, tracking,
        # glyph scaling, baseline shift) via CharacterStyle, then
        # draws underline/strike-through rules after the text.
        def self.emit_line(canvas, line, run, context, size)
          text = CharacterStyle.transform_text(line_text(line),
                                               run.capitalization)
          scaled_size, position_offset = CharacterStyle.position_scale(
            run.position, size
          )
          baseline_offset = CharacterStyle.baseline_offset(run) +
            position_offset
          text_at = [line.x, line.y + baseline_offset]
          text_kwargs = CharacterStyle.text_kwargs(
            run,
            {
              at: text_at,
              font: font_for_run(run, context),
              size: scaled_size,
            },
          )
          CharacterStyle.apply(canvas, run, context,
                               x: line.x, y: line.y + baseline_offset,
                               width: line.width, size: scaled_size) do
            CharacterStyle.with_glyph_scaling(canvas, run) do
              canvas.text(text, **text_kwargs)
            end
          end
        end
        private_class_method :emit_line

        def self.leading_for(paragraph, size)
          explicit = paragraph.auto_leading
          return size * LEADING_FACTOR unless explicit&.positive?

          size * explicit
        end
        private_class_method :leading_for

        def self.record_position(context, line, height, cursor)
          tracker = context.position_tracker
          return unless tracker
          return unless context.item&.self_attr

          glyph_count = line.glyphs.length
          tracker.add(context.item.self_attr,
                      start_char: cursor,
                      end_char: cursor + glyph_count,
                      x: line.x,
                      y: line.y,
                      width: line.width,
                      height: height)
        end
        private_class_method :record_position

        # Resolves the font resource for a styled run. Checks the
        # run's `applied_font` (family name from CSR's AppliedFont)
        # against the document's font_map. Falls back to the document
        # default when no per-run font is specified or the family
        # isn't registered.
        def self.font_for_run(run, context)
          family = run.applied_font
          return context.font_ps_name unless family
          return context.font_ps_name unless context.font_map

          context.font_map[family] || context.font_ps_name
        end
        private_class_method :font_for_run

        def self.line_text(line)
          line.glyphs.map { |g| [g.codepoint].pack("U") }.join
        end
        private_class_method :line_text

        # Fallback when no metrics are available: emit all runs as
        # one `text_rich` block, letting pdfrb measure advance widths.
        # Chain threading is best-effort here — the simple path
        # doesn't wrap, so the first frame's render typically emits
        # all content and clears the chain state.
        def self.simple_render(canvas, state, context, box)
          runs = collect_runs(state)
          return if runs.empty?

          runs_for = build_rich_runs(runs, context)
          first_size = runs.first.point_size || DEFAULT_SIZE
          canvas.text_rich(
            runs_for,
            at: [box[:x], box[:y] + box[:height] - first_size],
          )
          state.paragraphs = []
          state.current_paragraph = nil
          state.runs_remaining = []
        end
        private_class_method :simple_render

        def self.collect_runs(state)
          runs = state.runs_remaining || []
          if state.current_paragraph
            runs + state.current_paragraph.runs
          else
            runs + state.paragraphs.flat_map(&:runs)
          end
        end
        private_class_method :collect_runs

        def self.build_rich_runs(runs, context)
          runs.map do |run|
            {
              text: run.text,
              font: font_for_run(run, context),
              size: run.point_size || DEFAULT_SIZE,
            }
          end
        end
        private_class_method :build_rich_runs
      end
    end
  end
end
