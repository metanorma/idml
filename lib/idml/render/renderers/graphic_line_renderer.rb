# frozen_string_literal: true

module Idml
  module Render
    module Renderers
      # Renders an IDML GraphicLine as a stroked PDF path. Placeholder
      # until PathPointArray geometry is modeled (TODO 28/30).
      class GraphicLineRenderer
        def self.render(_context)
          nil
        end
      end
    end
  end
end
