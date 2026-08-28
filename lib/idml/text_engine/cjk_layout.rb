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
      # InDesign's default CJK/Latin auto spacing. A named
      # mojikumi set's OverrideMojikumiAki entries take precedence
      # when given: the Desired value (em units) applies to each
      # matching class pair (TODO 145).
      SCRIPT_SPACING_EM = 0.125

      # Mojikumi character classes (InDesign mojikumi table rows).
      CLASS_IDEOGRAPH = 1
      CLASS_OPENING = 2
      CLASS_CLOSING = 3
      CLASS_COMMA_PERIOD = 4
      CLASS_MIDDLE_DOT = 5
      CLASS_DIGIT = 6
      CLASS_LATIN = 7

      COMMA_PERIOD_CODEPOINTS = [
        0x3001, # 、 ideographic comma
        0x3002, # 。 ideographic full stop
      ].freeze

      CLOSING_CODEPOINTS = [
        0x3009, # 〉
        0x300B, # 》
        0x300D, # 」
        0x300F, # 』
        0x3011, # 】
        0x3015, # 〕
        0xFF09, # ）fullwidth right paren
        0xFF3D, # ］
        0xFF5D, # ｝
      ].freeze

      def apply_script_spacing(glyphs, size, aki_overrides = [])
        (0...(glyphs.length - 1)).each do |index|
          leading = glyphs[index]
          following = glyphs[index + 1]
          em = aki_em(leading.codepoint, following.codepoint,
                      aki_overrides)
          next unless em&.positive?

          leading.width += em * size
        end
        glyphs
      end

      # Spacing (em units) between an adjacent pair: the named
      # set's Desired aki for a matching class-pair override, else
      # the default eighth-em at CJK/Latin script boundaries, else
      # none.
      def aki_em(left, right, aki_overrides)
        override = aki_overrides.find do |entry|
          entry.side_is_after_target &&
            entry.target_mojikumi_class == mojikumi_class(left) &&
            entry.side_mojikumi_class == mojikumi_class(right)
        end
        return override.desired if override&.desired

        return SCRIPT_SPACING_EM if script_boundary?(left, right)

        nil
      end

      # The mojikumi class of a codepoint, or nil outside the
      # CJK punctuation / script classes. Ideographs (the default
      # CJK class) win only when no special class matches.
      def mojikumi_class(codepoint)
        return CLASS_OPENING if OPENING_CODEPOINTS.include?(codepoint)
        return CLASS_COMMA_PERIOD if COMMA_PERIOD_CODEPOINTS.include?(codepoint)
        return CLASS_CLOSING if CLOSING_CODEPOINTS.include?(codepoint)
        return CLASS_MIDDLE_DOT if MIDDLE_CODEPOINTS.include?(codepoint)
        return CLASS_DIGIT if digit_class?(codepoint)
        return CLASS_LATIN if latin_class?(codepoint)
        return CLASS_IDEOGRAPH if cjk?(codepoint)

        nil
      end

      def digit_class?(codepoint)
        (0x30..0x39).cover?(codepoint) ||
          (0xFF10..0xFF19).cover?(codepoint)
      end

      def latin_class?(codepoint)
        (0x41..0x5A).cover?(codepoint) ||
          (0x61..0x7A).cover?(codepoint) ||
          (0xFF21..0xFF3A).cover?(codepoint) ||
          (0xFF41..0xFF5A).cover?(codepoint)
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

      # Mojikumi subset 2: line-end punctuation compression —
      # full-width closing punctuation occupying a line's final
      # position renders at half advance (行末約物半角詰め),
      # tightening the line as InDesign's default mojikumi does.
      TRAILING_COMPRESSION_CODEPOINTS = [
        0x3001, # 、 ideographic comma
        0x3002, # 。 ideographic full stop
        0x3009, # 〉
        0x300B, # 》
        0x300D, # 」
        0x300F, # 』
        0x3011, # 】
        0x3015, # 〕
        0xFF09, # ）fullwidth right paren
        0xFF3D, # ］
        0xFF5D, # ｝
        0x30FC, # ー prolonged sound mark
      ].freeze

      def apply_line_end_compression(lines)
        lines.each do |line|
          last = line.glyphs.last
          next unless last
          next unless compressible?(last.codepoint)

          last.width /= 2.0
          line.width = line.glyphs.sum(&:width)
        end
        lines
      end

      def compressible?(codepoint)
        TRAILING_COMPRESSION_CODEPOINTS.include?(codepoint)
      end

      # Class-based mojikumi pair compression: a full-width
      # closing/middle glyph followed by another full-width
      # punctuation glyph compresses to half advance within the
      # line (。」、ー） … pairs), matching InDesign's default
      # mojikumi behavior for consecutive 約物.
      OPENING_CODEPOINTS = [
        0x300C, # 「
        0x300E, # 『
        0x3008, # 〈
        0x300A, # 《
        0x3010, # 【
        0x3014, # 〔
        0xFF08, # （fullwidth left paren
        0xFF3B, # ［
        0xFF5B, # ｛
      ].freeze

      MIDDLE_CODEPOINTS = [
        0x30FB, # ・ fullwidth middle dot
        0x30FC, # ー prolonged sound mark
        0x2025, # ‥ two-dot leader
        0x2026, # … ellipsis
      ].freeze

      def apply_pair_compression(lines)
        lines.each do |line|
          glyphs = line.glyphs
          (0...(glyphs.length - 1)).each do |index|
            leading = glyphs[index]
            following = glyphs[index + 1]
            next unless pair_compressible?(leading, following)

            leading.width /= 2.0
          end
          line.width = glyphs.sum(&:width)
        end
        lines
      end

      # Closing/middle glyph followed by full-width punctuation
      # compresses the leading glyph to half advance.
      def pair_compressible?(leading, following)
        return false unless fullwidth_punct?(following.codepoint)

        closing?(leading.codepoint) ||
          (middle?(leading.codepoint) &&
           !OPENING_CODEPOINTS.include?(following.codepoint))
      end

      def closing?(codepoint)
        TRAILING_COMPRESSION_CODEPOINTS.include?(codepoint)
      end

      def middle?(codepoint)
        MIDDLE_CODEPOINTS.include?(codepoint)
      end

      def fullwidth_punct?(codepoint)
        closing?(codepoint) || middle?(codepoint) ||
          OPENING_CODEPOINTS.include?(codepoint)
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
