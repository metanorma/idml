# frozen_string_literal: true

require "ttfunk"

module Idml
  module TextEngine
    # Reads OpenType/TrueType font files via ttfunk and exposes
    # per-glyph advance widths and kerning pairs. All widths are
    # in font design units (divide by units_per_em to normalize).
    class FontMetrics
      def self.open(path)
        new(TTFunk::File.open(path))
      end

      def initialize(ttf)
        @ttf = ttf
        @code_map = build_code_map
        @width_cache = {}
        @kerning_cache = {}
      end

      def units_per_em
        @ttf.header.units_per_em
      end

      def ascent
        @ttf.horizontal_header.ascent
      end

      def descent
        @ttf.horizontal_header.descent
      end

      def line_gap
        @ttf.horizontal_header.line_gap
      end

      def glyph_width(codepoint)
        @width_cache[codepoint] ||=
          begin
            glyph_id = @code_map[codepoint] || 0
            @ttf.horizontal_metrics.for(glyph_id)&.advance_width || 0
          end
      end

      def kerning_pair(left_cp, right_cp)
        key = [left_cp, right_cp]
        @kerning_cache[key] ||= lookup_kerning(left_cp, right_cp)
      end

      def measure_text(text, size:)
        prev_cp = nil
        total = 0
        text.each_codepoint do |cp|
          total += glyph_width(cp)
          total += kerning_pair(prev_cp, cp) if prev_cp
          prev_cp = cp
        end
        total.to_f / units_per_em * size
      end

      def postscript_name
        @ttf.name.postscript_name
      end

      def family_name
        pick_name(@ttf.name.font_family)
      end

      def style_name
        pick_name(@ttf.name.font_subfamily)
      end

      private

      # ttfunk's kerning API varies across versions. Try the common
      # access patterns; return 0 if none work. Kerning is a refinement,
      # not a correctness requirement — glyphs still render correctly
      # without it, just with less-optimal spacing.
      def lookup_kerning(left_cp, right_cp)
        left_id = @code_map[left_cp] || 0
        right_id = @code_map[right_cp] || 0
        table = @ttf.respond_to?(:kerning) ? @ttf.kerning : nil
        return 0 unless table

        if table.respond_to?(:pairs)
          table.pairs.dig(left_id, right_id) || 0
        elsif table.respond_to?(:find)
          table.find(left_id, right_id) || 0
        else
          0
        end
      rescue StandardError
        0
      end

      def build_code_map
        subtable = @ttf.cmap.unicode.first
        return {} unless subtable

        subtable.code_map || {}
      end

      # ttfunk returns arrays of platform-encoded strings; pick the
      # first that's valid UTF-8 (usually the Windows entry).
      def pick_name(names)
        return "" unless names

        names.find { |n| n.valid_encoding? && !n.to_s.empty? }.to_s
      end
    end
  end
end
