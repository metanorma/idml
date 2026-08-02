# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Rectangle as a PDF filled and/or stroked
      # rectangle. Geometry derived from PathPointType anchors via
      # `geometric_bounds`. Fill color resolved via ColorResolver.
      class RectangleRenderer
        def self.render(context)
          rect = context.item
          return nil unless rect.fill_color
          return nil if rect.fill_color == "Color/None"

          color = context.color_resolver&.resolve(rect.fill_color)
          return nil unless color

          box = placement_box(rect, context.page_height)
          return nil unless box

          [
            Render::Path.save_state,
            color_fill_op(color),
            Render::Path.rectangle(x: box[:x], y: box[:y],
                                   width: box[:width],
                                   height: box[:height]),
            Render::Path.fill,
            Render::Path.restore_state,
          ].join("\n")
        end

        # Convert IDML geometric_bounds [y1, x1, y2, x2] to PDF
        # placement { x:, y:, width:, height: } with Y-axis flipped.
        def self.placement_box(rect, page_height)
          bounds = rect.geometric_bounds
          return nil unless bounds

          y1, x1, y2, x2 = bounds
          {
            x: x1,
            y: page_height - y2,
            width: x2 - x1,
            height: y2 - y1,
          }
        end

        def self.color_fill_op(color)
          case color[:model]
          when :rgb
            Render::Color.fill_rgb(color[:r], color[:g], color[:b])
          when :cmyk
            Render::Color.fill_cmyk(color[:c], color[:m], color[:y], color[:k])
          end
        end
        private_class_method :color_fill_op
      end
    end
  end
end
