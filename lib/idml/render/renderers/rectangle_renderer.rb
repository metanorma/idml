# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Rectangle on a Pdfrb::Content::Canvas: an
      # axis-aligned rectangle from the item's placement box, with
      # fill / stroke / gradient painting delegated to ShapePaint.
      class RectangleRenderer
        def self.render(canvas, context)
          rect = context.item
          return if rect.visible == false

          box = Placement.box(rect, context.page_height)
          return unless box

          ShapePaint.paint(canvas, rect, context) do |c|
            c.rectangle(box[:x], box[:y], box[:width], box[:height])
          end
        end
      end
    end
  end
end
