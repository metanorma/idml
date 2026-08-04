# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render do
  describe Idml::Render::ColorHelper do
    describe ".to_canvas" do
      it "converts RGB hash to pdfrb array" do
        result = described_class.to_canvas(model: :rgb, r: 0.5, g: 0.25, b: 0.75)
        expect(result).to eq([:rgb, 0.5, 0.25, 0.75])
      end

      it "converts CMYK hash to pdfrb array" do
        result = described_class.to_canvas(model: :cmyk, c: 0.1, m: 0.2,
                                           y: 0.3, k: 0.4)
        expect(result).to eq([:cmyk, 0.1, 0.2, 0.3, 0.4])
      end

      it "returns nil for nil input" do
        expect(described_class.to_canvas(nil)).to be_nil
      end
    end
  end

  describe Idml::Render::StyleResolver do
    let(:fixture_path) do
      File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                       __dir__)
    end
    let(:package) { Idml::Package.new(fixture_path) }

    describe ".extract_runs" do
      it "returns empty array for nil story" do
        expect(described_class.extract_runs(nil)).to eq([])
      end

      it "extracts runs from a story" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs).to be_an(Array)
        expect(runs).not_to be_empty
        expect(runs.first).to be_a(described_class::StyledRun)
      end

      it "each run has text content" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs.first.text).to be_a(String)
        expect(runs.first.text).not_to be_empty
      end

      it "each run has a point_size defaulting to 12.0" do
        story = package.story_by_id("ue1")
        runs = described_class.extract_runs(story)
        expect(runs.first.point_size).to eq(12.0)
      end
    end

    describe ".concatenate" do
      it "joins run text into single string" do
        run1 = described_class::StyledRun.new(text: "Hello ")
        run2 = described_class::StyledRun.new(text: "World")
        expect(described_class.concatenate([run1, run2])).to eq("Hello World")
      end
    end
  end

  describe Idml::Render::GradientResolver do
    describe ".gradient?" do
      it "returns true for Gradient/* names" do
        expect(described_class.gradient?("Gradient/MyGradient")).to be true
      end

      it "returns false for Color/* names" do
        expect(described_class.gradient?("Color/Red")).to be false
      end

      it "returns false for nil" do
        expect(described_class.gradient?(nil)).to be false
      end
    end
  end

  describe Idml::Render::FontReferenceResolver do
    let(:fixture_path) do
      File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                       __dir__)
    end
    let(:package) { Idml::Package.new(fixture_path) }

    describe ".build" do
      it "builds a lookup table from Fonts.xml" do
        resolver = described_class.build(package)
        expect(resolver).to be_a(described_class)
      end

      it "resolves font family names to PostScriptNames" do
        resolver = described_class.build(package)
        ps_name = resolver.resolve("Minion Pro")
        expect(ps_name).to be_a(String).or be_nil
      end

      it "returns nil for unknown font reference" do
        resolver = described_class.build(package)
        expect(resolver.resolve("NonExistentFont")).to be_nil
      end

      it "returns nil for nil input" do
        resolver = described_class.build(package)
        expect(resolver.resolve(nil)).to be_nil
      end
    end

    describe ".build with nil package" do
      it "returns a resolver with empty table" do
        resolver = described_class.build(nil)
        expect(resolver.resolve("Anything")).to be_nil
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
