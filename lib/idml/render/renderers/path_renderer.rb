# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Path (standalone compound path) on a
      # Pdfrb::Content::Canvas. Delegates to RectangleRenderer which
      # draws the bounding box with fill/stroke. Approximation: a true
      # compound path would draw each sub-path from the EntirePath
      # list or PathPoint children; the bounding box renders the
      # correct extent and colors. See TODO 106 for refinement.
      class PathRenderer
        def self.render(canvas, context)
          RectangleRenderer.render(canvas, context)
        end
      end
    end
  end
end
