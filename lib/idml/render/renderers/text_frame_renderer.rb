# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML TextFrame on a Pdfrb::Content::Canvas. Extracts
      # styled runs via StyleResolver. When a FontMetrics is available
      # (pdfrb-backed), runs the full text engine pipeline (Shaper →
      # LineBreaker) for proper word-wrap; otherwise falls back to a
      # single text_rich call per frame.
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

          runs = StyleResolver.extract_runs(story)
          return if runs.empty?

          render_text(canvas, runs, context, box)
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

        def self.render_text(canvas, runs, context, box)
          font = context.font_metrics
          if font
            engine_render(canvas, runs, context, box, font)
          else
            simple_render(canvas, runs, context, box)
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

        def self.engine_render(canvas, runs, context, box, font)
          char_cursor = 0
          runs.each do |run|
            char_cursor = render_run_lines(
              canvas, run, context, box, font, char_cursor
            )
          end
        end
        private_class_method :engine_render

        # Emits one `canvas.text` call per line, after shaping and
        # line-breaking with real font metrics. Applies paragraph
        # alignment via `Justifier` so each line is offset within
        # the frame box per IDML `Justification`. Lines that fall
        # below the frame's bottom edge are clipped.
        #
        # Tracks absolute character position so HyperlinkEmitter can
        # compute precise link rects per source range.
        def self.render_run_lines(canvas, run, context, box, font, char_cursor)
          size = run.point_size
          glyphs = TextEngine::Shaper.shape(
            text: run.text, font: font, size: size,
          )
          lines = TextEngine::LineBreaker.break(
            glyphs: glyphs, frame_width: box[:width],
          )
          alignment = run.alignment || :left
          start_y = box[:y] + box[:height] - size
          cursor = char_cursor

          lines.each_with_index do |line, idx|
            line_y = start_y - (idx * size * LEADING_FACTOR)
            break if line_y < box[:y]

            TextEngine::Justifier.justify(line: line,
                                          frame_width: box[:width],
                                          alignment: alignment)
            line_x = box[:x] + line.x_offset
            line_width = line.width
            canvas.text(line_text(line),
                        at: [line_x, line_y],
                        font: context.font_ps_name,
                        size: size)
            record_position(context, line, line_x, line_y, line_width, size,
                            cursor)
            cursor += line.glyphs.length
          end
          cursor
        end
        private_class_method :render_run_lines

        def self.record_position(context, line, x, y, width, height, cursor)
          tracker = context.position_tracker
          return unless tracker
          return unless context.item&.self_attr

          glyph_count = line.glyphs.length
          tracker.add(context.item.self_attr,
                      start_char: cursor,
                      end_char: cursor + glyph_count,
                      x: x,
                      y: y,
                      width: width,
                      height: height)
        end
        private_class_method :record_position

        def self.line_text(line)
          line.glyphs.map { |g| [g.codepoint].pack("U") }.join
        end
        private_class_method :line_text

        # Fallback when no metrics are available: emit all runs as
        # one `text_rich` block, letting pdfrb measure advance widths.
        # Uses pdfrb's measurement API directly (no Fontisan).
        def self.simple_render(canvas, runs, context, box)
          runs_for = build_rich_runs(runs, context)
          return if runs_for.empty?

          first_size = runs.first.point_size
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
              font: context.font_ps_name,
              size: run.point_size,
            }
          end
        end
        private_class_method :build_rich_runs
      end
    end
  end
end
