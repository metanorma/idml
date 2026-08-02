# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML GraphicLine as a stroked PDF path. Uses
      # PathPointArray bounds for endpoint coordinates, applies
      # ItemTransform, and resolves StrokeColor via ColorResolver.
      class GraphicLineRenderer
        def self.render(context)
          line = context.item
          return nil unless RectangleRenderer.strokeable?(line)

          color = context.color_resolver&.resolve(line.stroke_color)
          return nil unless color

          box = RectangleRenderer.placement_box(line, context.page_height)
          return nil unless box

          [
            Render::Path.save_state,
            Render::Color.stroke_op(color),
            Render::Path.stroke_width(line.stroke_weight),
            Render::Path.move_to(box[:x], box[:y] + box[:height]),
            Render::Path.line_to(box[:x] + box[:width], box[:y]),
            Render::Path.stroke,
            Render::Path.restore_state,
          ].join("\n")
        end
      end
    end
  end
end
