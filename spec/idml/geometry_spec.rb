# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Geometry do
  describe ".translate" do
    it "adds the offset to the point" do
      point = described_class.offset(x: 10, y: 20)
      by = described_class.offset(x: 5, y: -3)
      result = described_class.translate(point, by: by)
      expect(result.x).to eq(15)
      expect(result.y).to eq(17)
    end

    it "returns a new Point (does not mutate)" do
      point = described_class.offset(x: 1, y: 1)
      result = described_class.translate(point,
                                         by: described_class.offset(x: 0, y: 0))
      expect(result).not_to equal(point)
    end
  end

  describe ".offset" do
    it "constructs a Point from x and y" do
      point = described_class.offset(x: 100, y: 200)
      expect(point.x).to eq(100)
      expect(point.y).to eq(200)
    end
  end
end
