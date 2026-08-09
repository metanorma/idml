# frozen_string: true

require "spec_helper"

# Lightweight font metrics stub. Real PdfrbFontMetrics requires a
# registered font; DropCap only needs `measure_text` to size the
# drop-cap glyph width.
DropCapFakeMetrics = Struct.new(:widths, keyword_init: true) do
  def measure_text(text, _size)
    widths.fetch(text, text.length * 10.0)
  end
end

RSpec.describe Idml::Render::DropCap do
  def paragraph(overrides = {})
    attrs = { runs: [], alignment: :left }.merge(overrides)
    Idml::Render::StyleResolver::Paragraph.new(**attrs)
  end

  def run(text)
    Idml::Render::StyleResolver::StyledRun.new(text: text, point_size: 12.0)
  end

  describe ".active?" do
    it "returns false when drop_cap_lines is nil" do
      expect(described_class.active?(paragraph(drop_cap_characters: 1))).to be false
    end

    it "returns false when drop_cap_characters is nil" do
      expect(described_class.active?(paragraph(drop_cap_lines: 3))).to be false
    end

    it "returns false when drop_cap_lines is zero" do
      expect(described_class.active?(
               paragraph(drop_cap_lines: 0, drop_cap_characters: 1),
             )).to be false
    end

    it "returns true when both are positive" do
      expect(described_class.active?(
               paragraph(drop_cap_lines: 3, drop_cap_characters: 1),
             )).to be true
    end
  end

  describe ".layout" do
    let(:metrics) { DropCapFakeMetrics.new(widths: { "A" => 36.0 }) }

    it "returns nil when paragraph has no drop caps" do
      result = described_class.layout(paragraph,
                                      font_metrics: metrics,
                                      base_size: 12.0,
                                      leading: 14.4)
      expect(result).to be_nil
    end

    it "extracts first N characters from first run" do
      para = paragraph(
        drop_cap_lines: 3, drop_cap_characters: 1, runs: [run("Apple")],
      )
      result = described_class.layout(para, font_metrics: metrics,
                                            base_size: 12.0, leading: 14.4)
      expect(result.text).to eq("A")
    end

    it "computes drop cap font_size as base_size × lines" do
      para = paragraph(
        drop_cap_lines: 3, drop_cap_characters: 1, runs: [run("Apple")],
      )
      result = described_class.layout(para, font_metrics: metrics,
                                            base_size: 12.0, leading: 14.4)
      expect(result.font_size).to eq(36.0)
    end

    it "computes height as leading × lines" do
      para = paragraph(
        drop_cap_lines: 3, drop_cap_characters: 1, runs: [run("Apple")],
      )
      result = described_class.layout(para, font_metrics: metrics,
                                            base_size: 12.0, leading: 14.4)
      expect(result.height).to be_within(0.001).of(14.4 * 3)
    end

    it "uses measured width from font metrics" do
      para = paragraph(
        drop_cap_lines: 3, drop_cap_characters: 1, runs: [run("Apple")],
      )
      result = described_class.layout(para, font_metrics: metrics,
                                            base_size: 12.0, leading: 14.4)
      expect(result.width).to eq(36.0)
      expect(result.wrap_offset).to eq(36.0)
    end

    it "returns nil when no font metrics provided" do
      para = paragraph(
        drop_cap_lines: 3, drop_cap_characters: 1, runs: [run("Apple")],
      )
      result = described_class.layout(para, font_metrics: nil,
                                            base_size: 12.0, leading: 14.4)
      expect(result).to be_nil
    end
  end

  describe ".extract_drop_cap_text" do
    it "takes N chars from the first run" do
      para = paragraph(runs: [run("Hello World")])
      expect(described_class.extract_drop_cap_text(para, 3)).to eq("Hel")
    end

    it "takes from multiple runs when first is short" do
      para = paragraph(runs: [run("Hi"), run(" there")])
      expect(described_class.extract_drop_cap_text(para, 5)).to eq("Hi th")
    end

    it "returns nil when runs is empty" do
      expect(described_class.extract_drop_cap_text(paragraph, 3)).to be_nil
    end
  end
end
