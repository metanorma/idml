# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Elements::CharacterStyleRange do
  describe "story-embedded anchored page items" do
    let(:anchored_rect_xml) do
      <<~XML
        <Rectangle Self="rect1" ItemTransform="1 0 0 1 100 100" FillColor="Color/Red">
          <AnchoredObjectSetting AnchoredPosition="InlinePosition" AnchorPoint="TopLeftAnchor" AnchorXoffset="0" AnchorYoffset="0" AnchorSpaceAbove="0"/>
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="0 0" LeftDirection="0 0" RightDirection="0 0"/>
                  <PathPointType Anchor="0 50" LeftDirection="0 50" RightDirection="0 50"/>
                  <PathPointType Anchor="80 50" LeftDirection="80 50" RightDirection="80 50"/>
                  <PathPointType Anchor="80 0" LeftDirection="80 0" RightDirection="80 0"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
        </Rectangle>
      XML
    end

    it "parses from a CharacterStyleRange" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1" PointSize="12">
          <Content>Body.</Content>
          #{anchored_rect_xml}
        </CharacterStyleRange>
      XML
      expect(csr.rectangle.length).to eq(1)
      expect(csr.rectangle.first.self_attr).to eq("rect1")
    end

    it "parses the AnchoredObjectSetting with its anchor attributes" do
      rect = Idml::Elements::Rectangle.from_xml(anchored_rect_xml)
      setting = rect.anchored_object_setting
      expect(setting).to be_a(Idml::Elements::AnchoredObjectSetting)
      expect(setting.anchored_position).to eq("InlinePosition")
      expect(setting.anchor_point).to eq("TopLeftAnchor")
      expect(setting.anchor_xoffset).to eq(0.0)
      expect(setting.anchor_yoffset).to eq(0.0)
    end

    it "parses anchored_position AboveLine and Anchored variants" do
      %w[AboveLine Anchored].each do |position|
        rect = Idml::Elements::Rectangle.from_xml(<<~XML)
          <Rectangle Self="r">
            <AnchoredObjectSetting AnchoredPosition="#{position}"/>
          </Rectangle>
        XML
        expect(rect.anchored_object_setting.anchored_position).to eq(position)
      end
    end

    it "collects the other embedded item types from a CSR" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Body.</Content>
          <Oval Self="o1"><AnchoredObjectSetting AnchoredPosition="InlinePosition"/></Oval>
          <Polygon Self="p1"><AnchoredObjectSetting AnchoredPosition="Anchored"/></Polygon>
          <GraphicLine Self="gl1"><AnchoredObjectSetting AnchoredPosition="AboveLine"/></GraphicLine>
          <Group Self="g1"><AnchoredObjectSetting AnchoredPosition="Anchored"/></Group>
        </CharacterStyleRange>
      XML
      expect(csr.oval.length).to eq(1)
      expect(csr.polygon.length).to eq(1)
      expect(csr.graphic_line.length).to eq(1)
      expect(csr.group.length).to eq(1)
    end

    it "keeps embedded items out of the CSR body text" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Body.</Content>
          #{anchored_rect_xml}
        </CharacterStyleRange>
      XML
      expect(csr.text_content).to eq("Body.")
    end

    it "round-trips the anchored setting through XML" do
      rect = Idml::Elements::Rectangle.from_xml(anchored_rect_xml)
      reserialized = Idml::Elements::Rectangle.to_xml(rect)
      expect(reserialized).to include("<AnchoredObjectSetting")
      expect(reserialized).to include('AnchoredPosition="InlinePosition"')
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
