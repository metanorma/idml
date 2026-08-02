# frozen_string_literal: true

require "fontisan"

module Idml
  module TextEngine
    # Reads OpenType/TrueType font metrics via Fontisan. Uses Fontisan's
    # FontLoader to open the font file and locate table offsets, then
    # parses the head, hhea, hmtx, and cmap tables directly from the
    # binary. No ttfunk.
    class FontMetrics
      def self.open(path)
        new(path)
      end

      def initialize(path)
        @path = path
        @font = Fontisan::FontLoader.load(path)
        @io = File.open(path, "rb")
        parse_head
        parse_hhea
        parse_hmtx
        parse_cmap
        @width_cache = {}
      end

      attr_reader :units_per_em, :ascent, :descent, :line_gap

      def glyph_width(codepoint)
        @width_cache[codepoint] ||=
          begin
            glyph_id = @code_map[codepoint] || 0
            metric = @advance_widths[glyph_id]
            metric || @advance_widths.last || 0
          end
      end

      def kerning_pair(_left_cp, _right_cp)
        0
      end

      def measure_text(text, size:)
        total = 0
        text.each_codepoint { |cp| total += glyph_width(cp) }
        total.to_f / units_per_em * size
      end

      def postscript_name
        @postscript_name ||= parse_name_entry(6) || "Unknown"
      end

      def family_name
        @family_name ||= parse_name_entry(1) || "Unknown"
      end

      def style_name
        @style_name ||= parse_name_entry(2) || "Regular"
      end

      private

      def find_table(tag)
        @font.tables.find { |entry| entry.tag == tag }
      end

      def read_table_bytes(tag)
        entry = find_table(tag)
        return nil unless entry

        @io.seek(entry.offset)
        @io.read(entry.table_length)
      end

      def parse_head
        data = read_table_bytes("head")
        return unless data

        @units_per_em = data[18, 2].unpack1("n")
      end

      def parse_hhea
        data = read_table_bytes("hhea")
        return unless data

        @ascent = sign_extend(data[4, 2].unpack1("n"))
        @descent = sign_extend(data[6, 2].unpack1("n"))
        @line_gap = sign_extend(data[8, 2].unpack1("n"))
        @num_hmetrics = data[34, 2].unpack1("n")
      end

      def parse_hmtx
        data = read_table_bytes("hmtx")
        return unless data

        @advance_widths = []
        @num_hmetrics.times do |i|
          offset = i * 4
          @advance_widths[i] = data[offset, 2].unpack1("n")
        end
      end

      def parse_cmap
        data = read_table_bytes("cmap")
        return unless data

        _, num_subtables = data[0, 4].unpack("nn")
        @code_map = {}

        best_offset = nil
        num_subtables.times do |i|
          rec_off = 4 + (i * 4)
          platform_id, encoding_id, offset = data[rec_off, 8].unpack("nnN")
          if platform_id == 3 && encoding_id == 1
            best_offset = offset
            break
          end
          best_offset ||= offset if platform_id.zero?
        end
        return unless best_offset

        parse_cmap_subtable(data, best_offset)
      end

      def parse_cmap_subtable(data, offset)
        format = data[offset, 2].unpack1("n")
        parse_cmap_format4(data, offset) if format == 4
        parse_cmap_format0(data, offset) if format.zero?
      end

      def sign_extend(uint16)
        uint16 >= 32768 ? uint16 - 65536 : uint16
      end

      def parse_cmap_format4(data, offset)
        seg_count_x2 = data[offset + 6, 2].unpack1("n")
        seg_count = seg_count_x2 / 2

        end_start = offset + 14
        start_start = end_start + seg_count_x2 + 2
        delta_start = start_start + seg_count_x2
        range_start = delta_start + seg_count_x2

        seg_count.times do |i|
          end_code = data[end_start + (i * 2), 2].unpack1("n")
          start_code = data[start_start + (i * 2), 2].unpack1("n")
          delta = sign_extend(data[delta_start + (i * 2), 2].unpack1("n"))
          range_off = data[range_start + (i * 2), 2].unpack1("n")

          (start_code..end_code).each do |cp|
            if range_off.zero?
              glyph_id = (cp + delta) & 0xFFFF
            else
              idx = range_start + (i * 2) + range_off + ((cp - start_code) * 2)
              glyph_id = data[idx, 2].unpack1("n")
              glyph_id = (glyph_id + delta) & 0xFFFF if glyph_id != 0
            end
            @code_map[cp] = glyph_id if glyph_id != 0
          end
        end
      end

      def parse_cmap_format0(data, offset)
        256.times do |cp|
          glyph_id = data[offset + 6 + cp, 1].unpack1("C")
          @code_map[cp] = glyph_id if glyph_id != 0
        end
      end

      def parse_name_entry(name_id)
        data = read_table_bytes("name")
        return nil unless data

        _format, count, string_offset = data[0, 6].unpack("nnn")
        count.times do |i|
          rec = 6 + (i * 12)
          platform_id, _encoding_id, _lang_id, id, length, str_off =
            data[rec, 12].unpack("nnnnnn")
          next unless id == name_id

          raw = data[string_offset + str_off, length]
          return decode_name_string(raw, platform_id)
        end
        nil
      end

      def decode_name_string(raw, platform_id)
        if platform_id == 3
          raw.encode("UTF-8", "UTF-16BE").strip
        else
          raw.force_encoding("UTF-8").strip
        end
      end
    end
  end
end
