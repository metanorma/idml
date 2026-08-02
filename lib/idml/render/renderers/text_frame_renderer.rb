# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML TextFrame by resolving its ParentStory to a
      # Parts::Story, extracting text content, and emitting PDF text
      # operators. When a FontMetrics is available, runs the full text
      # engine pipeline (Shaper → LineBreaker → Justifier →
      # VerticalLayout); otherwise falls back to a simple text dump.
      class TextFrameRenderer
        DEFAULT_SIZE = 12
        MAX_TEXT = 500

        def self.render(context)
          frame = context.item
          return nil unless frame.parent_story

          story = context.package&.story_by_id(frame.parent_story)
          return nil unless story

          text = story.text_content
          return nil if text.empty?

          emit_text(text, context)
        end

        def self.emit_text(text, context)
          font = resolve_font(context)
          return simple_text_run(text, context) unless font

          shaped_text_run(text, context, font)
        end
        private_class_method :emit_text

        def self.resolve_font(context)
          return nil unless context.font_resolver

          context.font_resolver.resolve(
            family_name: Render::DEFAULT_FONT, style_name: "Regular",
          )
        end
        private_class_method :resolve_font

        def self.simple_text_run(text, context)
          Render::Text.show_run(
            text_string: Render::Text.escape(text.slice(0, MAX_TEXT)),
            font_name: context.font_ps_name,
            size: DEFAULT_SIZE,
            x: 72,
            y: context.page_height - 72,
          )
        end
        private_class_method :simple_text_run

        def self.shaped_text_run(text, context, font)
          size = DEFAULT_SIZE
          glyphs = TextEngine::Shaper.shape(text: text, font: font, size: size)
          lines = TextEngine::LineBreaker.break(glyphs: glyphs,
                                                frame_width: 400)
          lines.each do |line|
            TextEngine::Justifier.justify(line: line, frame_width: 400)
          end
          frame = TextEngine::VerticalLayout::Frame.new(
            72, context.page_height - 72, 400, 600, 0, 0, 0, 0
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
        private_class_method :shaped_text_run
      end
    end
  end
end
