# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::CharacterStyle do
  describe ".transform_text" do
    it "uppercases AllCaps" do
      expect(described_class.transform_text("hello", "AllCaps")).to eq("HELLO")
    end

    it "uppercases SmallCaps (true small-caps deferred to OTF feature)" do
      expect(described_class.transform_text("hello", "SmallCaps")).to eq("HELLO")
    end

    it "passes through normal text" do
      expect(described_class.transform_text("Hello", nil)).to eq("Hello")
      expect(described_class.transform_text("Hello", "Normal")).to eq("Hello")
    end
  end

  describe ".position_scale" do
    it "shrinks and lifts Superscript" do
      size, offset = described_class.position_scale("Superscript", 12.0)
      expect(size).to be_within(0.001).of(12.0 * 0.583)
      expect(offset).to be_within(0.001).of(12.0 * 0.333)
    end

    it "shrinks and drops Subscript" do
      size, offset = described_class.position_scale("Subscript", 12.0)
      expect(size).to be_within(0.001).of(12.0 * 0.583)
      expect(offset).to be_within(0.001).of(-12.0 * 0.0833)
    end

    it "passes through Normal / nil" do
      expect(described_class.position_scale(nil, 12.0)).to eq([12.0, 0.0])
      expect(described_class.position_scale("Normal", 12.0)).to eq([12.0, 0.0])
    end
  end

  describe ".text_kwargs" do
    let(:base) { { at: [10, 20], font: "F1", size: 12 } }

    it "returns base kwargs unchanged when run has no tracking" do
      run = Idml::Render::StyleResolver::StyledRun.new(text: "x")
      expect(described_class.text_kwargs(run, base)).to eq(base)
    end

    it "adds char_spacing when run has tracking" do
      run = Idml::Render::StyleResolver::StyledRun.new(text: "x",
                                                       tracking: 35.0)
      result = described_class.text_kwargs(run, base)
      expect(result[:char_spacing]).to eq(35.0)
    end
  end

  describe ".baseline_offset" do
    it "returns 0 when run has no baseline_shift" do
      run = Idml::Render::StyleResolver::StyledRun.new(text: "x")
      expect(described_class.baseline_offset(run)).to eq(0.0)
    end

    it "returns the baseline_shift value when set" do
      run = Idml::Render::StyleResolver::StyledRun.new(text: "x",
                                                       baseline_shift: 5.0)
      expect(described_class.baseline_offset(run)).to eq(5.0)
    end

    it "returns 0 when baseline_shift is 0" do
      run = Idml::Render::StyleResolver::StyledRun.new(text: "x",
                                                       baseline_shift: 0.0)
      expect(described_class.baseline_offset(run)).to eq(0.0)
    end
  end

  describe ".with_glyph_scaling" do
    it "yields directly when both scales are nil" do
      run = Idml::Render::StyleResolver::StyledRun.new(text: "x")
      expect { |b| described_class.with_glyph_scaling(nil, run, &b) }.to yield_with_no_args
    end

    it "yields directly when both scales are 100" do
      run = Idml::Render::StyleResolver::StyledRun.new(
        text: "x", horizontal_scale: 100.0, vertical_scale: 100.0,
      )
      expect { |b| described_class.with_glyph_scaling(nil, run, &b) }.to yield_with_no_args
    end
  end

  describe ".apply" do
    let(:writer) { Idml::Render::PdfrbWriter.new }
    let(:canvas) { writer.add_page(width: 400, height: 400) }

    def run(overrides = {})
      Idml::Render::StyleResolver::StyledRun.new(
        text: "x", point_size: 12.0, **overrides,
      )
    end

    def context_without_color
      Idml::Render::RenderContext.new(
        item: nil, package: nil, color_resolver: nil, page_height: 400,
      )
    end

    it "yields the block" do
      called = false
      described_class.apply(canvas, run, context_without_color,
                            x: 10, y: 20, width: 30, size: 12.0) do
        called = true
      end
      expect(called).to be true
    end

    it "draws an underline rectangle when run.underline is true" do
      described_class.apply(canvas, run(underline: true),
                            context_without_color,
                            x: 10, y: 100, width: 50, size: 12.0) do
        canvas.text("hi", at: [10, 100], font: "F1", size: 12)
      end
      write_to_temp_pdf(writer, "char-underline") do |path|
        expect(File.binread(path)).to match(/ re\b/)
      end
    end

    it "draws a strike rectangle when run.strike_thru is true" do
      described_class.apply(canvas, run(strike_thru: true),
                            context_without_color,
                            x: 10, y: 100, width: 50, size: 12.0) do
        canvas.text("hi", at: [10, 100], font: "F1", size: 12)
      end
      write_to_temp_pdf(writer, "char-strike") do |path|
        expect(File.binread(path)).to match(/ re\b/)
      end
    end
  end
end
