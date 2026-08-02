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

          canvas.save_graphics_state do
            if poly.fill_color && poly.fill_color != "Color/None"
              color = context.color_resolver&.resolve(poly.fill_color)
              if color
                canvas.fill_color(ColorHelper.to_canvas(color))
                canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
                canvas.fill
              end
            end

            if RectangleRenderer.strokeable?(poly)
              color = context.color_resolver&.resolve(poly.stroke_color)
              if color
                canvas.stroke_color(ColorHelper.to_canvas(color))
                canvas.line_width = poly.stroke_weight
                canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
                canvas.stroke
              end
            end
          end
        end
      end
    end
  end
end