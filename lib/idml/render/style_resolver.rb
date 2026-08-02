# frozen_string_literal: true

module Idml
  module Render
    # Extracts styled text runs from an IDML Story. Each run carries the
    # text content plus the CharacterStyleRange attributes that affect
    # rendering (font style, size, fill color, applied font reference).
    class StyleResolver
      StyledRun = Struct.new(
        :text, :font_style, :point_size,
        :fill_color, :fill_tint, :applied_font, keyword_init: true
      )

      DEFAULT_POINT_SIZE = 12.0

      def self.extract_runs(story)
        return [] unless story&.inner

        story.inner.paragraph_style_range.flat_map do |psr|
          csr_runs(psr)
        end
      end

      def self.csr_runs(psr)
        psr.character_style_range.filter_map do |csr|
          text = csr.text_content
          next if text.nil? || text.empty?

          StyledRun.new(
            text: text,
            font_style: csr.font_style,
            point_size: csr.point_size || DEFAULT_POINT_SIZE,
            fill_color: csr.fill_color,
            fill_tint: csr.fill_tint,
            applied_font: csr.applied_font,
          )
        end
      end
      private_class_method :csr_runs

      # Concatenate runs into a single block. Used when the renderer
      # can't handle per-run styling (e.g., no font metrics available).
      def self.concatenate(runs)
        runs.map(&:text).join
      end
    end
  end
end
