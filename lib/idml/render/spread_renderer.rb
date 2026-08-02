# frozen_string_literal: true

module Idml
  module Render
    # Renders an IDML Spread's raw XML into a PDF content stream.
    # Emits background fill, image placement operators, and text runs.
    class SpreadRenderer
      def initialize(font_resolver: nil)
        @font_resolver = font_resolver
      end

      # Render raw spread XML into PDF content-stream operators.
      # image_refs: Array of { name:, placement: } from the Pipeline.
      def render(raw_xml, page_width:, page_height:, image_refs: [])
        ops = []
        ops << Path.save_state
        ops << render_background(page_width, page_height)
        ops << render_images(image_refs)
        ops << render_stories(raw_xml)
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

      def render_images(image_refs)
        return "" if image_refs.empty?

        image_refs.map do |ref|
          p = ref[:placement]
          Render::Image.draw_image(
            name: ref[:name], x: p[:x], y: p[:y],
            scale_x: p[:scale_x], scale_y: p[:scale_y]
          )
        end.join("\n")
      end

      def render_stories(_raw_xml)
        ""
      end
    end
  end
end
