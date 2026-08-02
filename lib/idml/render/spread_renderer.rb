# frozen_string_literal: true

module Idml
  module Render
    # Renders a typed `Parts::Spread` into a PDF content stream.
    # Iterates over the SpreadObject's child page items and dispatches
    # each to the appropriate renderer via PageItemRenderer. All data
    # comes from typed lutaml-model instances — no raw XML parsing.
    class SpreadRenderer
      def initialize(font_resolver: nil, font_ps_name: Render::DEFAULT_FONT,
                     package: nil)
        @font_resolver = font_resolver
        @font_ps_name = font_ps_name
        @package = package
      end

      def render(spread, page_width:, page_height:, image_refs: [])
        context_base = {
          package: @package,
          font_resolver: @font_resolver,
          color_resolver: build_color_resolver,
          font_ps_name: @font_ps_name,
          page_width: page_width,
          page_height: page_height,
        }

        ops = []
        ops << Path.save_state
        ops << render_background(page_width, page_height)
        ops << render_images(image_refs)
        spread.each_page_item do |item|
          context = RenderContext.new(context_base.merge(item: item))
          ops << PageItemRenderer.render(context)
        end
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
          placement = ref[:placement]
          Image.draw_image(
            name: ref[:name], x: placement[:x], y: placement[:y],
            scale_x: placement[:scale_x], scale_y: placement[:scale_y]
          )
        end.join("\n")
      end

      def build_color_resolver
        return nil unless @package&.graphic

        ColorResolver.new(@package.graphic)
      end
    end
  end
end
