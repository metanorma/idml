# frozen_string_literal: true

module Idml
  module TextEngine
    # Distributes slack space within a line per the paragraph's
    # alignment. Adjusts x_offset and optionally scales inter-word
    # spaces for justified text. `last_line:` (the paragraph's final
    # line) keeps ragged right under :justified, as InDesign does.
    class Justifier
      # Justification distribution caps, in percent (100 = natural).
      # InDesign defaults: word spacing max 133%, letter spacing 0%.
      SpacingLimits = Struct.new(
        :max_word_spacing, :max_letter_spacing, :max_glyph_scaling,
        :min_glyph_scaling,
        keyword_init: true
      )

      DEFAULT_MAX_WORD_SPACING = 133.0
      DEFAULT_MAX_LETTER_SPACING = 0.0
      DEFAULT_MAX_GLYPH_SCALING = 100.0
      DEFAULT_MIN_GLYPH_SCALING = 100.0

      def self.justify(line:, frame_width:, alignment: :left,
                       last_line: false, limits: nil)
        new(frame_width, alignment, last_line, limits).justify(line)
      end

      def initialize(frame_width, alignment, last_line, limits)
        @frame_width = frame_width
        @alignment = alignment
        @last_line = last_line
        @limits = limits
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
        return compress_glyphs(line, slack) if slack.negative?

        return if spaces.zero? || slack <= 0

        word_share = [slack, word_capacity(line, spaces)].min
        extra = word_share / spaces
        line.glyphs.each do |glyph|
          next unless glyph.is_space

          glyph.width += extra
        end
        residual = slack - word_share
        return unless residual.positive?

        before = line.glyphs.sum(&:width)
        distribute_letter_spacing(line, residual)
        residual -= (line.glyphs.sum(&:width) - before)
        distribute_glyph_scaling(line, residual) if residual.positive?
      end

      # Total room the word spaces may grow within the max-word-
      # spacing cap (percent of each space's natural width).
      def word_capacity(line, _spaces)
        max_pct = @limits&.max_word_spacing || DEFAULT_MAX_WORD_SPACING
        grow = [(max_pct - 100) / 100.0, 0].max
        line.glyphs.sum { |g| g.is_space ? g.width * grow : 0.0 } * 1.0
      end
      private :word_capacity

      # Even per-glyph letter spacing for residual slack, capped at
      # max_letter_spacing percent of the natural space width. With
      # the default 0% cap nothing is added — the line ends short,
      # as InDesign does when limits bind.
      def distribute_letter_spacing(line, residual)
        max_pct = @limits&.max_letter_spacing || DEFAULT_MAX_LETTER_SPACING
        return unless max_pct.positive?

        space_ref = line.glyphs.find(&:is_space)&.width || 0
        return unless space_ref.positive?

        cap = (max_pct / 100.0) * space_ref * line.glyphs.length
        add = [residual, cap].min / line.glyphs.length
        line.glyphs.each { |glyph| glyph.width += add }
      end
      private :distribute_letter_spacing

      # Overlong justified line: compress all glyphs uniformly,
      # capped at min_glyph_scaling percent. InDesign's default cap
      # (100%) disables it; only documents that lower the cap get
      # squeezed glyphs.
      def compress_glyphs(line, slack)
        min_pct = @limits&.min_glyph_scaling || DEFAULT_MIN_GLYPH_SCALING
        shrink = (100 - min_pct) / 100.0
        return unless shrink.positive?

        total = line.glyphs.sum(&:width)
        return unless total.positive?

        factor = [-slack / total, shrink].min
        line.glyphs.each { |glyph| glyph.width *= (1 - factor) }
      end
      private :compress_glyphs

      # Last resort: uniform glyph scaling for any remaining slack,
      # capped at max_glyph_scaling percent. InDesign's default cap
      # (100%) disables it; only documents that relax the cap get
      # stretched glyphs.
      def distribute_glyph_scaling(line, residual)
        max_pct = @limits&.max_glyph_scaling || DEFAULT_MAX_GLYPH_SCALING
        grow = (max_pct - 100) / 100.0
        return unless grow.positive?

        total = line.glyphs.sum(&:width)
        return unless total.positive?

        factor = [residual / total, grow].min
        line.glyphs.each { |glyph| glyph.width *= (1 + factor) }
      end
      private :distribute_glyph_scaling
    end
  end
end
