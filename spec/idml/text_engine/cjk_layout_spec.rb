# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::TextEngine::CjkLayout do
  describe ".cjk?" do
    it "detects CJK Unified Ideographs" do
      expect(described_class.cjk?(0x6587)).to be true # 文
    end

    it "detects Hiragana" do
      expect(described_class.cjk?(0x3042)).to be true # あ
    end

    it "detects Katakana" do
      expect(described_class.cjk?(0x30AB)).to be true # カ
    end

    it "detects Hangul" do
      expect(described_class.cjk?(0xAC00)).to be true # 가
    end

    it "rejects ASCII" do
      expect(described_class.cjk?(65)).to be false
    end

    it "rejects Latin Extended" do
      expect(described_class.cjk?(233)).to be false # é
    end
  end

  describe ".contains_cjk?" do
    it "returns true when text contains CJK" do
      expect(described_class.contains_cjk?("Hello 世界")).to be true
    end

    it "returns false for pure ASCII" do
      expect(described_class.contains_cjk?("Hello World")).to be false
    end
  end

  describe ".forbidden_start?" do
    it "marks closing brackets as forbidden at line start" do
      expect(described_class.forbidden_start?(0x300D)).to be true # 」
    end

    it "marks small kana as forbidden at line start" do
      expect(described_class.forbidden_start?(0x3063)).to be true # っ
    end

    it "does not mark regular kana" do
      expect(described_class.forbidden_start?(0x3042)).to be false # あ
    end
  end

  describe ".forbidden_end?" do
    it "marks opening brackets as forbidden at line end" do
      expect(described_class.forbidden_end?(0x300C)).to be true # 「
    end

    it "does not mark regular characters" do
      expect(described_class.forbidden_end?(0x6587)).to be false # 文
    end
  end

  describe ".apply_kinsoku" do
    let(:glyph_factory) do
      ->(cp, width = 10) { Idml::TextEngine::ShapedGlyph.new(cp, width, false) }
    end

    it "moves forbidden-start char to previous line" do
      line1 = Idml::TextEngine::Line.new([glyph_factory.call(0x6587)], 10, 0)
      line2 = Idml::TextEngine::Line.new(
        [glyph_factory.call(0x300D), glyph_factory.call(0x6587)], 20, 0
      )
      result = described_class.apply_kinsoku([line1, line2])
      expect(result[0].glyphs.last.codepoint).to eq(0x300D) # 」 moved to line 1
      expect(result[1].glyphs.first.codepoint).to eq(0x6587) # 文 starts line 2
    end

    it "moves forbidden-end char to next line" do
      line1 = Idml::TextEngine::Line.new(
        [glyph_factory.call(0x6587), glyph_factory.call(0x300C)], 20, 0
      )
      line2 = Idml::TextEngine::Line.new([glyph_factory.call(0x6587)], 10, 0)
      result = described_class.apply_kinsoku([line1, line2])
      expect(result[0].glyphs.last.codepoint).to eq(0x6587)
      expect(result[1].glyphs.first.codepoint).to eq(0x300C)
    end

    it "handles single line without error" do
      line = Idml::TextEngine::Line.new([glyph_factory.call(0x6587)], 10, 0)
      result = described_class.apply_kinsoku([line])
      expect(result.length).to eq(1)
    end
  end

  describe ".vertical_mode?" do
    it "returns true for TopToBottom" do
      expect(described_class.vertical_mode?("TopToBottom")).to be true
    end

    it "returns false for LeftToRightDirection" do
      expect(described_class.vertical_mode?("LeftToRightDirection")).to be false
    end
  end

  describe ".tate_chu_yoko?" do
    it "detects ASCII digits" do
      expect(described_class.tate_chu_yoko?(0x31)).to be true # '1'
    end

    it "detects fullwidth digits" do
      expect(described_class.tate_chu_yoko?(0xFF11)).to be true # １
    end

    it "rejects letters" do
      expect(described_class.tate_chu_yoko?(0x41)).to be false # 'A'
    end
  end

  describe ".apply_script_spacing" do
    def glyph(codepoint, width = 10.0)
      Idml::TextEngine::ShapedGlyph.new(codepoint, width, false)
    end

    it "widens the leading glyph at each CJK/Latin boundary" do
      glyphs = "日A1本".each_char.map { |c| glyph(c.ord) }
      described_class.apply_script_spacing(glyphs, 12.0)

      expect(glyphs[0].width).to eq(10.0 + (12.0 * 0.125))
      expect(glyphs[1].width).to eq(10.0)
      expect(glyphs[2].width).to eq(10.0 + (12.0 * 0.125))
      expect(glyphs[3].width).to eq(10.0)
    end

    it "leaves uniform-script runs untouched" do
      glyphs = "日本".each_char.map { |c| glyph(c.ord) }
      described_class.apply_script_spacing(glyphs, 12.0)
      expect(glyphs.map(&:width)).to eq([10.0, 10.0])

      latin = "AB".each_char.map { |c| glyph(c.ord) }
      described_class.apply_script_spacing(latin, 12.0)
      expect(latin.map(&:width)).to eq([10.0, 10.0])
    end

    it "ignores punctuation neighbors" do
      glyphs = "日!".each_char.map { |c| glyph(c.ord) }
      described_class.apply_script_spacing(glyphs, 12.0)
      expect(glyphs.map(&:width)).to eq([10.0, 10.0])
    end
  end
end
