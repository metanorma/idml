# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::Blending do
  describe ".args_for" do
    it "returns nil when setting is nil" do
      expect(described_class.args_for(nil)).to be_nil
    end

    it "returns nil when setting has no blending_setting" do
      setting = Idml::Elements::TransparencySetting.new
      expect(described_class.args_for(setting)).to be_nil
    end

    it "returns nil when BlendingSetting has no opacity or blend_mode" do
      setting = build_setting(opacity: nil, blend_mode: nil)
      expect(described_class.args_for(setting)).to be_nil
    end

    it "converts IDML Opacity (0-100) to alpha (0.0-1.0)" do
      setting = build_setting(opacity: 50.0, blend_mode: nil)
      expect(described_class.args_for(setting)).to eq(
        opacity: 0.5, blend_mode: "Normal",
      )
    end

    it "passes through PDF-compatible blend modes" do
      setting = build_setting(opacity: nil, blend_mode: "Multiply")
      expect(described_class.args_for(setting)).to eq(
        opacity: 1.0, blend_mode: "Multiply",
      )
    end

    it "keeps both opacity and blend_mode when both set" do
      setting = build_setting(opacity: 75.0, blend_mode: "Screen")
      expect(described_class.args_for(setting)).to eq(
        opacity: 0.75, blend_mode: "Screen",
      )
    end

    it "clamps opacity above 100 to 1.0" do
      setting = build_setting(opacity: 150.0, blend_mode: nil)
      expect(described_class.args_for(setting)).to eq(
        opacity: 1.0, blend_mode: "Normal",
      )
    end

    it "ignores Normal blend mode" do
      setting = build_setting(opacity: nil, blend_mode: "Normal")
      expect(described_class.args_for(setting)).to be_nil
    end

    it "ignores unknown blend modes" do
      setting = build_setting(opacity: nil, blend_mode: "Painter")
      expect(described_class.args_for(setting)).to be_nil
    end
  end

  describe ".wrap" do
    let(:writer) { Idml::Render::PdfrbWriter.new }
    let(:canvas) { writer.add_page(width: 100, height: 100) }

    it "yields directly when setting is nil" do
      allow(canvas).to receive(:with_transparency)
      described_class.wrap(canvas, nil) { :result }
      expect(canvas).not_to have_received(:with_transparency)
    end

    it "calls with_transparency when blending applies" do
      setting = build_setting(opacity: 50.0, blend_mode: "Multiply")
      allow(canvas).to receive(:with_transparency) { canvas.fill }
      described_class.wrap(canvas, setting) { canvas.fill }
      expect(canvas).to have_received(:with_transparency).with(
        opacity: 0.5, blend_mode: "Multiply",
      )
    end
  end

  def build_setting(opacity:, blend_mode:)
    blending = Idml::Elements::BlendingSetting.new
    blending.opacity = opacity
    blending.blend_mode = blend_mode
    setting = Idml::Elements::TransparencySetting.new
    setting.blending_setting = blending
    setting
  end
end
