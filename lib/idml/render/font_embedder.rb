# frozen_string_literal: true

module Idml
  module Render
    # Generates PDF font structures for embedded TrueType fonts.
    # Produces the Widths array (WinAnsiEncoding 32–255), FontDescriptor
    # metadata, and FontFile2 binary embedding.
    module FontEmbedder
      FIRST_CHAR = 32
      LAST_CHAR = 255

      # PDF WinAnsiEncoding = Code Page 1252. Bytes 0x80-0x9F differ
      # from ISO-8859-1 and map to specific Unicode codepoints.
      CP1252_SPECIAL = {
        0x80 => 0x20AC, 0x82 => 0x201A, 0x83 => 0x0192, 0x84 => 0x201E,
        0x85 => 0x2026, 0x86 => 0x2020, 0x87 => 0x2021, 0x88 => 0x02C6,
        0x89 => 0x2030, 0x8A => 0x0160, 0x8B => 0x2039, 0x8C => 0x0152,
        0x8E => 0x017D, 0x91 => 0x2018, 0x92 => 0x2019, 0x93 => 0x201C,
        0x94 => 0x201D, 0x95 => 0x2022, 0x96 => 0x2013, 0x97 => 0x2014,
        0x98 => 0x02DC, 0x99 => 0x2122, 0x9A => 0x0161, 0x9B => 0x203A,
        0x9C => 0x0153, 0x9E => 0x017E, 0x9F => 0x0178
      }.freeze

      private_constant :CP1252_SPECIAL

      module_function

      # Widths array for WinAnsiEncoding (chars 32–255), in PDF text
      # units (1000 units per em).
      def widths_array(font_metrics)
        (FIRST_CHAR..LAST_CHAR).map do |byte|
          cp = winansi_to_unicode(byte)
          raw = font_metrics.glyph_width(cp)
          scale_to_text_units(raw, font_metrics.units_per_em)
        end
      end

      # Map a WinAnsi (CP1252) byte value to its Unicode codepoint.
      def winansi_to_unicode(byte)
        CP1252_SPECIAL.fetch(byte, byte)
      end

      def scale_to_text_units(font_units, upem)
        (font_units.to_f * 1000 / upem).round
      end

      # FontDescriptor metadata hash.
      def descriptor(font_metrics)
        upem = font_metrics.units_per_em
        scale = 1000.0 / upem
        ascent = font_metrics.ascent.to_f
        descent = font_metrics.descent.to_f
        {
          font_name: font_metrics.postscript_name,
          flags: 32,
          font_bbox: [
            (descent * scale).round,
            0,
            1000,
            (ascent * scale).round,
          ],
          italic_angle: 0,
          ascent: (ascent * scale).round,
          descent: (descent * scale).round,
          cap_height: (ascent * scale * 0.7).round,
          stem_v: 80,
        }
      end

      # Read raw font binary data from the FontMetrics source path.
      def raw_font_data(font_metrics)
        File.binread(font_metrics.path)
      end
    end
  end
end
