# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Path (standalone compound path) on a
      # Pdfrb::Content::Canvas as its actual Bézier contours — one
      # subpath per GeometryPathType, closed or open per PathOpen.
      # Falls back to the bounding-box rectangle when the item
      # carries no geometry.
      class PathRenderer
        def self.render(canvas, context)
          Contour.render(canvas, context)
        end
      end
    end
  end
end
