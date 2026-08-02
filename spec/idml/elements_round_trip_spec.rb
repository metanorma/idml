# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  def normalize_xml(str)
    str.gsub(/\s+/, " ").strip
  end

  describe "round-trip fidelity" do
    it "Page round-trips attributes" do
      page = package.spreads.first.spread.first.page.first
      xml = page.to_xml
      reparsed = Idml::Elements::Page.from_xml(xml)
      expect(reparsed.geometric_bounds).to eq(page.geometric_bounds)
      expect(reparsed.item_transform).to eq(page.item_transform)
    end

    it "Link round-trips LinkResourceURI" do
      spread = package.spreads.find { |s| s.spread.first.rectangle.any? }
      link = spread.spread.first.rectangle.first.image.first.link.first
      xml = link.to_xml
      reparsed = Idml::Elements::Link.from_xml(xml)
      expect(reparsed.link_resource_uri).to eq(link.link_resource_uri)
    end

    it "Image round-trips ItemTransform and Link child" do
      spread = package.spreads.find { |s| s.spread.first.rectangle.any? }
      image = spread.spread.first.rectangle.first.image.first
      xml = image.to_xml
      reparsed = Idml::Elements::Image.from_xml(xml)
      expect(reparsed.item_transform).to eq(image.item_transform)
      expect(reparsed.link.length).to eq(image.link.length)
    end

    it "Rectangle preserves fill_color and stroke_color" do
      rect = Idml::Elements::Rectangle.new
      rect.fill_color = "Color/Red"
      rect.stroke_color = "Color/Blue"
      rect.stroke_weight = 2.5
      xml = rect.to_xml
      reparsed = Idml::Elements::Rectangle.from_xml(xml)
      expect(reparsed.fill_color).to eq("Color/Red")
      expect(reparsed.stroke_color).to eq("Color/Blue")
      expect(reparsed.stroke_weight).to eq(2.5)
    end

    it "TextFrame preserves parent_story" do
      tf = Idml::Elements::TextFrame.new
      tf.parent_story = "u123"
      tf.content_type = "TextType"
      xml = tf.to_xml
      reparsed = Idml::Elements::TextFrame.from_xml(xml)
      expect(reparsed.parent_story).to eq("u123")
      expect(reparsed.content_type).to eq("TextType")
    end

    it "PathPointType preserves anchor coordinates" do
      point = Idml::Elements::PathPointType.from_xml(
        %(<PathPointType Anchor="100.5 200.25" />),
      )
      xml = point.to_xml
      reparsed = Idml::Elements::PathPointType.from_xml(xml)
      expect(reparsed.x).to eq(100.5)
      expect(reparsed.y).to eq(200.25)
    end

    it "PathGeometry round-trips bounding box" do
      xml = <<~XML
        <PathGeometry>
          <GeometryPathType PathOpen="false">
            <PathPointArray>
              <PathPointType Anchor="0 0" />
              <PathPointType Anchor="100 0" />
              <PathPointType Anchor="100 50" />
              <PathPointType Anchor="0 50" />
            </PathPointArray>
          </GeometryPathType>
        </PathGeometry>
      XML
      geom = Idml::Elements::PathGeometry.from_xml(xml)
      roundtrip_xml = geom.to_xml
      reparsed = Idml::Elements::PathGeometry.from_xml(roundtrip_xml)
      expect(reparsed.bounding_box).to eq([0.0, 0.0, 50.0, 100.0])
    end
  end

  describe "attribute-set conformance" do
    it "Page declares geometric_bounds" do
      expect(Idml::Elements::Page.attributes.keys).to include(:geometric_bounds)
    end

    it "Rectangle declares fill_color and stroke_color" do
      expect(Idml::Elements::Rectangle.attributes.keys)
        .to include(:fill_color, :stroke_color, :stroke_weight)
    end

    it "TextFrame declares parent_story" do
      expect(Idml::Elements::TextFrame.attributes.keys)
        .to include(:parent_story, :item_transform)
    end

    it "Link declares link_resource_uri" do
      expect(Idml::Elements::Link.attributes.keys)
        .to include(:link_resource_uri)
    end

    it "PathPointType declares anchor" do
      expect(Idml::Elements::PathPointType.attributes.keys)
        .to include(:anchor)
    end
  end
end
