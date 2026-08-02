# frozen_string_literal: true

module Idml
  module TextEngine
    # A glyph with absolute (x, y) position, ready for rendering.
    PositionedGlyph = Struct.new(:codepoint, :x, :y, :font_size)

    # Positions justified lines vertically within a text frame.
    # Applies leading, paragraph spacing, first-line indent, and
    # left/right insets.
    class VerticalLayout
      Frame = Struct.new(:x, :y, :width, :height,
                         :inset_top, :inset_bottom,
                         :inset_left, :inset_right)

      def self.layout(lines:, frame:, font_size:,
                      leading: nil, space_before: 0, space_after: 0,
                      first_line_indent: 0, left_indent: 0)
        new(frame, font_size, leading, space_before, space_after,
            first_line_indent, left_indent).layout(lines)
      end

      def initialize(frame, font_size, leading, space_before,
                     space_after, first_line_indent, left_indent)
        @frame = frame
        @font_size = font_size
        @leading = leading || (font_size * 1.2)
        @space_before = space_before
        @space_after = space_after
        @first_line_indent = first_line_indent
        @left_indent = left_indent
      end

      def layout(lines)
        result = []
        y = top_y - @space_before
        lines.each_with_index do |line, idx|
          y -= @leading
          x = frame_left + (idx.zero? ? @first_line_indent : @left_indent)
          x += line.x_offset.to_f
          current_x = x
          line.glyphs.each do |glyph|
            result << PositionedGlyph.new(glyph.codepoint,
                                          current_x,
                                          y,
                                          @font_size)
            current_x += glyph.width
          end
        end
        result
      end

      private

      def top_y
        @frame.y - (@frame.inset_top || 0)
      end

      def frame_left
        @frame.x + (@frame.inset_left || 0)
      end
    end
  end
end
