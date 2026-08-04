# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::StructureMapper do
  describe ".type_for" do
    it "maps TextFrame to :P" do
      expect(described_class.type_for(Idml::Elements::TextFrame.new)).to eq(:P)
    end

    it "maps Group to :Sect" do
      expect(described_class.type_for(Idml::Elements::Group.new)).to eq(:Sect)
    end

    it "maps Table to :Table" do
      expect(described_class.type_for(Idml::Elements::Table.new)).to eq(:Table)
    end

    it "maps GraphicLine to :Path" do
      expect(described_class.type_for(Idml::Elements::GraphicLine.new)).to eq(:Path)
    end

    it "maps Rectangle without image to :Path" do
      rect = Idml::Elements::Rectangle.new
      expect(described_class.type_for(rect)).to eq(:Path)
    end

    it "maps Rectangle with image to :Figure" do
      rect = rectangle_with_image
      expect(described_class.type_for(rect)).to eq(:Figure)
    end

    it "maps Polygon with image to :Figure" do
      poly = polygon_with_image
      expect(described_class.type_for(poly)).to eq(:Figure)
    end

    it "returns nil for unknown classes" do
      expect(described_class.type_for(Object.new)).to be_nil
    end
  end

  describe ".alt_for" do
    it "returns the rectangle name for figures" do
      rect = rectangle_with_image
      rect.name = "Photo of cathedral"
      expect(described_class.alt_for(rect)).to eq("Photo of cathedral")
    end

    it "returns nil for shapes without images" do
      rect = Idml::Elements::Rectangle.new
      expect(described_class.alt_for(rect)).to be_nil
    end

    it "returns nil for non-shapes" do
      frame = Idml::Elements::TextFrame.new
      expect(described_class.alt_for(frame)).to be_nil
    end
  end

  def rectangle_with_image
    Idml::Elements::Rectangle.from_xml(
      '<Rectangle Self="r1"><Image Self="i1"/></Rectangle>',
    )
  end

  def polygon_with_image
    Idml::Elements::Polygon.from_xml(
      '<Polygon Self="p1"><Image Self="i1"/></Polygon>',
    )
  end
end
