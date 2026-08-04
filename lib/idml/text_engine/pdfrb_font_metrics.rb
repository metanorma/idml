# frozen_string_literal: true

module Idml
  module TextEngine
    # Adapter that exposes the same measurement surface as
    # `FontMetrics` (the Fontisan-based parser) but delegates to
    # pdfrb's `Fonts` collection + a registered font resource Symbol.
    #
    # Once a font is registered with the pdfrb document via
    # `document.fonts.add(path)`, pdfrb parses the TTF tables (cmap,
    # hmtx, head, hhea) and exposes real per-glyph advance widths
    # through `Fonts#glyph_width(resource, codepoint)` and
    # `Fonts#metrics_for(resource)`. This adapter wraps that pair so
    # the text engine (Shaper, LineBreaker) can use real metrics
    # without any Fontisan dependency.
    class PdfrbFontMetrics
      attr_reader :resource, :fonts

      def initialize(fonts_collection, resource)
        @fonts = fonts_collection
        @resource = resource
      end

      def units_per_em
        metrics_data[:units_per_em] || 1000
      end

      def ascent
        metrics_data[:ascent] || 800
      end

      def descent
        metrics_data[:descent] || -200
      end

      def line_gap
        0
      end

      # Returns raw advance width in font units (not scaled by size).
      def glyph_width(codepoint)
        cp = codepoint.is_a?(String) ? codepoint.each_codepoint.first : codepoint
        @fonts.glyph_width(@resource, cp).to_i
      end

      def measure_text(text, size:)
        return 0.0 if text.nil? || text.empty?

        text.each_codepoint.sum do |cp|
          glyph_width(cp) * size.to_f / units_per_em
        end
      end

      def kerning_pair(_left_cp, _right_cp)
        0
      end

      def postscript_name
        @resource.to_s
      end

      def family_name
        postscript_name
      end

      def style_name
        "Regular"
      end

      def path
        nil
      end

      private

      def metrics_data
        @fonts.metrics_for(@resource) || {}
      end
    end
  end
end
