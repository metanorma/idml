# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::Placement do
  describe ".box" do
    it "returns nil when item has no geometric_bounds" do
      item = item_double(nil, "1 0 0 1 0 0")
      expect(described_class.box(item, 792)).to be_nil
    end

    it "returns a placement rect when bounds are present" do
      item = item_double([0, 0, 100, 100], "1 0 0 1 0 0")
      result = described_class.box(item, 792)
      expect(result).to include(:x, :y, :width, :height)
      expect(result[:width]).to be > 0
      expect(result[:height]).to be > 0
    end

    it "returns a fallback rect when bounds are absent and fallback: true" do
      item = item_double(nil, "1 0 0 1 0 0")
      result = described_class.box(item, 792, fallback: true)
      expect(result).to include(:x, :y, :width, :height)
      expect(result[:width]).to eq(400.0)
    end

    it "fallback y is offset from page_height" do
      item = item_double(nil, "1 0 0 1 0 0")
      result = described_class.box(item, 792, fallback: true)
      expect(result[:y]).to be < 792
    end
  end

  describe "FALLBACK" do
    it "is a frozen Hash" do
      expect(described_class::FALLBACK).to be_a(Hash)
      expect(described_class::FALLBACK[:x]).to eq(72.0)
      expect(described_class::FALLBACK[:width]).to eq(400.0)
    end
  end

  def item_double(bounds, transform)
    Struct.new(:geometric_bounds, :item_transform, keyword_init: true).new(
      geometric_bounds: bounds,
      item_transform: transform,
    )
  end
end
