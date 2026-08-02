# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      class GraphicLineRenderer
        def self.render(canvas, context)
          line = context.item
          return unless RectangleRenderer.strokeable?(line)

          color = context.color_resolver&.resolve(line.stroke_color)
          return unless color

          box = RectangleRenderer.placement_box(line, context.page_height)
          return unless box

          canvas.save_graphics_state do
            canvas.stroke_color(ColorHelper.to_canvas(color))
            canvas.line_width = line.stroke_weight
            canvas.move_to(box[:x], box[:y] + box[:height])
            canvas.line_to(box[:x] + box[:width], box[:y])
            canvas.stroke
          end
        end
      end
    end
  end
end