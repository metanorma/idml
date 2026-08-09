# frozen_string: true

module Idml
  module Render
    # Converts IDML color hashes to pdfrb Canvas color arrays and
    # applies tint scaling. Centralizes the mapping so all renderers
    # use a consistent format.
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

      # Scales a color's components by `tint` (1.0 = full strength,
      # 0.5 = halved). Tint is the IDML mechanism for lightening a
      # color without defining a new one. Returns the original color
      # unchanged when tint is nil or >= 1.0. Single canonical
      # implementation — CharacterStyle, ParagraphRules, and any
      # future caller should all delegate here.
      def apply_tint(color, tint)
        return color unless color
        return color unless tint
        return color if tint >= 1.0

        case color[:model]
        when :rgb
          { model: :rgb, r: color[:r] * tint, g: color[:g] * tint,
            b: color[:b] * tint }
        when :cmyk
          { model: :cmyk, c: color[:c] * tint, m: color[:m] * tint,
            y: color[:y] * tint, k: color[:k] * tint }
        else
          color
        end
      end
    end
  end
end
