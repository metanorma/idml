# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

FakeMetrics = Struct.new(:postscript_name, :units_per_em, :ascent,
                         :descent, :width_for_cp) do
  def glyph_width(_codepoint)
    width_for_cp || 500
  end
end

RSpec.describe Idml::Render::FontEmbedder do
  describe ".winansi_to_unicode" do
    it "maps ASCII bytes directly" do
      expect(described_class.winansi_to_unicode(65)).to eq(65) # 'A'
    end

    it "maps high bytes to Windows-1252 codepoints" do
      expect(described_class.winansi_to_unicode(128)).to eq(8364) # €
    end
  end

  describe ".scale_to_text_units" do
    it "scales font units to 1000/em" do
      expect(described_class.scale_to_text_units(500, 1000)).to eq(500)
      expect(described_class.scale_to_text_units(600, 2048)).to eq(293)
    end
  end

  describe ".widths_array" do
    it "returns 224 entries (chars 32-255)" do
      metrics = FakeMetrics.new("TestFont", 1000, 800, -200, 500)
      widths = described_class.widths_array(metrics)
      expect(widths.length).to eq(224)
      expect(widths.first).to eq(500) # char 32 (space)
    end
  end

  describe ".descriptor" do
    it "builds a FontDescriptor metadata hash" do
      metrics = FakeMetrics.new("Helvetica", 1000, 800, -200, 500)
      desc = described_class.descriptor(metrics)
      expect(desc[:font_name]).to eq("Helvetica")
      expect(desc[:flags]).to eq(32)
      expect(desc[:ascent]).to eq(800)
      expect(desc[:descent]).to eq(-200)
    end
  end
end
