# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Polygon on a Pdfrb::Content::Canvas as its
      # actual Bézier contours from PathGeometry (control handles
      # default to the anchors, so plain polygons render straight
      # edges). Falls back to the bounding-box rectangle when the
      # item carries no geometry.
      class PolygonRenderer
        def self.render(canvas, context)
          Contour.render(canvas, context)
        end
      end
    end
  end
end
