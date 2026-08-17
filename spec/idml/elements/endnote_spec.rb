# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements::Endnote do
  it "parses Self and the EndnoteTextRange reference" do
    endnote = described_class.from_xml(
      '<Endnote Self="Endnote/e1" EndnoteTextRange="Range/e1"/>',
    )
    expect(endnote.self_attr).to eq("Endnote/e1")
    expect(endnote.endnote_text_range).to eq("Range/e1")
  end

  it "round-trips through XML" do
    xml = '<Endnote Self="Endnote/e1" EndnoteTextRange="Range/e1"/>'
    expect(described_class.to_xml(described_class.from_xml(xml)))
      .to include('EndnoteTextRange="Range/e1"')
  end

  it "is reachable from StoryInner" do
    inner = Idml::Elements::StoryInner.from_xml(<<~XML)
      <Story Self="s1">
        <Endnote Self="Endnote/e1" EndnoteTextRange="Range/e1"/>
        <EndnoteRange Self="Range/e1" SourceEndnote="Endnote/e1"/>
      </Story>
    XML
    expect(inner.endnote.length).to eq(1)
    expect(inner.endnote_range.length).to eq(1)
    expect(inner.endnote_range.first.source_endnote).to eq("Endnote/e1")
  end

  it "parses the is_endnote_story flag" do
    inner = Idml::Elements::StoryInner.from_xml(
      '<Story Self="s1" IsEndnoteStory="true"/>',
    )
    expect(inner.is_endnote_story).to be(true)
  end
end
