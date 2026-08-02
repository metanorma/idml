# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements do
  describe Idml::Elements::PathPointType do
    describe "#x and #y" do
      it "parses anchor coordinates" do
        point = described_class.from_xml(
          %(<PathPointType Anchor="100.5 200.25" />),
        )
        expect(point.x).to eq(100.5)
        expect(point.y).to eq(200.25)
      end

      it "returns 0.0 when anchor is nil" do
        point = described_class.new
        expect(point.x).to eq(0.0)
        expect(point.y).to eq(0.0)
      end
    end
  end

  describe Idml::Elements::PathGeometry do
    let(:xml) do
      <<~XML
        <PathGeometry>
          <GeometryPathType PathOpen="false">
            <PathPointArray>
              <PathPointType Anchor="10 20" />
              <PathPointType Anchor="30 20" />
              <PathPointType Anchor="30 40" />
              <PathPointType Anchor="10 40" />
            </PathPointArray>
          </GeometryPathType>
        </PathGeometry>
      XML
    end

    describe "#bounding_box" do
      it "derives [y1, x1, y2, x2] from all anchor points" do
        geom = described_class.from_xml(xml)
        expect(geom.bounding_box).to eq([20.0, 10.0, 40.0, 30.0])
      end

      it "returns nil when no points" do
        geom = described_class.new
        expect(geom.bounding_box).to be_nil
      end
    end

    describe "#all_points" do
      it "flattens all points across geometry paths" do
        geom = described_class.from_xml(xml)
        expect(geom.all_points.length).to eq(4)
      end
    end
  end

  describe "Path geometry on page items" do
    let(:fixture_path) do
      File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                       __dir__)
    end
    let(:package) { Idml::Package.new(fixture_path) }

    it "Rectangle#geometric_bounds returns [y1, x1, y2, x2]" do
      spread = package.spreads.find { |s| s.spread.first.rectangle.any? }
      rect = spread.spread.first.rectangle.first
      bounds = rect.geometric_bounds
      expect(bounds).to be_an(Array)
      expect(bounds.length).to eq(4)
      expect(bounds[3]).to be > bounds[1] # x2 > x1
      expect(bounds[2]).to be > bounds[0] # y2 > y1
    end

    it "TextFrame#geometric_bounds returns bounds" do
      spread = package.spreads.first
      tf = spread.spread.first.text_frame.first
      expect(tf.geometric_bounds).to be_an(Array)
    end
  end
end
