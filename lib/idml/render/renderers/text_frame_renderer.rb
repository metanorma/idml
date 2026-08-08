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
          return unless chain_head?(frame)

          story = context.package&.story_by_id(frame.parent_story)
          return unless story

          box = frame_box(frame, context.page_height)
          render_inline_tables(canvas, story, box, context)

          paragraphs = StyleResolver.extract_paragraphs(story)
          return if paragraphs.empty?

          render_text(canvas, paragraphs, context, box)
        end

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

        def self.render_text(canvas, paragraphs, context, box)
          font = context.font_metrics
          if font
            engine_render(canvas, paragraphs, context, box, font)
          else
            simple_render(canvas, paragraphs, context, box)
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

        # Walks paragraphs and emits one `canvas.text` per line via
        # the Shaper → LineBreaker → Justifier → VerticalLayout
        # pipeline. Cursor y descends monotonically across
        # paragraphs so text flows top-to-bottom (the previous
        # implementation reset every run to the frame top).
        def self.engine_render(canvas, paragraphs, context, box, font)
          layout_frame = layout_frame(context.item, box)
          cursor_y = box[:y] + box[:height] - (layout_frame.inset_top || 0)
          bottom_limit = TextEngine::VerticalLayout.bottom_limit(layout_frame)
          char_cursor = 0

          paragraphs.each do |paragraph|
            break if cursor_y < bottom_limit

            cursor_y, char_cursor = render_paragraph(
              canvas, paragraph, context, layout_frame, font,
              cursor_y, bottom_limit, char_cursor
            )
          end
        end
        private_class_method :engine_render

        def self.render_paragraph(canvas, paragraph, context, layout_frame,
                                  font, cursor_y, bottom_limit, char_cursor)
          wrap_width = TextEngine::VerticalLayout.wrap_width(
            layout_frame, paragraph.right_indent || 0
          )
          para_attrs = paragraph_attrs(paragraph)
          cursor_y, char_cursor = render_runs(
            canvas, paragraph, context, layout_frame, font,
            wrap_width, cursor_y, bottom_limit, char_cursor, para_attrs
          )
          [cursor_y - para_attrs[:space_after], char_cursor]
        end
        private_class_method :render_paragraph

        def self.paragraph_attrs(paragraph)
          {
            space_before: paragraph.space_before || 0,
            space_after: paragraph.space_after || 0,
            first_line_indent: paragraph.first_line_indent || 0,
            left_indent: paragraph.left_indent || 0,
          }
        end
        private_class_method :paragraph_attrs

        def self.render_runs(canvas, paragraph, context, layout_frame, font,
                             wrap_width, cursor_y, bottom_limit, char_cursor,
                             para_attrs)
          space_before = para_attrs[:space_before]
          paragraph.runs.each do |run|
            break if cursor_y < bottom_limit

            positioned, next_y = layout_run(
              canvas, run, paragraph, context, layout_frame, font,
              wrap_width, cursor_y, space_before,
              para_attrs[:first_line_indent], para_attrs[:left_indent],
              char_cursor
            )
            char_cursor += positioned.length
            cursor_y = next_y
            space_before = 0
          end
          [cursor_y, char_cursor]
        end
        private_class_method :render_runs

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
          0 # only on the paragraph's first line

          bottom_limit = TextEngine::VerticalLayout.bottom_limit(layout_frame)
          positioned.each do |line|
            break if line.y < bottom_limit

            canvas.text(
              line_text(line),
              at: [line.x, line.y],
              font: font_for_run(run, context),
              size: size,
            )
            record_position(context, line, size, char_cursor)
          end
          [positioned, next_y]
        end
        private_class_method :layout_run

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
        def self.simple_render(canvas, paragraphs, context, box)
          runs = paragraphs.flat_map(&:runs)
          return if runs.empty?

          runs_for = build_rich_runs(runs, context)
          first_size = runs.first.point_size || DEFAULT_SIZE
          canvas.text_rich(
            runs_for,
            at: [box[:x], box[:y] + box[:height] - first_size],
          )
        end
        private_class_method :simple_render

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
