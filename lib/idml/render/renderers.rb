# frozen_string_literal: true

module Idml
  module Render
    # Namespace for per-type page-item renderers. Each class has a
    # `self.render(context)` class method that returns a string of PDF
    # content-stream operators (or nil to skip the item).
    module Renderers
    end
  end
end
