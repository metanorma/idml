# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::ColorResolver do
  let(:graphic) do
    Idml::Package.new(fixture_path).graphic
  end

  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end

  describe "#resolve" do
    subject(:resolver) { described_class.new(graphic) }

    it "returns nil for Color/None" do
      expect(resolver.resolve("Color/None")).to be_nil
    end

    it "returns nil for nil input" do
      expect(resolver.resolve(nil)).to be_nil
    end

    it "returns nil for unknown color name" do
      expect(resolver.resolve("Color/NonExistent")).to be_nil
    end

    it "resolves a known CMYK color" do
      result = resolver.resolve("Color/Black")
      expect(result).to eq(model: :cmyk, c: 0.0, m: 0.0, y: 0.0, k: 1.0)
    end

    it "resolves Registration as full CMYK" do
      result = resolver.resolve("Color/Registration")
      expect(result[:k]).to eq(1.0)
    end

    it "caches lookups (returns identical result)" do
      first = resolver.resolve("Color/Black")
      second = resolver.resolve("Color/Black")
      expect(second).to be(first)
    end
  end
end
