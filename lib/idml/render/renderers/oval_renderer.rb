# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Oval on a Pdfrb::Content::Canvas. Delegates to
      # RectangleRenderer which draws the bounding box with fill/stroke.
      # Approximation: a true ellipse would generate bezier anchor and
      # control points from the PathGeometry; the bounding box renders
      # the correct extent and colors. See TODO 106 for refinement.
      class OvalRenderer
        def self.render(canvas, context)
          RectangleRenderer.render(canvas, context)
        end
      end
    end
  end
end
