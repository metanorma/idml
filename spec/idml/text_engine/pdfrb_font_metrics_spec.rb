# frozen_string_literal: true

require "spec_helper"
require "pdfrb"

RSpec.describe Idml::TextEngine::PdfrbFontMetrics do
  let(:font_path) { "/System/Library/Fonts/Supplemental/Arial.ttf" }
  let(:doc) { Pdfrb::Document.new }
  let(:resource) { doc.fonts.add(font_path) }
  let(:metrics) { described_class.new(doc.fonts, resource) }

  before { skip "Arial.ttf not available" unless File.exist?(font_path) }

  describe "#glyph_width" do
    it "returns an Integer advance width in font units" do
      expect(metrics.glyph_width("H".ord)).to be_an(Integer)
    end

    it "returns a positive width for printable ASCII" do
      expect(metrics.glyph_width("H".ord)).to be > 0
    end

    it "returns different widths for different glyphs" do
      narrow = metrics.glyph_width("i".ord)
      wide = metrics.glyph_width("W".ord)
      expect(wide).to be > narrow
    end

    it "accepts a String codepoint" do
      expect(metrics.glyph_width("H")).to eq(metrics.glyph_width("H".ord))
    end
  end

  describe "#measure_text" do
    it "returns the scaled width in PostScript points" do
      width = metrics.measure_text("Hello", size: 12)
      expect(width).to be_a(Float)
      expect(width).to be > 0
    end

    it "scales linearly with size" do
      small = metrics.measure_text("Hello", size: 10)
      large = metrics.measure_text("Hello", size: 20)
      expect(large / small).to be_within(0.01).of(2.0)
    end

    it "returns 0 for empty text" do
      expect(metrics.measure_text("", size: 12)).to eq(0.0)
    end

    it "returns 0 for nil text" do
      expect(metrics.measure_text(nil, size: 12)).to eq(0.0)
    end
  end

  describe "#units_per_em" do
    it "returns the font's units-per-em" do
      expect(metrics.units_per_em).to be_an(Integer)
      expect(metrics.units_per_em).to be > 0
    end
  end

  describe "#ascent and #descent" do
    it "returns numeric ascent" do
      expect(metrics.ascent).to be_an(Integer).or be_a(Float)
      expect(metrics.ascent).to be > 0
    end

    it "returns numeric descent (typically negative)" do
      expect(metrics.descent).to be_an(Integer).or be_a(Float)
      expect(metrics.descent).to be < 0
    end
  end

  describe "#postscript_name" do
    it "returns the resource Symbol as a string" do
      expect(metrics.postscript_name).to eq(resource.to_s)
    end
  end

  describe "#path" do
    it "returns nil (already registered with pdfrb)" do
      expect(metrics.path).to be_nil
    end
  end
end
