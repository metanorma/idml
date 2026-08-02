# frozen_string_literal: true

module Idml
  module Render
    # Converts IDML color values to PDF content-stream operators.
    module Color
      module_function

      # RGB fill: `r g b rg`. Values 0.0–1.0.
      def fill_rgb(r, g, b)
        format("%<r>.4f %<g>.4f %<b>.4f rg", r: r, g: g, b: b)
      end

      # RGB stroke: `r g b RG`.
      def stroke_rgb(r, g, b)
        format("%<r>.4f %<g>.4f %<b>.4f RG", r: r, g: g, b: b)
      end

      # CMYK fill: `c m y k k`.
      def fill_cmyk(c, m, y, k)
        format("%<c>.4f %<m>.4f %<y>.4f %<k>.4f k", c: c, m: m, y: y, k: k)
      end

      # Parse IDML color space value (space-separated 0–255 or 0–100
      # depending on model) to normalized 0.0–1.0.
      def normalize_channel(value, max = 255)
        value.to_f / max
      end

      # Black fill (common default).
      def black_fill
        "0 g"
      end

      # White fill.
      def white_fill
        "1 g"
      end
    end
  end
end
