# frozen_string_literal: true

module Idml
  module Render
    # Renders a typed `Parts::Spread` into a PDF content stream.
    # Iterates over the SpreadObject's child page items and dispatches
    # each to a type-specific render method. All data comes from typed
    # lutaml-model instances — no raw XML parsing.
    class SpreadRenderer
      def initialize(font_resolver: nil, font_ps_name: Render::DEFAULT_FONT,
                     package: nil)
        @font_resolver = font_resolver
        @font_ps_name = font_ps_name
        @package = package
      end

      def render(spread, page_width:, page_height:, image_refs: [])
        ops = []
        ops << Path.save_state
        ops << render_background(page_width, page_height)
        ops << render_images(image_refs)
        spread.each_page_item do |item|
          ops << render_page_item(item, page_height)
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
          p = ref[:placement]
          Image.draw_image(
            name: ref[:name], x: p[:x], y: p[:y],
            scale_x: p[:scale_x], scale_y: p[:scale_y]
          )
        end.join("\n")
      end

      def render_page_item(item, page_height)
        case item
        when Idml::Elements::Rectangle
          render_rectangle(item, page_height)
        when Idml::Elements::TextFrame
          render_text_frame(item, page_height)
        when Idml::Elements::Polygon
          render_polygon(item, page_height)
        when Idml::Elements::GraphicLine
          render_graphic_line(item, page_height)
        end
      end

      def render_rectangle(rect, _page_height)
        return nil unless rect.fill_color && rect.fill_color != "Color/None"

        color = resolve_color(rect.fill_color)
        return nil unless color

        ops = []
        ops << color_fill_op(color)
        ops << Path.rectangle(x: 0, y: 0, width: 100, height: 100)
        ops << Path.fill
        ops.join("\n")
      end

      def render_polygon(poly, _page_height)
        return nil unless poly.fill_color && poly.fill_color != "Color/None"

        nil
      end

      def render_graphic_line(line, _page_height)
        return nil unless line.stroke_color && line.stroke_color != "Color/None"

        nil
      end

      def render_text_frame(frame, page_height)
        return nil unless frame.parent_story

        story = @package&.story_by_id(frame.parent_story)
        return nil unless story

        text = story.text_content
        return nil if text.empty?

        Text.show_run(
          text_string: Text.escape(text.slice(0, 200)),
          font_name: @font_ps_name,
          size: 12,
          x: 72,
          y: page_height - 72,
        )
      end

      def resolve_color(name)
        return nil unless @package&.graphic

        @color_resolver ||= ColorResolver.new(@package.graphic)
        @color_resolver.resolve(name)
      end

      def color_fill_op(color)
        case color[:model]
        when :rgb
          Color.fill_rgb(color[:r], color[:g], color[:b])
        when :cmyk
          Color.fill_cmyk(color[:c], color[:m], color[:y], color[:k])
        end
      end
    end
  end
end
