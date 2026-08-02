# frozen_string_literal: true

module Idml
  module Render
    # Converts IDML geometric page items to PDF path operators.
    module Path
      module_function

      # Rectangle → `x y w h re`
      def rectangle(x:, y:, width:, height:)
        format("%<x>.2f %<y>.2f %<w>.2f %<h>.2f re", x: x, y: y, w: width,
                                                     h: height)
      end

      # Save graphics state
      def save_state
        "q"
      end

      # Restore graphics state
      def restore_state
        "Q"
      end

      # Transformation matrix: `a b c d e f cm`
      def transform(a:, b:, c:, d:, e:, f:)
        format("%<a>.4f %<b>.4f %<c>.4f %<d>.4f %<e>.2f %<f>.2f cm",
               a: a, b: b, c: c, d: d, e: e, f: f)
      end

      # Fill the current path (nonzero winding).
      def fill
        "f"
      end

      # Stroke the current path.
      def stroke
        "S"
      end

      # Close, fill, and stroke the current path.
      def fill_stroke
        "B"
      end

      # Close the current path.
      def close
        "h"
      end

      # Move to a point: `x y m`
      def move_to(x, y)
        format("%<x>.2f %<y>.2f m", x: x, y: y)
      end

      # Line to a point: `x y l`
      def line_to(x, y)
        format("%<x>.2f %<y>.2f l", x: x, y: y)
      end
    end
  end
end
