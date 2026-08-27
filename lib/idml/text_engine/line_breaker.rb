# frozen_string_literal: true

module Idml
  module TextEngine
    # A line of shaped glyphs with its natural width.
    Line = Struct.new(:glyphs, :width, :x_offset)

    # Greedy word-wrap line breaker. Accumulates glyphs until
    # exceeding the frame width, then breaks at the last break
    # opportunity: a space, or a hyphen (compound words wrap after
    # the hyphen, which stays on the first line). CJK runs get a
    # kinsoku shori post-pass (no line starts or ends with a
    # forbidden character).
    class LineBreaker
      # Break-after opportunities besides spaces: hyphen-minus,
      # the Unicode hyphens, and the soft hyphen (which breaks
      # without adding a visible hyphen).
      HYPHEN_CODEPOINTS = [0x2D, 0x2010, 0x2011, 0x00AD].freeze
      def self.break(glyphs:, frame_width:)
        lines = new(frame_width).break(glyphs)
        return lines unless cjk_run?(glyphs)

        lines = CjkLayout.apply_kinsoku(lines)
        CjkLayout.apply_pair_compression(lines)
        CjkLayout.apply_line_end_compression(lines)
      end

      def self.cjk_run?(glyphs)
        glyphs.any? { |glyph| CjkLayout.cjk?(glyph.codepoint) }
      end
      private_class_method :cjk_run?

      # CJK text wraps per character (no word boundaries): an
      # overflow whose trailing glyph is CJK breaks before it
      # instead of emitting an overlong line.

      def initialize(frame_width)
        @frame_width = frame_width
      end

      # CJK text wraps per character (no word boundaries): an
      # overflow whose trailing glyph is CJK breaks before it
      # instead of emitting an overlong line.
      def cjk_break?(current)
        current.length > 1 && CjkLayout.cjk?(current.last.codepoint)
      end
      private :cjk_break?

      def break(glyphs)
        lines = []
        current = []
        current_width = 0
        break_idx = -1
        width_at_break = 0

        glyphs.each_with_index do |glyph, _idx|
          current << glyph
          current_width += glyph.width

          if break_after?(glyph)
            break_idx = current.length - 1
            width_at_break = current_width
          end

          next unless current_width > @frame_width && current.length > 1

          if break_idx >= 0
            line_glyphs = current[0..break_idx]
            lines << Line.new(line_glyphs, width_at_break, 0)
            current = current[(break_idx + 1)..]
            current_width = current.sum(&:width)
            break_idx = -1
          elsif cjk_break?(current)
            lines << Line.new(current[0..-2], current_width - glyph.width, 0)
            current = [glyph]
            current_width = glyph.width
          else
            lines << Line.new(current, current_width, 0)
            current = []
            current_width = 0
          end
        end

        lines << Line.new(current, current_width, 0) if current.any?
        lines
      end

      def break_after?(glyph)
        glyph.is_space || HYPHEN_CODEPOINTS.include?(glyph.codepoint)
      end
      private :break_after?
    end
  end
end
