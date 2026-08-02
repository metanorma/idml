# frozen_string_literal: true

module Idml
  module Render
    # Renders an IDML Spread's page items into a PDF content stream.
    # Uses the text engine for text layout and the render operators
    # for shapes and colors.
    class SpreadRenderer
      def initialize(font_resolver: nil)
        @font_resolver = font_resolver
      end

      # Render a spread into PDF content-stream operators.
      # Returns a String of PDF operators.
      def render(spread, page_width:, page_height:)
        ops = []
        ops << Path.save_state
        ops << render_background(page_width, page_height)
        ops << render_stories(spread)
        ops << Path.restore_state
        ops.compact.join("\n")
      end

      private

      def render_background(width, height)
        [
          Color.white_fill,
          Path.rectangle(x: 0, y: 0, width: width, height: height),
          Path.fill,
        ].join("\n")
      end

      # Render text from the spread's linked stories.
      # The text engine shapes, breaks, justifies, and positions.
      def render_stories(spread)
        return "" unless @font_resolver

        ops = []
        stories = linked_stories(spread)

        stories.each do |story_text, x, y, size|
          font = resolve_font
          next unless font

          glyphs = shape_text(story_text, font, size)
          positioned = layout_glyphs(glyphs, x, y, size)
          ops << render_text_runs(positioned, x, y, size)
        end
        ops.join("\n")
      end

      def linked_stories(_spread)
        []
      end

      def resolve_font
        @font_resolver&.resolve(family_name: "Helvetica", style_name: "Regular")
      end

      def shape_text(text, font, size)
        shaper = TextEngine::Shaper.new(font, size)
        shaper.shape(text)
      end

      def layout_glyphs(glyphs, x, y, size)
        frame = TextEngine::VerticalLayout::Frame.new(
          x, y, 400, 600, 0, 0, 0, 0
        )
        lines = TextEngine::LineBreaker.break(glyphs: glyphs, frame_width: 400)
        lines.each { |l| TextEngine::Justifier.justify(line: l, frame_width: 400) }
        TextEngine::VerticalLayout.layout(
          lines: lines, frame: frame, font_size: size, leading: size * 1.2,
        )
      end

      def render_text_runs(positioned, base_x, base_y, size)
        return "" if positioned.empty?

        font_name = Render::DEFAULT_FONT
        text_str = positioned.map { |g| [g.codepoint].pack("U") }.join
        Text.show_run(
          text_string: text_str,
          font_name: font_name,
          size: size,
          x: base_x,
          y: base_y,
        )
      end
    end
  end
end
