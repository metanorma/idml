# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Polygon as a PDF filled and/or stroked path.
      # Uses geometric_bounds from PathPointArray for a bounding-box
      # approximation. Full vertex-by-vertex polygon rendering is a
      # future enhancement.
      class PolygonRenderer
        def self.render(context)
          poly = context.item
          return nil if poly.visible == false

          box = RectangleRenderer.placement_box(poly, context.page_height)
          return nil unless box

          ops = []
          ops << Render::Path.save_state
          ops << fill_ops(poly, context, box)
          ops << stroke_ops(poly, context, box)
          ops << Render::Path.restore_state
          ops.compact.join("\n")
        end

        def self.fill_ops(poly, context, box)
          return nil unless poly.fill_color && poly.fill_color != "Color/None"

          color = context.color_resolver&.resolve(poly.fill_color)
          return nil unless color

          [
            Render::Color.fill_op(color),
            Render::Path.rectangle(x: box[:x], y: box[:y],
                                   width: box[:width], height: box[:height]),
            Render::Path.fill,
          ].join("\n")
        end
        private_class_method :fill_ops

        def self.stroke_ops(poly, context, box)
          return nil unless RectangleRenderer.strokeable?(poly)

          color = context.color_resolver&.resolve(poly.stroke_color)
          return nil unless color

          [
            Render::Color.stroke_op(color),
            Render::Path.stroke_width(poly.stroke_weight),
            Render::Path.rectangle(x: box[:x], y: box[:y],
                                   width: box[:width], height: box[:height]),
            Render::Path.stroke,
          ].join("\n")
        end
        private_class_method :stroke_ops
      end
    end
  end
end
