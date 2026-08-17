# frozen_string_literal: true

module Idml
  module TextEngine
    # Distributes slack space within a line per the paragraph's
    # alignment. Adjusts x_offset and optionally scales inter-word
    # spaces for justified text. `last_line:` (the paragraph's final
    # line) keeps ragged right under :justified, as InDesign does.
    class Justifier
      def self.justify(line:, frame_width:, alignment: :left,
                       last_line: false)
        new(frame_width, alignment, last_line).justify(line)
      end

      def initialize(frame_width, alignment, last_line)
        @frame_width = frame_width
        @alignment = alignment
        @last_line = last_line
      end

      def justify(line)
        case effective_alignment
        when :left, :start then line.x_offset = 0
        when :center, :middle
          line.x_offset = (@frame_width - line.width) / 2
        when :right, :end
          line.x_offset = @frame_width - line.width
        when :justified then justify_line(line)
        end
        line
      end

      private

      # The paragraph's last line stays ragged under full
      # justification.
      def effective_alignment
        return :left if @alignment == :justified && @last_line

        @alignment
      end

      def justify_line(line)
        spaces = line.glyphs.count(&:is_space)
        slack = @frame_width - line.width
        return if spaces.zero? || slack <= 0

        extra = slack / spaces
        line.glyphs.each do |glyph|
          next unless glyph.is_space

          glyph.width += extra
        end
      end
    end
  end
end
