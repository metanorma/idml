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

  describe ".scale" do
    it "multiplies each coordinate by the scale factor" do
      point = described_class.offset(x: 10, y: 20)
      by = described_class.offset(x: 2, y: 0.5)
      result = described_class.scale(point, by: by)
      expect(result.x).to eq(20)
      expect(result.y).to eq(10)
    end

    it "defaults to identity (factor of 1)" do
      point = described_class.offset(x: 7, y: 9)
      result = described_class.scale(point)
      expect(result.x).to eq(7)
      expect(result.y).to eq(9)
    end
  end

  describe ".rotate" do
    it "rotates 90 degrees counterclockwise around the origin" do
      point = described_class.offset(x: 1, y: 0)
      result = described_class.rotate(point, angle_degrees: 90)
      expect(result.x).to be_within(0.0001).of(0)
      expect(result.y).to be_within(0.0001).of(1)
    end

    it "rotates 180 degrees" do
      point = described_class.offset(x: 3, y: 4)
      result = described_class.rotate(point, angle_degrees: 180)
      expect(result.x).to be_within(0.0001).of(-3)
      expect(result.y).to be_within(0.0001).of(-4)
    end

    it "rotates 270 degrees counterclockwise (= 90 clockwise)" do
      point = described_class.offset(x: 1, y: 0)
      result = described_class.rotate(point, angle_degrees: 270)
      expect(result.x).to be_within(0.0001).of(0)
      expect(result.y).to be_within(0.0001).of(-1)
    end

    it "rotates around an arbitrary origin" do
      point = described_class.offset(x: 11, y: 5)
      around = described_class.offset(x: 10, y: 5)
      result = described_class.rotate(point, angle_degrees: 90, around: around)
      expect(result.x).to be_within(0.0001).of(10)
      expect(result.y).to be_within(0.0001).of(6)
    end

    it "0 degrees is identity" do
      point = described_class.offset(x: 5, y: 7)
      result = described_class.rotate(point, angle_degrees: 0)
      expect(result.x).to eq(5)
      expect(result.y).to eq(7)
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
