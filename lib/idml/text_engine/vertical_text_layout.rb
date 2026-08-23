# frozen_string_literal: true

module Idml
  module TextEngine
    # Vertical (top-to-bottom, right-to-left) glyph layout for CJK
    # vertical writing (StoryOrientation="Vertical"). Glyphs stay
    # UPRIGHT — CJK ideographs render correctly stacked; Latin
    # glyphs are not rotated to the vertical axis (documented
    # approximation). Line breaking (and therefore kinsoku shori)
    # is reused from LineBreaker against the column height.
    module VerticalTextLayout
      # One glyph placed at its baseline in a vertical column.
      PositionedGlyph = Struct.new(:codepoint, :x, :y, keyword_init: true)

      # Stacks `glyphs` into columns of at most the frame's text
      # height; column 0 is the rightmost. `start_column` places
      # the first column after already-used columns (multi-run
      # frames). Returns [positioned_glyphs, next_column_index].
      def self.layout(glyphs:, frame:, leading:, size:, start_column: 0)
        lines = TextEngine::LineBreaker.break(
          glyphs: glyphs, frame_width: column_height(frame),
        )
        positioned = []
        lines.each_with_index do |line, index|
          stack_column(positioned, line.glyphs, frame, leading, size,
                       index + start_column)
        end
        [positioned, start_column + lines.length]
      end

      # The frame's usable vertical extent for one column of text.
      def self.column_height(frame)
        frame.height - (frame.inset_top || 0) - (frame.inset_bottom || 0)
      end

      # Places one column's glyphs at a shared x, baselines walking
      # down from the frame's text top by each glyph's advance.
      def self.stack_column(positioned, glyphs, frame, leading, size,
                            column_index)
        top_y = frame.y + frame.height - (frame.inset_top || 0)
        x = column_x(frame, leading, size, column_index)
        y = top_y
        glyphs.each do |glyph|
          y -= advance(glyph)
          positioned << PositionedGlyph.new(codepoint: glyph.codepoint,
                                            x: x, y: y)
        end
      end
      private_class_method :stack_column

      # Positions a tate-chu-yoko group (e.g. the digits "12" kept
      # horizontal inside vertical text): glyphs share one baseline
      # at the top of the given column slot and advance left-to-
      # right, centered in the slot. Returns
      # [positioned_glyphs, next_column_index]; nil when the group
      # is wider than the column height (caller falls back to
      # stacked layout).
      def self.tatechuyoko_group(glyphs:, frame:, leading:, size:,
                                 start_column:)
        total = glyphs.sum(&:width)
        return nil if total > column_height(frame)

        right = frame.x + frame.width - (frame.inset_right || 0)
        slot_center = right - ((start_column + 0.5) * leading)
        x = slot_center - (total / 2.0)
        baseline_y = frame.y + frame.height - (frame.inset_top || 0) - size
        positioned = glyphs.map do |glyph|
          glyph_position = PositionedGlyph.new(
            codepoint: glyph.codepoint, x: x, y: baseline_y,
          )
          x += glyph.width
          glyph_position
        end
        [positioned, start_column + 1]
      end

      # Vertical advance of one glyph — its measured width (the em
      # for the common square-CJK case).
      def self.advance(glyph)
        glyph.width.positive? ? glyph.width : 0.0
      end
      private_class_method :advance

      # The column's glyph left edge: columns advance right-to-left
      # by `leading` from the right inset edge; each glyph (em =
      # `size`) is centered in its column slot.
      def self.column_x(frame, leading, size, column_index)
        right = frame.x + frame.width - (frame.inset_right || 0)
        slot_left = right - ((column_index + 1) * leading)
        slot_left + ((leading - size) / 2.0)
      end
      private_class_method :column_x
    end
  end
end
