# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML TextFrame by resolving its ParentStory to a
      # Parts::Story, extracting styled runs via StyleResolver, and
      # emitting PDF text operators. When a FontMetrics is available,
      # runs the full text engine pipeline (Shaper → LineBreaker →
      # Justifier → VerticalLayout); otherwise falls back to simple
      # text output. Frame position/size derived from geometric_bounds.
      class TextFrameRenderer
        DEFAULT_SIZE = 12.0
        MAX_TEXT = 1000
        DEFAULT_FRAME_WIDTH = 400.0

        def self.render(context)
          frame = context.item
          return nil unless frame.parent_story

          story = context.package&.story_by_id(frame.parent_story)
          return nil unless story

          runs = StyleResolver.extract_runs(story)
          return nil if runs.empty?

          box = frame_box(frame, context.page_height)
          emit_runs(runs, context, box)
        end

        def self.frame_box(frame, page_height)
          bounds = frame.geometric_bounds
          return default_box(page_height) unless bounds

          transform = Geometry.parse_transform(frame.item_transform)
          transformed = Geometry.transform_bounds(bounds, transform)
          Geometry.bounds_to_pdf_rect(transformed, page_height)
        end

        def self.default_box(page_height)
          { x: 72.0, y: page_height - 72.0,
            width: DEFAULT_FRAME_WIDTH, height: 600.0 }
        end

        def self.emit_runs(runs, context, box)
          font = resolve_font(context)
          return simple_text(runs, context, box) unless font

          shaped_text(runs, context, box, font)
        end
        private_class_method :emit_runs

        def self.resolve_font(context)
          return nil unless context.font_resolver

          context.font_resolver.resolve(
            family_name: Render::DEFAULT_FONT, style_name: "Regular",
          )
        end
        private_class_method :resolve_font

        def self.simple_text(runs, context, box)
          text = runs.map(&:text).join
          Render::Text.show_run(
            text_string: Render::Text.escape(text.slice(0, MAX_TEXT)),
            font_name: context.font_ps_name,
            size: runs.first.point_size,
            x: box[:x],
            y: box[:y] + box[:height] - runs.first.point_size,
          )
        end
        private_class_method :simple_text

        def self.shaped_text(runs, context, box, font)
          run = runs.first
          size = run.point_size
          text = run.text

          glyphs = TextEngine::Shaper.shape(text: text, font: font, size: size)
          lines = TextEngine::LineBreaker.break(glyphs: glyphs,
                                                frame_width: box[:width])
          lines.each do |line|
            TextEngine::Justifier.justify(line: line, frame_width: box[:width])
          end
          frame = TextEngine::VerticalLayout::Frame.new(
            box[:x], box[:y], box[:width], box[:height], 0, 0, 0, 0
          )
          positioned = TextEngine::VerticalLayout.layout(
            lines: lines, frame: frame, font_size: size, leading: size * 1.2,
          )
          return "" if positioned.empty?

          Render::Text.show_run(
            text_string: positioned.map { |g| [g.codepoint].pack("U") }.join,
            font_name: context.font_ps_name,
            size: size,
            x: positioned.first.x,
            y: positioned.first.y,
          )
        end
        private_class_method :shaped_text
      end
    end
  end
end
