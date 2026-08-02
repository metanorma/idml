# frozen_string_literal: true

module Idml
  module Render
    # Converts IDML color hashes to pdfrb Canvas color arrays.
    # Centralizes the mapping so all renderers use a consistent format.
    module ColorHelper
      module_function

      # Accepts a ColorResolver hash ({ model: :rgb, r:, g:, b: } or
      # { model: :cmyk, c:, m:, y:, k: }) and returns the pdfrb Canvas
      # array format ([:rgb, r, g, b] or [:cmyk, c, m, y, k]).
      def to_canvas(color)
        return nil unless color

        case color[:model]
        when :rgb then [:rgb, color[:r], color[:g], color[:b]]
        when :cmyk then [:cmyk, color[:c], color[:m], color[:y], color[:k]]
        end
      end
    end
  end
end