# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::TextEngine::VerticalTextLayout do
  def frame(width: 200, height: 300)
    Idml::TextEngine::Frame.new(x: 0, y: 0, width: width, height: height)
  end

  def glyph(codepoint, width = 12.0)
    Idml::TextEngine::ShapedGlyph.new(codepoint, width, false)
  end

  describe ".layout" do
    it "stacks glyphs top-to-bottom from the text top" do
      glyphs = "日".each_codepoint.map { |cp| glyph(cp) }
      positioned, columns = described_class.layout(
        glyphs: glyphs, frame: frame, leading: 14.4, size: 12.0,
      )

      expect(columns).to eq(1)
      expect(positioned.first.y).to eq(300 - 12.0)
    end

    it "advances columns right-to-left" do
      # 6 glyphs of 60pt each in a 300pt column = 2 columns of 5/1.
      glyphs = (0...6).map { |i| glyph(0x6587 + i, 60.0) }
      positioned, columns = described_class.layout(
        glyphs: glyphs, frame: frame, leading: 72.0, size: 60.0,
      )

      expect(columns).to eq(2)
      first_column_x = positioned.first.x
      last_column_x = positioned.last.x
      expect(last_column_x).to be < first_column_x
      # Column 0 slot: [200 - 72, 200]; glyph (em 60) centered →
      # left edge at 128 + 6 = 134.
      expect(first_column_x).to eq(134.0)
    end

    it "respects insets for the column height" do
      framed = Idml::TextEngine::Frame.new(
        x: 0, y: 0, width: 100, height: 300,
        inset_top: 30, inset_bottom: 30, inset_right: 10
      )
      glyphs = (0...20).map { |i| glyph(0x6587 + i, 30.0) }
      positioned, columns = described_class.layout(
        glyphs: glyphs, frame: framed, leading: 36.0, size: 30.0,
      )

      # Usable height 240 → 8 glyphs per column of 30pt.
      expect(columns).to eq(3)
      expect(positioned.map(&:y).max).to be <= 270
    end

    it "breaks long unspaced runs at the column height" do
      glyphs = (0...10).map { |i| glyph(0x6587 + i, 40.0) }
      positioned, columns = described_class.layout(
        glyphs: glyphs, frame: frame, leading: 48.0, size: 40.0,
      )

      expect(columns).to eq(2)
      expect(positioned.length).to eq(10)
    end
  end
end
