# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML Polygon as a PDF filled path. Placeholder until
      # PathPointArray geometry is modeled (TODO 28/30).
      class PolygonRenderer
        def self.render(_context)
          nil
        end
      end
    end
  end
end
