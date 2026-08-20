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
        RUBY_SIZE_FACTOR = 0.5

        def self.render(canvas, context)
          frame = context.item
          return unless frame.parent_story

          story = context.package&.story_by_id(frame.parent_story)
          return unless story

          box = frame_box(frame, context.page_height)
          render_inline_tables(canvas, story, box, context)
          render_anchored_objects(canvas, story, context)

          state = initial_chain_state(frame, story, context)
          return unless state

          vertical = vertical_story?(story)
          render_text(canvas, state, context, box, vertical: vertical)
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
            story, condition_filter: context.condition_filter,
                   style_lookup: context.style_lookup,
                   footnote_option: Footnote.option(context.package)
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
          story_csrs(story).flat_map(&:table).compact
        end
        private_class_method :tables_in_story

        # All CharacterStyleRanges of a story, in document order.
        # Shared by the story-level item discovery walks (tables,
        # anchored objects).
        def self.story_csrs(story)
          inner = story&.inner
          return [] unless inner

          inner.paragraph_style_range.flat_map(&:character_style_range)
        end
        private_class_method :story_csrs

        # Renders anchored page items embedded in the story flow
        # (Story > PSR > CSR > Rectangle/Oval/Polygon/GraphicLine/
        # Group/TextFrame — the IDML structure for anchored objects).
        # Each item renders at its own stored geometry, which
        # InDesign resolves to the anchored position when saving;
        # AnchorType-specific text reflow is not simulated (the
        # layout engine positions text independently either way).
        def self.render_anchored_objects(canvas, story, context)
          anchored_items_in_story(story).each do |item|
            PageItemRenderer.render(canvas, context_for_item(context, item))
          end
        end
        private_class_method :render_anchored_objects

        def self.anchored_items_in_story(story)
          story_csrs(story).flat_map do |csr|
            [csr.rectangle, csr.oval, csr.polygon,
             csr.graphic_line, csr.group, csr.text_frame]
          end.flatten.compact
        end
        private_class_method :anchored_items_in_story

        def self.context_for_item(context, item)
          RenderContext.new(**context.to_h, item: item)
        end
        private_class_method :context_for_item

        def self.render_text(canvas, state, context, box, vertical: false)
          font = context.font_metrics
          if font && vertical
            vertical_render(canvas, state, context, box, font)
          elsif font
            engine_render(canvas, state, context, box, font)
          else
            simple_render(canvas, state, context, box)
          end
        end
        private_class_method :render_text

        # True when the story's StoryPreference declares vertical
        # writing (StoryOrientation="Vertical").
        def self.vertical_story?(story)
          story.inner&.story_preference&.story_orientation == "Vertical"
        end
        private_class_method :vertical_story?

        # Vertical writing path (StoryOrientation="Vertical", CJK):
        # paragraphs flow as upright glyph columns advancing
        # right-to-left; each run starts a fresh column (run-mixing
        # within a column is not modeled). Runs whose columns would
        # cross the frame's left inset overflow to the next frame in
        # the chain. Paragraph spacing, rules, and decorations are
        # not applied in vertical mode.
        def self.vertical_render(canvas, state, context, box, font)
          layout_frame = layout_frame(context.item, box)
          left_limit = layout_frame.x + (layout_frame.inset_left || 0)
          resume_vertical_paragraph(state)
          pending = 0

          state.paragraphs.each do |paragraph|
            remaining_runs = vertical_paragraph(
              canvas, paragraph, context, layout_frame, font, left_limit
            )
            if remaining_runs.empty?
              pending += 1
            else
              state.current_paragraph = paragraph
              state.runs_remaining = remaining_runs
              break
            end
          end

          state.paragraphs = state.paragraphs[pending..]
        end
        private_class_method :vertical_render

        # Folds a chain-resumed paragraph (runs_remaining) back to
        # the head of the paragraph list so the vertical path sees a
        # uniform sequence.
        def self.resume_vertical_paragraph(state)
          return unless state.current_paragraph

          state.current_paragraph.runs = state.runs_remaining
          state.paragraphs.unshift(state.current_paragraph)
          state.current_paragraph = nil
          state.runs_remaining = []
        end
        private_class_method :resume_vertical_paragraph

        # Renders one paragraph's runs as vertical columns. Returns
        # the runs that did not fit (empty when all placed).
        def self.vertical_paragraph(canvas, paragraph, context,
                                    layout_frame, font, left_limit)
          paragraph.runs.each_with_index do |run, index|
            size = run.point_size || DEFAULT_SIZE
            leading = TextEngine::VerticalLayout.leading_for(
              paragraph.auto_leading, size
            )
            glyphs = TextEngine::Shaper.shape(text: run.text, font: font,
                                              size: size)
            positioned, columns = TextEngine::VerticalTextLayout.layout(
              glyphs: glyphs, frame: layout_frame, leading: leading,
              size: size
            )
            unless vertical_fits?(layout_frame, leading, columns,
                                  left_limit)
              return paragraph.runs[index..]
            end

            positioned.each do |glyph|
              emit_vertical_glyph(canvas, glyph, run, context, size)
            end
          end
          []
        end
        private_class_method :vertical_paragraph

        def self.vertical_fits?(layout_frame, leading, columns, left_limit)
          right = layout_frame.x + layout_frame.width -
            (layout_frame.inset_right || 0)
          (right - (columns * leading)) >= left_limit
        end
        private_class_method :vertical_fits?

        # Emits one upright glyph at its vertical position with the
        # run's character styling.
        def self.emit_vertical_glyph(canvas, positioned, run, context,
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
        private_class_method :emit_vertical_glyph

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
          col_count = text_column_count(context)

          if col_count && col_count > 1
            engine_render_multi_column(canvas, state, context, layout_frame,
                                       font, col_count)
          else
            engine_render_single_column(canvas, state, context, layout_frame,
                                        font)
          end
        end
        private_class_method :engine_render

        def self.engine_render_single_column(canvas, state, context,
                                              layout_frame, font)
          top_y = layout_frame.y + layout_frame.height -
            (layout_frame.inset_top || 0)
          bottom_limit = TextEngine::VerticalLayout.bottom_limit(layout_frame)
          footnotes = []
          cursor_y = vertical_justify_top(top_y, bottom_limit, state, context)
          char_cursor = state.char_cursor

          if state.current_paragraph
            cursor_y, char_cursor = resume_paragraph(
              canvas, state, context, layout_frame, font,
              cursor_y, bottom_limit, char_cursor, footnotes
            )
          end

          unless state.current_paragraph
            consume_paragraphs(canvas, state, context, layout_frame, font,
                               cursor_y, bottom_limit, char_cursor, footnotes)
          end
          render_footnote_entries(canvas, footnotes, layout_frame,
                                  context, font)
        end
        private_class_method :engine_render_single_column

        # Renders text across N columns within a single frame. Text
        # flows column 1 → column 2 → ... → chain to next frame. Each
        # column acts as a mini-frame with the same height but a
        # narrower width. The chain state threads across columns
        # transparently.
        def self.engine_render_multi_column(canvas, state, context,
                                             layout_frame, font, col_count)
          gutter = text_column_gutter(context) || 0
          col_frames = build_column_frames(layout_frame, col_count, gutter)

          col_frames.each do |col_frame|
            break if state_empty?(state)

            render_column(canvas, state, context, col_frame, font)
          end
        end
        private_class_method :engine_render_multi_column

        def self.render_column(canvas, state, context, col_frame, font)
          top_y = col_frame.y + col_frame.height - (col_frame.inset_top || 0)
          bottom_limit = TextEngine::VerticalLayout.bottom_limit(col_frame)
          footnotes = []
          cursor_y = top_y
          char_cursor = state.char_cursor

          if state.current_paragraph
            cursor_y, char_cursor = resume_paragraph(
              canvas, state, context, col_frame, font,
              cursor_y, bottom_limit, char_cursor, footnotes
            )
          end

          unless state.current_paragraph
            consume_paragraphs(canvas, state, context, col_frame, font,
                               cursor_y, bottom_limit, char_cursor, footnotes)
          end
          render_footnote_entries(canvas, footnotes, col_frame,
                                  context, font)
        end
        private_class_method :render_column

        def self.state_empty?(state)
          state.paragraphs.empty? && state.current_paragraph.nil?
        end
        private_class_method :state_empty?

        def self.text_column_count(context)
          pref = context.item&.text_frame_preference&.first
          pref&.text_column_count
        end
        private_class_method :text_column_count

        def self.text_column_gutter(context)
          pref = context.item&.text_frame_preference&.first
          pref&.text_column_gutter
        end
        private_class_method :text_column_gutter

        # Builds N column-specific Frame structs from the parent
        # layout frame. Each column has the same y/height/insets but
        # a different x and width so VerticalLayout's geometry math
        # produces correct per-column results.
        def self.build_column_frames(layout_frame, col_count, gutter)
          inset_left = layout_frame.inset_left || 0
          inset_right = layout_frame.inset_right || 0
          content_width = layout_frame.width - inset_left - inset_right
          col_width = (content_width - ((col_count - 1) * gutter)) / col_count

          Array.new(col_count) do |i|
            col_left = layout_frame.x + inset_left + (i * (col_width + gutter))
            TextEngine::Frame.new(
              x: col_left - inset_left,
              y: layout_frame.y,
              width: col_width + inset_left + inset_right,
              height: layout_frame.height,
              inset_top: layout_frame.inset_top,
              inset_bottom: layout_frame.inset_bottom,
              inset_left: inset_left,
              inset_right: inset_right,
            )
          end
        end
        private_class_method :build_column_frames

        # Computes the starting cursor_y for vertical justification.
        # IDML's TextFramePreference.VerticalJustification can be:
        # - TopAlign (default): start at frame top, no offset
        # - CenterAlign: center the content block vertically
        # - BottomAlign: align content to the frame bottom
        # - JustifyAlign: distribute extra space between paragraphs
        #   (deferred — falls back to TopAlign behavior)
        #
        # Content height is estimated by walking paragraphs and
        # summing leading × lines + space_before/after. Without
        # shaping/wrapping we can't know exact line count, so we
        # approximate by treating each run as one line.
        def self.vertical_justify_top(top_y, bottom_limit, state, context)
          justification = text_frame_vertical_justification(context)
          return top_y unless %w[CenterAlign BottomAlign].include?(justification)

          content_height = estimate_content_height(state)
          available = top_y - bottom_limit
          slack = [available - content_height, 0].max
          return top_y if slack.zero?

          case justification
          when "CenterAlign" then top_y - (slack / 2)
          when "BottomAlign" then top_y - slack
          else top_y
          end
        end
        private_class_method :vertical_justify_top

        def self.text_frame_vertical_justification(context)
          pref = context.item&.text_frame_preference&.first
          pref&.vertical_justification
        end
        private_class_method :text_frame_vertical_justification

        # Estimates total renderable content height for vertical
        # justification. Walks paragraphs and runs, summing leading
        # per run plus paragraph space_before/after. Approximation:
        # treats each run as one line (wrap may produce more lines,
        # which would over-estimate slack; acceptable for
        # justification since we'd rather under-offset than overflow).
        def self.estimate_content_height(state)
          paragraphs = paragraphs_for_estimate(state)
          return 0 if paragraphs.empty?

          paragraphs.sum do |paragraph|
            paragraph_height(paragraph)
          end
        end
        private_class_method :estimate_content_height

        def self.paragraphs_for_estimate(state)
          result = []
          result << state.current_paragraph if state.current_paragraph
          result + state.paragraphs
        end
        private_class_method :paragraphs_for_estimate

        def self.paragraph_height(paragraph)
          size = paragraph.runs.first&.point_size || DEFAULT_SIZE
          leading = leading_for(paragraph, size)
          line_count = [paragraph.runs.length, 1].max
          (leading * line_count) + space_before_after(paragraph)
        end
        private_class_method :paragraph_height

        def self.space_before_after(paragraph)
          (paragraph.space_before || 0) + (paragraph.space_after || 0)
        end
        private_class_method :space_before_after

        def self.resume_paragraph(canvas, state, context, layout_frame, font,
                                  cursor_y, bottom_limit, char_cursor,
                                  footnotes)
          paragraph = state.current_paragraph
          remaining_runs, cursor_y, char_cursor = render_runs_for_paragraph(
            canvas, paragraph, state.runs_remaining, context,
            layout_frame, font, cursor_y, bottom_limit, char_cursor,
            first_paragraph: true, footnotes: footnotes
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
                                    cursor_y, bottom_limit, char_cursor,
                                    footnotes)
          pending = 0
          state.paragraphs.each do |paragraph|
            break if cursor_y < bottom_limit
            break if paragraph_break?(paragraph) && pending.positive?

            remaining_runs, cursor_y, char_cursor = render_runs_for_paragraph(
              canvas, paragraph, paragraph.runs, context,
              layout_frame, font, cursor_y, bottom_limit, char_cursor,
              first_paragraph: pending.zero?, footnotes: footnotes
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
                                           first_paragraph:, footnotes:)
          wrap_width = TextEngine::VerticalLayout.wrap_width(
            layout_frame, paragraph.right_indent || 0
          )
          para_attrs = paragraph_attrs(paragraph)
          frame_left, frame_right = paragraph_frame_extents(layout_frame)

          emit_paragraph_top_rule(canvas, paragraph, context, cursor_y,
                                  frame_left, frame_right, first_paragraph)
          block_top, block_bottom = paragraph_block_extent(
            paragraph, font, wrap_width, cursor_y, bottom_limit
          )
          ParagraphRules.emit_shading(canvas, paragraph, context,
                                      block_top, block_bottom,
                                      frame_left, frame_right)
          drop_cap = emit_drop_cap(canvas, paragraph, context, frame_left,
                                   cursor_y, first_paragraph)

          effective_runs = prepare_runs_for_drop_cap(runs, drop_cap)
          dc_width = drop_cap&.wrap_offset || 0
          dc_lines = drop_cap&.lines || 0

          rendered, cursor_y, char_cursor = iterate_paragraph_runs(
            canvas, paragraph, effective_runs, context, layout_frame,
            font, wrap_width, cursor_y, bottom_limit, char_cursor,
            first_paragraph, para_attrs, dc_width, dc_lines, footnotes
          )

          remaining_runs = effective_runs[rendered..]
          cursor_y = emit_paragraph_bottom_rule(canvas, paragraph, context,
                                                cursor_y, frame_left,
                                                frame_right, para_attrs,
                                                remaining_runs)
          ParagraphRules.emit_border(canvas, paragraph, context,
                                     block_top, block_bottom,
                                     frame_left, frame_right)
          [remaining_runs, cursor_y, char_cursor]
        end
        private_class_method :render_runs_for_paragraph

        # The paragraph's block extent: top at the current cursor,
        # bottom at the pre-measured height clamped to the frame's
        # bottom limit. Shading and border both use this one rect so
        # they agree even when the paragraph splits across frames
        # (the split case shades only the rendered part).
        def self.paragraph_block_extent(paragraph, font, wrap_width,
                                        cursor_y, bottom_limit)
          height = TextEngine::Measurement.paragraph_height(
            paragraph, font, wrap_width
          )
          block_bottom = [cursor_y - height, bottom_limit].max
          [cursor_y, block_bottom]
        end
        private_class_method :paragraph_block_extent

        def self.iterate_paragraph_runs(canvas, paragraph, runs, context,
                                        layout_frame, font, wrap_width,
                                        cursor_y, bottom_limit, char_cursor,
                                        first_paragraph, para_attrs,
                                        dc_width, dc_lines, footnotes)
          rendered_count = 0
          runs.each do |run|
            break if cursor_y < bottom_limit

            space_before = paragraph_space_before(para_attrs, first_paragraph,
                                                  rendered_count)
            run_wrap = drop_cap_wrap_width(wrap_width, dc_width,
                                           dc_lines, rendered_count)
            run_wrap -= text_wrap_overlap(context, layout_frame, cursor_y,
                                          run)
            positioned, next_y = layout_run(
              canvas, run, paragraph, context, layout_frame, font,
              run_wrap, cursor_y, space_before,
              para_attrs[:first_line_indent], para_attrs[:left_indent],
              char_cursor, bottom_limit,
              paragraph_last: run.equal?(runs.last)
            )
            char_cursor += positioned.length
            cursor_y = next_y
            rendered_count += 1
            bottom_limit = register_footnote(footnotes, run, layout_frame,
                                             font, context, bottom_limit)
          end
          [rendered_count, cursor_y, char_cursor]
        end
        private_class_method :iterate_paragraph_runs

        # Collects the footnote anchored by a marker run and raises
        # the effective bottom limit to reserve room for all
        # footnotes collected so far. Pass-through for regular runs.
        def self.register_footnote(footnotes, run, layout_frame, font,
                                   context, bottom_limit)
          return bottom_limit unless run.footnote_paragraphs

          footnotes << Footnote::Entry.new(
            number: run.footnote_number,
            paragraphs: run.footnote_paragraphs,
          )
          option = Footnote.option(context.package)
          frame_bottom = TextEngine::VerticalLayout.bottom_limit(layout_frame)
          reserved = Footnote.reserved_height(footnotes, font, layout_frame,
                                              option)
          frame_bottom + reserved
        end
        private_class_method :register_footnote

        # Renders the collected footnotes at the bottom of the
        # frame: separator rule at the area's top edge, then the
        # footnote paragraphs (marker-prefixed at extraction)
        # flowing downward to the content bottom.
        def self.render_footnote_entries(canvas, footnotes, layout_frame,
                                         context, font)
          return if footnotes.empty?

          option = Footnote.option(context.package)
          content_bottom = TextEngine::VerticalLayout.bottom_limit(
            layout_frame,
          )
          area_top = content_bottom +
            Footnote.reserved_height(footnotes, font, layout_frame, option)

          Footnote.emit_separator(canvas, layout_frame, area_top, option)
          positioned, = Footnote.layout_entries(
            footnotes, layout_frame, font,
            area_top - Footnote.rule_gap(option), option
          )
          positioned.each do |item|
            next if item.line.y < content_bottom

            emit_line(canvas, item.line, item.run, context, item.font_size)
          end
        end
        private_class_method :render_footnote_entries

        # Computes the text-wrap overlap for a run at its current y
        # position. Uses the run's point_size as the line height
        # approximation. Returns 0.0 when no resolver is wired or no
        # contours overlap. Per-run approximation: all lines in the
        # run get the same reduced width (correct when the run is
        # fully inside or outside the contour; approximate when it
        # spans the boundary).
        def self.text_wrap_overlap(context, layout_frame, cursor_y, run)
          resolver = context.text_wrap_resolver
          return 0.0 unless resolver

          size = run.point_size || DEFAULT_SIZE
          frame_x = layout_frame.x + (layout_frame.inset_left || 0)
          frame_right = layout_frame.x + layout_frame.width -
            (layout_frame.inset_right || 0)
          overlap = resolver.overlap_width(cursor_y, size,
                                           frame_x, frame_right)
          [overlap, 0.0].max
        end
        private_class_method :text_wrap_overlap

        # Strips drop cap characters from the first run so they don't
        # render twice (once as the enlarged drop cap, once as normal
        # text). Returns a new run list with the first run's text
        # adjusted. If stripping empties the first run, removes it.
        def self.prepare_runs_for_drop_cap(runs, drop_cap)
          return runs unless drop_cap
          return runs if runs.empty?

          stripped_count = drop_cap.text.length
          first = runs.first
          return runs if first.text.length < stripped_count

          remaining_text = first.text[stripped_count..]
          return runs.drop(1) if remaining_text.nil? || remaining_text.empty?

          stripped_run = first.dup
          stripped_run.text = remaining_text
          [stripped_run] + runs[1..]
        end
        private_class_method :prepare_runs_for_drop_cap

        # Returns reduced wrap width for runs within the drop cap zone
        # (first `drop_cap_lines` runs). After the zone, returns full
        # width. Approximation: treats each run as one line. Proper
        # implementation would track actual line count per run.
        def self.drop_cap_wrap_width(full_width, drop_cap_width,
                                      drop_cap_lines, run_index)
          return full_width if drop_cap_width.zero? || drop_cap_lines.zero?
          return full_width if run_index >= drop_cap_lines

          full_width - drop_cap_width
        end
        private_class_method :drop_cap_wrap_width

        # Renders the drop cap for a paragraph (when declared and the
        # first paragraph of the chain). Wrap-around text is not yet
        # implemented — the drop cap renders as an enlarged glyph at
        # the paragraph's top-left; subsequent text may overlap it.
        # Marked as a follow-up in TODO 103.
        def self.emit_drop_cap(canvas, paragraph, context, frame_left,
                               cursor_y, first_paragraph)
          return nil unless first_paragraph
          return nil unless DropCap.active?(paragraph)

          base_size = paragraph.runs.first&.point_size || DEFAULT_SIZE
          leading = leading_for(paragraph, base_size)
          drop_cap = DropCap.layout(paragraph,
                                    font_metrics: context.font_metrics,
                                    base_size: base_size, leading: leading)
          return nil unless drop_cap

          drop_at_y = cursor_y - drop_cap.font_size + (base_size * 0.25)
          canvas.text(
            drop_cap.text,
            at: [frame_left, drop_at_y],
            font: font_for_run(paragraph.runs.first, context),
            size: drop_cap.font_size,
          )
        end
        private_class_method :emit_drop_cap

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
                            char_cursor, bottom_limit, paragraph_last: false)
          size = run.point_size || DEFAULT_SIZE
          glyphs = TextEngine::Shaper.shape(
            text: run.text, font: font, size: size,
          )
          lines = TextEngine::LineBreaker.break(
            glyphs: glyphs, frame_width: wrap_width,
          )
          justify_lines(lines, paragraph, wrap_width, paragraph_last)
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

          emit_run_lines(canvas, positioned, run, context, size, font,
                         bottom_limit, char_cursor)
          [positioned, next_y]
        end
        private_class_method :layout_run

        # True when the paragraph requests a forced break to the
        # next frame/column (StartParagraph). All break flavors act
        # at frame/column granularity.
        def self.paragraph_break?(paragraph)
          %w[NextPage NextColumn NextFrame NextOddPage NextEvenPage]
            .include?(paragraph.start_paragraph)
        end
        private_class_method :paragraph_break?

        # Justifies the run's lines; only the final line of the
        # paragraph's final run stays ragged under full
        # justification.
        def self.justify_lines(lines, paragraph, wrap_width,
                               paragraph_last)
          limits = TextEngine::Justifier::SpacingLimits.new(
            max_word_spacing: paragraph.maximum_word_spacing,
            max_letter_spacing: paragraph.maximum_letter_spacing,
          )
          lines.each_with_index do |line, index|
            TextEngine::Justifier.justify(
              line: line, frame_width: wrap_width,
              alignment: paragraph.alignment || :left,
              last_line: paragraph_last && index == lines.length - 1,
              limits: limits
            )
          end
        end
        private_class_method :justify_lines

        # Emits the run's positioned lines (clipped at the bottom
        # limit), recording positions and annotating the first line
        # with the run's ruby when present.
        def self.emit_run_lines(canvas, positioned, run, context, size,
                                font, bottom_limit, char_cursor)
          positioned.each_with_index do |line, index|
            break if line.y < bottom_limit

            emit_line(canvas, line, run, context, size)
            record_position(context, line, size, char_cursor)
            emit_ruby(canvas, run, line, size, font, context) if index.zero?
          end
        end
        private_class_method :emit_run_lines

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

        # Emits the run's ruby (phonetic annotation) above the first
        # line of the annotated run, centered over the line's width.
        # RubyFontSize defaults to half the base size; RubyPosition
        # values containing "Below" place it under the base text.
        # Approximation: IDML attaches ruby to a character range;
        # we annotate the whole first line.
        def self.emit_ruby(canvas, run, line, base_size, font, context)
          ruby_text = run.ruby_string
          return if ruby_text.nil? || ruby_text.empty?

          ruby_size = run.ruby_font_size || (base_size * RUBY_SIZE_FACTOR)
          glyphs = TextEngine::Shaper.shape(text: ruby_text, font: font,
                                            size: ruby_size)
          ruby_width = glyphs.sum(&:width)
          x = line.x + ((line.width - ruby_width) / 2)
          y = ruby_y(run, line, base_size, ruby_size)
          canvas.text(ruby_text, at: [x, y],
                                 font: font_for_run(run, context), size: ruby_size)
        end
        private_class_method :emit_ruby

        def self.ruby_y(run, line, base_size, ruby_size)
          if run.ruby_position.to_s.include?("Below")
            line.y - (base_size * 0.25) - ruby_size
          else
            line.y + (base_size * 0.45) + ruby_size
          end
        end
        private_class_method :ruby_y

        def self.leading_for(paragraph, size)
          TextEngine::VerticalLayout.leading_for(paragraph.auto_leading, size)
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
