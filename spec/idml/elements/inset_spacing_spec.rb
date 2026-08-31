# frozen_string_literal: true

require "spec_helper"

# InsetSpacing (TODO 151): the schema-faithful carrier of text
# frame insets (spec examples 31/32), replacing the invented
# InsetTop/Left/Bottom/Right attributes that real files never
# carried.
RSpec.describe Idml::Elements::InsetSpacing do
  def parse(xml)
    described_class.from_xml(xml)
  end

  it "parses a single unit value applying to all sides" do
    spacing = parse('<InsetSpacing type="unit">6</InsetSpacing>')
    expect(spacing.type).to eq("unit")
    expect(spacing.sides).to eq([6.0, 6.0, 6.0, 6.0])
  end

  it "parses a list as [top, right, bottom, left]" do
    spacing = parse(<<~XML)
      <InsetSpacing type="list">
        <ListItem type="unit">2</ListItem>
        <ListItem type="unit">3</ListItem>
        <ListItem type="unit">6</ListItem>
        <ListItem type="unit">3</ListItem>
      </InsetSpacing>
    XML
    expect(spacing.sides).to eq([2.0, 3.0, 6.0, 3.0])
  end

  it "tolerates missing entries with nil sides" do
    spacing = parse(<<~XML)
      <InsetSpacing type="list">
        <ListItem type="unit">2</ListItem>
      </InsetSpacing>
    XML
    expect(spacing.sides).to eq([2.0, nil, nil, nil])
  end

  it "parses through TextFramePreference's Properties" do
    pref = Idml::Elements::TextFramePreference.from_xml(<<~XML)
      <TextFramePreference Self="u1" TextColumnCount="2">
        <Properties>
          <InsetSpacing type="unit">6</InsetSpacing>
        </Properties>
      </TextFramePreference>
    XML
    expect(pref.properties.first.inset_spacing.sides)
      .to eq([6.0, 6.0, 6.0, 6.0])
  end

  it "no longer declares the invented inset attributes" do
    wire = Idml::Elements::TextFramePreference
      .mappings[:xml].attributes.map(&:name)
    expect(wire).not_to include("InsetTop", "InsetLeft",
                                "InsetBottom", "InsetRight")
  end
end
