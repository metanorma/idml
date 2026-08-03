# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Rectangle on a Pdfrb::Content::Canvas.
      class RectangleRenderer
        def self.render(canvas, context)
          rect = context.item
          return if rect.visible == false

          box = placement_box(rect, context.page_height)
          return unless box

          canvas.save_graphics_state do
            render_fill(canvas, rect, context, box)
            render_stroke(canvas, rect, context, box)
          end
        end

        def self.placement_box(rect, page_height)
          bounds = rect.geometric_bounds
          return nil unless bounds

          transform = Geometry.parse_transform(rect.item_transform)
          transformed = Geometry.transform_bounds(bounds, transform)
          Geometry.bounds_to_pdf_rect(transformed, page_height)
        end

        def self.render_fill(canvas, rect, context, box)
          return unless rect.fill_color
          return if rect.fill_color == "Color/None"

          color = context.color_resolver&.resolve(rect.fill_color)
          return unless color

          canvas.fill_color(ColorHelper.to_canvas(color))
          canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
          canvas.fill
        end
        private_class_method :render_fill

        def self.render_stroke(canvas, rect, context, box)
          return unless strokeable?(rect)

          color = context.color_resolver&.resolve(rect.stroke_color)
          return unless color

          canvas.stroke_color(ColorHelper.to_canvas(color))
          canvas.line_width = rect.stroke_weight
          canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
          canvas.stroke
        end
        private_class_method :render_stroke

        def self.strokeable?(rect)
          rect.stroke_color &&
            rect.stroke_color != "Color/None" &&
            rect.stroke_weight&.positive?
        end
      end
    end
  end
end
