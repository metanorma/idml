# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::FontSetup do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:setup) { described_class.new(package: package) }

  describe "#register" do
    it "returns a Symbol font resource when a system font is found" do
      resource = setup.register(writer)
      expect(resource).to be_a(Symbol).or eq(Idml::Render::DEFAULT_FONT)
    end

    it "falls back to DEFAULT_FONT when no font file resolves" do
      bare = Struct.new(:fonts).new(nil)
      bare_setup = described_class.new(package: bare)
      expect(bare_setup.register(writer)).to eq(Idml::Render::DEFAULT_FONT)
    end
  end

  describe "#metrics_for" do
    it "returns nil for the default font fallback" do
      expect(setup.metrics_for(writer, Idml::Render::DEFAULT_FONT)).to be_nil
    end

    it "returns a PdfrbFontMetrics for a real font resource" do
      resource = setup.register(writer)
      skip "no system font available" if resource == Idml::Render::DEFAULT_FONT

      metrics = setup.metrics_for(writer, resource)
      expect(metrics).to be_a(Idml::TextEngine::PdfrbFontMetrics)
    end
  end
end
