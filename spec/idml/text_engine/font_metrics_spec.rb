# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::TextEngine::FontMetrics do
  let(:font_path) { "/System/Library/Fonts/Supplemental/Arial.ttf" }
  let(:font) { described_class.open(font_path) }

  before do
    skip "Arial.ttf not available on this system" unless File.exist?(font_path)
  end

  describe ".open" do
    it "returns a FontMetrics instance" do
      expect(font).to be_a(described_class)
    end
  end

  describe "#units_per_em" do
    it "returns a positive integer" do
      expect(font.units_per_em).to be_a(Integer)
      expect(font.units_per_em).to be > 0
    end
  end

  describe "#ascent / #descent" do
    it "returns vertical metrics" do
      expect(font.ascent).to be_a(Integer)
      expect(font.descent).to be_a(Integer)
      expect(font.ascent).to be > 0
    end
  end

  describe "#glyph_width" do
    it "returns the advance width for 'A'" do
      width = font.glyph_width("A".ord)
      expect(width).to be_a(Integer)
      expect(width).to be > 0
    end

    it "returns 0 for .notdef (unknown codepoint)" do
      width = font.glyph_width(0x10FFFF)
      expect(width).to be >= 0
    end
  end

  describe "#measure_text" do
    it "returns a Float scaled to the given point size" do
      width = font.measure_text("Hello", size: 12)
      expect(width).to be_a(Float)
      expect(width).to be > 0
    end

    it "a longer string is wider than a shorter one" do
      short = font.measure_text("Hi", size: 12)
      long = font.measure_text("Hello World", size: 12)
      expect(long).to be > short
    end
  end

  describe "#postscript_name / #family_name / #style_name" do
    it "exposes font naming" do
      expect(font.postscript_name).to be_a(String)
      expect(font.family_name).to be_a(String)
    end
  end
end
