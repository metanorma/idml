# frozen_string_literal: true

module Idml
  module TextEngine
    # Geometry of a text frame as seen by the layout engine: outer
    # bounds plus the four inset margins. Inset values are nil when
    # the TextFramePreference doesn't declare them.
    Frame = Struct.new(
      :x, :y, :width, :height,
      :inset_top, :inset_bottom, :inset_left, :inset_right,
      keyword_init: true
    )

    # A line that's been positioned absolutely within a frame.
    # `glyphs` is the original ShapedGlyph array (carrying widths);
    # `x`, `y` is the left edge / baseline; `width` is the line's
    # natural width after justification.
    PositionedLine = Struct.new(:glyphs, :x, :y, :width, keyword_init: true)

    # Positions lines vertically within a text frame. The layout is
    # block-oriented: each call to `layout_block` returns the
    # positioned lines for one block (paragraph, run, etc.) and the
    # y cursor for the next block, so callers can stack paragraphs
    # without re-deriving cursor math.
    class VerticalLayout
      DEFAULT_LEADING_FACTOR = 1.2

      # Position `lines` starting at `cursor_y` and walking downward.
      # `cursor_y` is the top of the available space; the first line
      # sits one `leading` below it. Returns `[positioned_lines, next_y]`
      # where `next_y` is where the next block should start (i.e. below
      # this block's last line plus `space_after`).
      def self.layout_block(lines:, frame:, font_size:, cursor_y:, leading: nil, space_before: 0, space_after: 0,
                            first_line_indent: 0, left_indent: 0)
        effective_leading = leading || (font_size * DEFAULT_LEADING_FACTOR)
        y = cursor_y - space_before
        positioned = []

        lines.each_with_index do |line, idx|
          y -= effective_leading
          x = frame_left(frame) + left_indent +
            (idx.zero? ? first_line_indent : 0) + line.x_offset.to_f
          positioned << PositionedLine.new(
            glyphs: line.glyphs, x: x, y: y, width: line.width,
          )
        end

        [positioned, y - space_after]
      end

      # Bottom y of the frame's text area (frame bottom edge + bottom
      # inset). Lines whose y falls below this are clipped.
      def self.bottom_limit(frame)
        frame.y + (frame.inset_bottom || 0)
      end

      # Effective wrap width after subtracting insets and indents.
      def self.wrap_width(frame, right_indent = 0)
        width = frame.width - (frame.inset_left || 0) - (frame.inset_right || 0)
        width - right_indent
      end

      def self.frame_left(frame)
        frame.x + (frame.inset_left || 0)
      end
      private_class_method :frame_left
    end
  end
end
