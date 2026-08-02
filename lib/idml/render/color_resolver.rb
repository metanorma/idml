# frozen_string_literal: true

module Idml
  module Render
    # Resolves IDML color references to concrete RGB or CMYK values.
    # Looks up color names in the package's Resources/Graphic.xml part.
    class ColorResolver
      SPECIAL_NONE = "Color/None"
      SPECIAL_REGISTRATION = "Color/[Registration]"

      def initialize(graphic_part)
        @graphic = graphic_part
        @cache = {}
      end

      # Resolve a color name like "Color/Red" to a hash:
      #   { model: :rgb, r:, g:, b: }     (0.0–1.0)
      #   { model: :cmyk, c:, m:, y:, k: } (0.0–1.0)
      # Returns nil for [None] or unknown colors.
      def resolve(name)
        return nil if name.nil? || name == SPECIAL_NONE
        return registration_black if name == SPECIAL_REGISTRATION

        @cache[name] ||= lookup(name)
      end

      private

      def lookup(name)
        entry = find_color(name) || find_swatch(name)
        return nil unless entry

        parse_color(entry)
      end

      def find_color(name)
        @graphic.color.find { |c| c.self_attr == name }
      end

      def find_swatch(name)
        @graphic.swatch.find { |s| s.self_attr == name }
      end

      def parse_color(entry)
        values = (entry.color_value || "").split(/\s+/).map(&:to_f)
        case entry.space
        when "RGB"
          { model: :rgb,
            r: normalize(values[0], 255),
            g: normalize(values[1], 255),
            b: normalize(values[2], 255) }
        when "CMYK"
          { model: :cmyk,
            c: normalize(values[0], 100),
            m: normalize(values[1], 100),
            y: normalize(values[2], 100),
            k: normalize(values[3], 100) }
        end
      end

      def normalize(value, max)
        return 0.0 unless value

        (value / max).clamp(0.0, 1.0)
      end

      def registration_black
        { model: :cmyk, c: 1.0, m: 1.0, y: 1.0, k: 1.0 }
      end
    end
  end
end
