# frozen_string_literal: true

module Idml
  module TextEngine
    # Converts a text string + font metrics into a sequence of shaped
    # glyphs, each carrying its advance width at the given size.
    ShapedGlyph = Struct.new(:codepoint, :width, :is_space)

    class Shaper
      def self.shape(text:, font:, size:)
        new(font, size).shape(text)
      end

      def initialize(font, size)
        @font = font
        @size = size
        @scale = size.to_f / font.units_per_em
      end

      def shape(text)
        glyphs = []
        text.each_codepoint do |cp|
          raw_width = @font.glyph_width(cp)
          width = raw_width * @scale
          glyphs << ShapedGlyph.new(cp, width, cp == 32)
        end
        glyphs
      end

      def measure(glyphs)
        glyphs.sum(&:width)
      end
    end
  end
end
