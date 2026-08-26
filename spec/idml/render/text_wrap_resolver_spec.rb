# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::TextWrapResolver do
  describe ".build mode dispatch" do
    def wrap_item(mode, side: nil)
      side_attr = side ? %( TextWrapSide="#{side}") : ""
      Idml::Elements::Oval.from_xml(<<~XML)
        <Oval Self="o1">
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="40 60" LeftDirection="40 60" RightDirection="40 60"/>
                  <PathPointType Anchor="40 140" LeftDirection="40 140" RightDirection="40 140"/>
                  <PathPointType Anchor="160 140" LeftDirection="160 140" RightDirection="160 140"/>
                  <PathPointType Anchor="160 60" LeftDirection="160 60" RightDirection="160 60"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
          <TextWrapPreference TextWrapMode="#{mode}"#{side_attr}/>
        </Oval>
      XML
    end

    def spread_like(item)
      Struct.new(:page_items) do
        def each_page_item(&)
          page_items.each(&)
        end
      end.new([item])
    end

    def resolver_for(mode, side: nil)
      described_class.build(
        spread_like(wrap_item(mode, side: side)), page_height: 400
      )
    end

    it "carries TextWrapSide from XML into wrap_adjustment" do
      resolver = resolver_for("BoundingBoxTextWrap", side: "RightSide")
      # Oval spans x 40..160 in a 0..400 frame: text shifts past 160.
      expect(resolver.wrap_adjustment(300, 12, 0, 400))
        .to eq([160.0, 160.0])
    end

    it "accepts the schema spelling BoundingBoxTextWrap" do
      resolver = resolver_for("BoundingBoxTextWrap")
      expect(resolver.overlap_width(300, 12, 0, 400)).to eq(120)
    end

    it "keeps accepting the legacy BoundingBox spelling" do
      resolver = resolver_for("BoundingBox")
      expect(resolver.overlap_width(300, 12, 0, 400)).to eq(120)
    end

    it "builds a contour shape for Contour mode" do
      resolver = resolver_for("Contour")
      expect(resolver.overlap_width(400 - 100, 12, 0, 400)).to eq(120)
      # The rect polygon matches the bbox at mid-height.
      expect(resolver.overlap_width(400 - 132, 4, 0, 400))
        .to be_within(0.01).of(120)
    end

    it "treats JumpObjectTextWrap as the bounding box" do
      resolver = resolver_for("JumpObjectTextWrap")
      expect(resolver.overlap_width(300, 12, 0, 400)).to eq(120)
    end

    it "ignores None mode" do
      resolver = resolver_for("None")
      expect(resolver.overlap_width(300, 12, 0, 400)).to eq(0)
    end
  end

  describe "inverse wrap" do
    it "flips the region for a box contour: text stays inside" do
      inverse_box = described_class::Contour.new(
        x: 0, y: 300, width: 200, height: 100, inverse: true,
      )
      resolver = described_class.new([inverse_box])
      # Band inside the contour: avoid-region is the 200pt outside.
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(200)
    end

    it "blocks text entirely where the shape is absent" do
      inverse_box = described_class::Contour.new(
        x: 0, y: 300, width: 200, height: 100, inverse: true,
      )
      resolver = described_class.new([inverse_box])
      # Band outside the contour's y range: inside width 0 → the
      # whole frame is avoid-region.
      expect(resolver.overlap_width(100, 12, 0, 400)).to eq(400)
    end

    it "inverts a contour shape via the XML Inverse attribute" do
      item = Idml::Elements::Oval.from_xml(<<~XML)
        <Oval Self="o1">
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="40 60" LeftDirection="40 60" RightDirection="40 60"/>
                  <PathPointType Anchor="40 140" LeftDirection="40 140" RightDirection="40 140"/>
                  <PathPointType Anchor="160 140" LeftDirection="160 140" RightDirection="160 140"/>
                  <PathPointType Anchor="160 60" LeftDirection="160 60" RightDirection="160 60"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
          <TextWrapPreference TextWrapMode="Contour" Inverse="true"/>
        </Oval>
      XML
      spread = Struct.new(:page_items) do
        def each_page_item(&)
          page_items.each(&)
        end
      end.new([item])
      resolver = described_class.build(spread, page_height: 400)

      # Inside width 120 → avoid-region 280.
      expect(resolver.overlap_width(300, 12, 0, 400)).to eq(280)
    end
  end

  describe "#wrap_adjustment" do
    def contour_at(side)
      described_class::Contour.new(
        x: 100, y: 300, width: 50, height: 100, side: side,
      )
    end

    it "narrows by the full overlap for BothSides without shifting" do
      resolver = described_class.new([contour_at("BothSides")])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([50.0, 0.0])
    end

    it "treats a missing side as BothSides" do
      resolver = described_class.new([contour_at(nil)])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([50.0, 0.0])
    end

    it "keeps text left of the contour for LeftSide" do
      resolver = described_class.new([contour_at("LeftSide")])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([300.0, 0.0])
    end

    it "shifts text past the contour for RightSide" do
      resolver = described_class.new([contour_at("RightSide")])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([150.0, 150.0])
    end

    it "picks the roomier side for LargestArea" do
      resolver = described_class.new([contour_at("LargestArea")])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([150.0, 150.0])

      left_roomier = described_class::Contour.new(
        x: 250, y: 300, width: 50, height: 100, side: "LargestArea",
      )
      resolver = described_class.new([left_roomier])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([150.0, 0.0])
    end

    it "returns zero adjustment when the line misses the contour" do
      resolver = described_class.new([contour_at("RightSide")])
      expect(resolver.wrap_adjustment(100, 12, 0, 400)).to eq([0.0, 0.0])
    end

    it "approximates spine sides as BothSides" do
      resolver = described_class.new([contour_at("SideTowardsSpine")])
      expect(resolver.wrap_adjustment(350, 12, 0, 400)).to eq([50.0, 0.0])
    end
  end

  describe "#overlap_width" do
    let(:contour) do
      described_class::Contour.new(x: 100, y: 300, width: 50, height: 100)
    end

    it "returns 0 when line does not overlap contour vertically" do
      resolver = described_class.new([contour])
      expect(resolver.overlap_width(100, 12, 0, 400)).to eq(0)
    end

    it "returns 0 when line does not overlap contour horizontally" do
      resolver = described_class.new([contour])
      expect(resolver.overlap_width(350, 12, 0, 80)).to eq(0)
    end

    it "returns full contour width when line is inside contour" do
      resolver = described_class.new([contour])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(50)
    end

    it "returns partial width when contour extends past frame right" do
      wide = described_class::Contour.new(x: 380, y: 300, width: 100,
                                          height: 100)
      resolver = described_class.new([wide])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(20)
    end

    it "sums multiple overlapping contours" do
      second = described_class::Contour.new(x: 200, y: 300, width: 30,
                                            height: 100)
      resolver = described_class.new([contour, second])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(80)
    end

    it "returns 0 with no contours" do
      resolver = described_class.new([])
      expect(resolver.overlap_width(350, 12, 0, 400)).to eq(0)
    end
  end

  describe ".build" do
    it "returns resolver with no contours for spread without wrap prefs" do
      spread = Idml::Parts::Spread.from_xml(
        '<idPkg:Spread xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging">
          <Spread Self="s1"/>
        </idPkg:Spread>',
      )
      resolver = described_class.build(spread)
      expect(resolver.contours).to be_empty
    end
  end
end
