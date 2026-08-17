# frozen_string_literal: true

module Idml
  module TextEngine
    # A line of shaped glyphs with its natural width.
    Line = Struct.new(:glyphs, :width, :x_offset)

    # Greedy word-wrap line breaker. Accumulates glyphs until
    # exceeding the frame width, then breaks at the last space.
    # CJK runs get a kinsoku shori post-pass (no line starts or
    # ends with a forbidden character).
    class LineBreaker
      def self.break(glyphs:, frame_width:)
        lines = new(frame_width).break(glyphs)
        return lines unless cjk_run?(glyphs)

        CjkLayout.apply_kinsoku(lines)
      end

      def self.cjk_run?(glyphs)
        glyphs.any? { |glyph| CjkLayout.cjk?(glyph.codepoint) }
      end
      private_class_method :cjk_run?

      def initialize(frame_width)
        @frame_width = frame_width
      end

      def break(glyphs)
        lines = []
        current = []
        current_width = 0
        last_space_idx = -1
        width_at_space = 0

        glyphs.each_with_index do |glyph, _idx|
          current << glyph
          current_width += glyph.width

          if glyph.is_space
            last_space_idx = current.length - 1
            width_at_space = current_width
          end

          next unless current_width > @frame_width && current.length > 1

          if last_space_idx >= 0
            line_glyphs = current[0..last_space_idx]
            lines << Line.new(line_glyphs, width_at_space, 0)
            current = current[(last_space_idx + 1)..]
            current_width = current.sum(&:width)
            last_space_idx = -1
          else
            lines << Line.new(current, current_width, 0)
            current = []
            current_width = 0
          end
        end

        lines << Line.new(current, current_width, 0) if current.any?
        lines
      end
    end
  end
end
