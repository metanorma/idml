# frozen_string_literal: true

module Idml
  module TextEngine
    # Height measurement for paragraphs — shape + wrap each run and
    # sum the line count × leading. Used where a paragraph's full
    # extent must be known before its lines are laid out (paragraph
    # shading/border rects).
    module Measurement
      DEFAULT_POINT_SIZE = 12.0

      # Returns the paragraph's rendered height at `wrap_width`:
      # every run's wrapped line count × leading, plus paragraph
      # SpaceBefore / SpaceAfter.
      def self.paragraph_height(paragraph, font, wrap_width)
        lines_height = paragraph.runs.sum do |run|
          size = run.point_size || DEFAULT_POINT_SIZE
          lines = wrapped_lines(run, font, wrap_width, size)
          lines.length *
            TextEngine::VerticalLayout.leading_for(paragraph.auto_leading,
                                                   size)
        end
        lines_height + space_before_after(paragraph)
      end

      def self.wrapped_lines(run, font, wrap_width, size)
        glyphs = TextEngine::Shaper.shape(text: run.text, font: font,
                                          size: size)
        TextEngine::LineBreaker.break(glyphs: glyphs,
                                      frame_width: wrap_width)
      end
      private_class_method :wrapped_lines

      def self.space_before_after(paragraph)
        (paragraph.space_before || 0) + (paragraph.space_after || 0)
      end
      private_class_method :space_before_after
    end
  end
end
