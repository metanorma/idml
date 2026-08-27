# frozen_string_literal: true

require "spec_helper"

# Named mojikumi sets (TODO 144): designmap-level MojikumiTable
# entries parse, round-trip, and expose their aki overrides.
RSpec.describe Idml::Elements::MojikumiTable do
  def mojikumi_table_xml
    <<~XML
      <MojikumiTable Self="MojikumiTable/$ID/Detail 5 level" Name="Detail 5 level" BasedOnMojikumiSet="LineEndAllOneEmEnum">
        <Properties>
          <OverrideMojikumiAkiList>
            <OverrideMojikumiAkiType TargetMojikumiClass="4" SideMojikumiClass="3" SideIsAfterTarget="true" Minimum="0" Desired="0.125" Maximum="0.25" CompressionPriority="1" AkiDoesNotFloat="true"/>
            <OverrideMojikumiAkiType TargetMojikumiClass="3" SideMojikumiClass="5" SideIsAfterTarget="false" Minimum="0.125" Desired="0.25" Maximum="0.5" CompressionPriority="2" AkiDoesNotFloat="false"/>
          </OverrideMojikumiAkiList>
        </Properties>
      </MojikumiTable>
    XML
  end

  def table
    described_class.from_xml(mojikumi_table_xml)
  end

  it "parses the identity attributes" do
    expect(table.self_attr).to eq("MojikumiTable/$ID/Detail 5 level")
    expect(table.name).to eq("Detail 5 level")
    expect(table.based_on_mojikumi_set).to eq("LineEndAllOneEmEnum")
  end

  it "exposes aki overrides flattened in document order" do
    overrides = table.aki_overrides
    expect(overrides.length).to eq(2)
    expect(overrides).to all(be_an(Idml::Elements::OverrideMojikumiAki))
  end

  it "parses each override's full attribute set" do
    first = table.aki_overrides.first
    expect(first.target_mojikumi_class).to eq(4)
    expect(first.side_mojikumi_class).to eq(3)
    expect(first.side_is_after_target).to be(true)
    expect(first.minimum).to eq(0)
    expect(first.desired).to eq(0.125)
    expect(first.maximum).to eq(0.25)
  end

  it "parses compression and float flags" do
    first, last = table.aki_overrides
    expect(first.compression_priority).to eq(1)
    expect(first.aki_does_not_float).to be(true)
    expect(last.side_is_after_target).to be(false)
    expect(last.aki_does_not_float).to be(false)
  end

  it "round-trips through XML" do
    reparsed = described_class.from_xml(described_class.to_xml(table))
    expect(reparsed.name).to eq(table.name)
    expect(reparsed.based_on_mojikumi_set).to eq(table.based_on_mojikumi_set)
    expect(reparsed.aki_overrides.length).to eq(table.aki_overrides.length)
    expect(reparsed.aki_overrides.map(&:desired))
      .to eq(table.aki_overrides.map(&:desired))
  end

  it "declares the full OverrideMojikumiAki attribute set" do
    expect(Idml::Elements::OverrideMojikumiAki.attributes.keys)
      .to contain_exactly(
        :target_mojikumi_class, :side_mojikumi_class,
        :side_is_after_target, :minimum, :desired, :maximum,
        :compression_priority, :aki_does_not_float
      )
  end

  describe "designmap wiring" do
    def designmap_xml
      <<~XML
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Document DOMVersion="21.5" Self="d1" StoryList="u1">
          <Layer Self="uce" Name="Layer 1" Visible="true" Locked="false" Printable="true"/>
          #{mojikumi_table_xml}
        </Document>
      XML
    end

    it "parses MojikumiTable children" do
      designmap = Idml::Parts::Designmap.from_xml(designmap_xml)
      expect(designmap.mojikumi_table.length).to eq(1)
      expect(designmap.mojikumi_table.first.name).to eq("Detail 5 level")
      expect(designmap.mojikumi_table.first.aki_overrides.length).to eq(2)
    end

    it "round-trips the designmap with the table" do
      designmap = Idml::Parts::Designmap.from_xml(designmap_xml)
      reparsed = Idml::Parts::Designmap.from_xml(
        Idml::Parts::Designmap.to_xml(designmap),
      )
      expect(reparsed.mojikumi_table.length).to eq(1)
      expect(reparsed.mojikumi_table.first.name).to eq("Detail 5 level")
      expect(reparsed.mojikumi_table.first.aki_overrides.length).to eq(2)
    end
  end
end
