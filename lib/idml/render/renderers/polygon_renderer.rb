# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      class PolygonRenderer
        def self.render(canvas, context)
          poly = context.item
          return if poly.visible == false

          box = RectangleRenderer.placement_box(poly, context.page_height)
          return unless box

          Blending.wrap(canvas, poly.transparency_setting) do
            render_fill(canvas, poly, context, box)
            render_stroke(canvas, poly, context, box)
          end
        end

        def self.render_fill(canvas, poly, context, box)
          return unless poly.fill_color && poly.fill_color != "Color/None"

          color = context.color_resolver&.resolve(poly.fill_color)
          return unless color

          canvas.fill_color(ColorHelper.to_canvas(color))
          canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
          canvas.fill
        end
        private_class_method :render_fill

        def self.render_stroke(canvas, poly, context, box)
          return unless RectangleRenderer.strokeable?(poly)

          color = context.color_resolver&.resolve(poly.stroke_color)
          return unless color

          canvas.stroke_color(ColorHelper.to_canvas(color))
          canvas.line_width = poly.stroke_weight
          canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
          canvas.stroke
        end
        private_class_method :render_stroke
      end
    end
  end
end
