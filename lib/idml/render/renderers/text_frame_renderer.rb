# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML TextFrame on a Pdfrb::Content::Canvas. Extracts
      # styled runs via StyleResolver. When a FontMetrics is available,
      # runs the full text engine pipeline (Shaper → LineBreaker →
      # VerticalLayout) for proper word-wrap; otherwise falls back to
      # simple one-text-per-run positioning.
      class TextFrameRenderer
        DEFAULT_SIZE = 12.0
        LEADING_FACTOR = 1.2

        def self.render(canvas, context)
          frame = context.item
          return unless frame.parent_story
          return unless chain_head?(frame)

          story = context.package&.story_by_id(frame.parent_story)
          return unless story

          runs = StyleResolver.extract_runs(story)
          return if runs.empty?

          box = frame_box(frame, context.page_height)
          render_text(canvas, runs, context, box)
        end

        def self.render_text(canvas, runs, context, box)
          font = resolve_font_metrics(context)
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

        def self.resolve_font_metrics(context)
          return nil unless context.font_resolver

          context.font_resolver.resolve(
            family_name: Render::DEFAULT_FONT, style_name: "Regular",
          )
        end
        private_class_method :resolve_font_metrics

        def self.simple_render(canvas, runs, context, box)
          runs.each_with_index do |run, index|
            y = box[:y] + box[:height] -
              ((index + 1) * run.point_size * LEADING_FACTOR)
            canvas.text(run.text, at: [box[:x], y],
                                  font: context.font_ps_name,
                                  size: run.point_size)
          end
        end
        private_class_method :simple_render

        def self.engine_render(canvas, runs, context, box, font)
          baseline_y = box[:y] + box[:height] - runs.first.point_size

          runs.each do |run|
            baseline_y = render_run_lines(
              canvas, run, context, box, font, baseline_y
            )
          end
        end
        private_class_method :engine_render

        def self.render_run_lines(canvas, run, context, box, font, baseline_y)
          size = run.point_size
          glyphs = TextEngine::Shaper.shape(
            text: run.text, font: font, size: size,
          )
          lines = TextEngine::LineBreaker.break(
            glyphs: glyphs, frame_width: box[:width],
          )

          line_texts = []
          lines.each do |line|
            break if baseline_y < box[:y]

            line_texts << line.glyphs.map { |g| [g.codepoint].pack("U") }.join
            baseline_y -= size * LEADING_FACTOR
          end

          if line_texts.any?
            canvas.text_lines(line_texts,
                              font: context.font_ps_name,
                              size: size,
                              at: [box[:x], box[:y] + box[:height] - size],
                              leading: size * LEADING_FACTOR)
          end
          baseline_y
        end
        private_class_method :render_run_lines
      end
    end
  end
end
