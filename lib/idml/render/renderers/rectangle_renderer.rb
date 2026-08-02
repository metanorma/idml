# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Rectangle as a PDF filled and/or stroked
      # rectangle. Geometry derived from PathPointType anchors via
      # `geometric_bounds`, then transformed by ItemTransform and
      # Y-flipped for PDF coordinates.
      class RectangleRenderer
        def self.render(context)
          rect = context.item
          return nil if rect.visible == false

          box = placement_box(rect, context.page_height)
          return nil unless box

          ops = []
          ops << Render::Path.save_state
          ops << render_fill(rect, context, box)
          ops << render_stroke(rect, context, box)
          ops << Render::Path.restore_state
          ops.compact.join("\n")
        end

        def self.placement_box(rect, page_height)
          bounds = rect.geometric_bounds
          return nil unless bounds

          transform = Geometry.parse_transform(rect.item_transform)
          transformed = Geometry.transform_bounds(bounds, transform)
          Geometry.bounds_to_pdf_rect(transformed, page_height)
        end

        def self.render_fill(rect, context, box)
          return nil unless rect.fill_color
          return nil if rect.fill_color == "Color/None"

          return render_gradient_fill(rect, context, box) if Render::GradientResolver.gradient?(rect.fill_color)

          color = context.color_resolver&.resolve(rect.fill_color)
          return nil unless color

          [
            Render::Color.fill_op(color),
            Render::Path.rectangle(x: box[:x], y: box[:y],
                                   width: box[:width], height: box[:height]),
            Render::Path.fill,
          ].join("\n")
        end
        private_class_method :render_fill

        def self.render_gradient_fill(rect, context, box)
          resolver = gradient_resolver_for(context)
          return nil unless resolver

          resolver.render_gradient(rect.fill_color, x: box[:x], y: box[:y],
                                                    width: box[:width],
                                                    height: box[:height],
                                                    color_resolver: context.color_resolver)
        end
        private_class_method :render_gradient_fill

        def self.gradient_resolver_for(context)
          graphic = context.package&.graphic
          return nil unless graphic

          Render::GradientResolver.build(graphic)
        end
        private_class_method :gradient_resolver_for

        def self.render_stroke(rect, context, box)
          return nil unless strokeable?(rect)

          color = context.color_resolver&.resolve(rect.stroke_color)
          return nil unless color

          [
            Render::Color.stroke_op(color),
            Render::Path.stroke_width(rect.stroke_weight),
            Render::Path.rectangle(x: box[:x], y: box[:y],
                                   width: box[:width], height: box[:height]),
            Render::Path.stroke,
          ].join("\n")
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
