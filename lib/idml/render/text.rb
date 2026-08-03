# frozen_string_literal: true

# DEPRECATED: This module is superseded by Canvas#text method.
# Text rendering is now handled by pdfrb's Canvas API.

module Idml
  module Render
    # Converts positioned glyphs to PDF text-showing operators.
    module Text
      module_function

      # Begin text block
      def begin_text
        "BT"
      end

      # End text block
      def end_text
        "ET"
      end

      # Set font: `/FontName size Tf`
      def set_font(font_name, size)
        format("/%<name>s %<size>.1f Tf", name: font_name, size: size)
      end

      # Move text position: `x y Td`
      def move_to(x, y)
        format("%<x>.2f %<y>.2f Td", x: x, y: y)
      end

      # Set text matrix: `a b c d e f Tm`
      def set_matrix(a:, b:, c:, d:, e:, f:)
        format("%<a>.4f %<b>.4f %<c>.4f %<d>.4f %<e>.2f %<f>.2f Tm",
               a: a, b: b, c: c, d: d, e: e, f: f)
      end

      # Show a text string: `(escaped) Tj`
      def show(text_string)
        "(#{escape(text_string)}) Tj"
      end

      # Build a complete text-showing block for a run of glyphs
      # at the same font/size, positioned at (x, y).
      def show_run(text_string:, font_name:, size:, x:, y:)
        [
          begin_text,
          set_font(font_name, size),
          move_to(x, y),
          show(text_string),
          end_text,
        ].join("\n")
      end

      # Emit positioned glyphs. Groups glyphs by y coordinate into
      # lines, sets the text matrix per-line for absolute positioning,
      # then shows the line text. Multiple lines within one BT/ET block.
      def show_positioned(glyphs)
        return "" if glyphs.empty?

        lines = group_by_line(glyphs)
        lines.map do |line|
          [
            set_matrix(a: 1, b: 0, c: 0, d: 1,
                       e: line.first.x, f: line.first.y),
            show(line.map { |g| [g.codepoint].pack("U") }.join),
          ].join("\n")
        end.join("\n")
      end

      def group_by_line(glyphs)
        result = []
        current = nil
        glyphs.each do |glyph|
          if current.nil? || current.first.y != glyph.y
            current = []
            result << current
          end
          current << glyph
        end
        result
      end
      private_class_method :group_by_line

      # Escape characters that are special in PDF strings.
      def escape(str)
        str.to_s.gsub("\\", "\\\\\\\\").gsub("(", "\\(").gsub(")", "\\)")
      end
    end
  end
end
