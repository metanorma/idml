# frozen_string_literal: true

module Idml
  module TextEngine
    # CJK text layout utilities: character classification, kinsoku
    # shori (line-breaking rules), and vertical writing-mode helpers.
    module CjkLayout
      module_function

      # Mojikumi subset: automatic inter-script spacing — an eighth
      # em is inserted between adjacent CJK and ASCII alphanumeric
      # glyphs (widenning the leading glyph of each pair), matching
      # InDesign's default CJK/Latin auto spacing.
      SCRIPT_SPACING_EM = 0.125

      def apply_script_spacing(glyphs, size)
        spacing = size * SCRIPT_SPACING_EM
        (0...(glyphs.length - 1)).each do |index|
          leading = glyphs[index]
          following = glyphs[index + 1]
          next unless script_boundary?(leading.codepoint,
                                       following.codepoint)

          leading.width += spacing
        end
        glyphs
      end

      # True when exactly one of the pair is CJK and the other is
      # an ASCII letter or digit.
      def script_boundary?(left, right)
        (cjk?(left) && ascii_alnum?(right)) ||
          (ascii_alnum?(left) && cjk?(right))
      end

      def ascii_alnum?(codepoint)
        (0x30..0x39).cover?(codepoint) ||
          (0x41..0x5A).cover?(codepoint) ||
          (0x61..0x7A).cover?(codepoint)
      end

      CJK_RANGES = [
        0x3000..0x303F, # CJK Symbols and Punctuation
        0x3040..0x309F, # Hiragana
        0x30A0..0x30FF, # Katakana
        0x3400..0x4DBF, # CJK Extension A
        0x4E00..0x9FFF, # CJK Unified Ideographs
        0xAC00..0xD7AF, # Hangul Syllables
        0xF900..0xFAFF, # CJK Compatibility Ideographs
        0xFF00..0xFFEF, # Halfwidth and Fullwidth Forms
      ].freeze

      # Characters forbidden at line start (kinsoku shori).
      FORBIDDEN_LINE_START = %w[
        、 。， ． ｡ ： ； ？ ｿ ﾞ ﾟ ! ！ ” 〉 》 」 』 】
        〕 ｝ ） ｣ ゛ ゝ ゞ 〃 々 〆 〇 ー 〜
        ぁ ぃ ぅ ぇ ぉ っ ゃ ゅ ょ ゎ
        ァ ィ ゥ ェ ォ ッ ャ ュ ョ ヮ
        ぁ ぃ ぅ ぇ ぉ
      ].map(&:codepoints).flatten.freeze

      # Characters forbidden at line end (kinsoku shori).
      FORBIDDEN_LINE_END = %w[
        “ 〈 《 「 『 【 〔 ｛ （ ｢
      ].map(&:codepoints).flatten.freeze

      def cjk?(codepoint)
        CJK_RANGES.any? { |range| range.include?(codepoint) }
      end

      def forbidden_start?(codepoint)
        FORBIDDEN_LINE_START.include?(codepoint)
      end

      def forbidden_end?(codepoint)
        FORBIDDEN_LINE_END.include?(codepoint)
      end

      # Check if text contains any CJK characters.
      def contains_cjk?(text)
        text.each_codepoint.any? { |cp| cjk?(cp) }
      end

      # Apply kinsoku shori to an array of Line objects. Moves
      # forbidden-start chars from the beginning of a line to the
      # end of the previous line, and forbidden-end chars from the
      # end of a line to the beginning of the next line.
      def apply_kinsoku(lines)
        return lines if lines.length < 2

        result = [dup_line(lines.first)]
        lines[1..].each do |line|
          prev = result.last
          curr = dup_line(line)
          adjusted_prev, adjusted_current = adjust_boundary(prev, curr)
          result[-1] = adjusted_prev
          result << adjusted_current
        end
        result
      end

      def dup_line(line)
        Line.new(line.glyphs.dup, line.width, line.x_offset)
      end

      # Adjust the boundary between two lines according to kinsoku rules.
      def adjust_boundary(prev_line, current_line)
        prev = dup_line(prev_line)
        curr = dup_line(current_line)

        # Move forbidden-start chars from current line start to prev line end.
        until curr.glyphs.empty? || !forbidden_start?(curr.glyphs.first.codepoint)
          moved = curr.glyphs.shift
          prev.glyphs << moved
          prev.width += moved.width
          curr.width -= moved.width
        end

        # Move forbidden-end chars from prev line end to current line start.
        until prev.glyphs.empty? || !forbidden_end?(prev.glyphs.last.codepoint)
          moved = prev.glyphs.pop
          prev.width -= moved.width
          curr.glyphs.unshift(moved)
          curr.width += moved.width
        end

        [prev, curr]
      end

      # Detect if a codepoint is a CJK full-width digit (０-９).
      def fullwidth_digit?(codepoint)
        codepoint.between?(0xFF10, 0xFF19)
      end

      # Tate-Chu-Yoko candidate: 1-2 digit horizontal runs in vertical text.
      def tate_chu_yoko?(codepoint)
        codepoint.between?(0x30, 0x39) || fullwidth_digit?(codepoint)
      end

      # Check if a StoryOrientation value indicates vertical writing.
      def vertical_mode?(orientation)
        ["TopToBottom", "RightToLeftTopToBottom"].include?(orientation)
      end
    end
  end
end
