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

          Blending.wrap(canvas, rect.transparency_setting) do
            render_fill(canvas, rect, context, box)
            render_stroke(canvas, rect, context, box)
          end
        end

        def self.placement_box(rect, page_height)
          bounds = rect.geometric_bounds
          return nil unless bounds

          Geometry.placement_rect(bounds, rect.item_transform, page_height)
        end

        def self.render_fill(canvas, rect, context, box)
          return unless rect.fill_color
          return if rect.fill_color == "Color/None"

          if GradientResolver.gradient?(rect.fill_color)
            render_gradient_fill(canvas, rect, context, box)
            return
          end

          color = context.color_resolver&.resolve(rect.fill_color)
          return unless color

          canvas.fill_color(ColorHelper.to_canvas(color))
          canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
          canvas.fill
        end
        private_class_method :render_fill

        def self.render_gradient_fill(canvas, rect, context, box)
          gradient = gradient_for(rect, context)
          return unless gradient
          return unless gradient.gradient_stop.length >= 2

          stops = gradient_stops(gradient, context)
          return unless stops.length >= 2

          shading = if gradient.type == "Radial"
                      radial_shading(canvas, box, stops)
                    else
                      axial_shading(canvas, box, stops)
                    end
          canvas.rectangle(box[:x], box[:y], box[:width], box[:height])
          canvas.fill_shading(shading)
        end
        private_class_method :render_gradient_fill

        def self.axial_shading(canvas, box, stops)
          canvas.document.shadings.add_axial(
            from: [box[:x], box[:y] + box[:height]],
            to: [box[:x] + box[:width], box[:y]],
            stops: stops,
          )
        end
        private_class_method :axial_shading

        def self.radial_shading(canvas, box, stops)
          cx = box[:x] + (box[:width] / 2.0)
          cy = box[:y] + (box[:height] / 2.0)
          radius = [box[:width], box[:height]].max / 2.0
          canvas.document.shadings.add_radial(
            from: [cx, cy, 0.0],
            to: [cx, cy, radius],
            stops: stops,
          )
        end
        private_class_method :radial_shading

        def self.gradient_for(rect, context)
          graphic = context.package&.graphic
          return nil unless graphic

          graphic.gradient.find { |g| g.self_attr == rect.fill_color }
        end
        private_class_method :gradient_for

        def self.gradient_stops(gradient, context)
          gradient.gradient_stop.filter_map do |stop|
            color = context.color_resolver&.resolve(stop.stop_color)
            next unless color

            [stop.location || 0.0, ColorHelper.to_canvas(color)]
          end
        end
        private_class_method :gradient_stops

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
