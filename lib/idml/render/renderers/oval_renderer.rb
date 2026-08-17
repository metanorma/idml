# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Oval on a Pdfrb::Content::Canvas as a true
      # Bézier ellipse from its PathGeometry (which preserves any
      # rotation in the ItemTransform). Falls back to the
      # bounding-box rectangle when the item carries no geometry.
      class OvalRenderer
        def self.render(canvas, context)
          Contour.render(canvas, context)
        end
      end
    end
  end
end
