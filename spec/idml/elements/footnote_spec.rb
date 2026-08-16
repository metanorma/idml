# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements::Footnote do
  describe "parsing" do
    it "collects ParagraphStyleRange children with their CSRs" do
      footnote = described_class.from_xml(<<~XML)
        <Footnote>
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="9">
              <Content>Footnote text.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Footnote>
      XML
      expect(footnote.paragraph_style_range.length).to eq(1)
      csr = footnote.paragraph_style_range.first.character_style_range.first
      expect(csr.text_content).to eq("Footnote text.")
    end

    it "collects bare CharacterStyleRange children" do
      footnote = described_class.from_xml(<<~XML)
        <Footnote>
          <CharacterStyleRange PointSize="9">
            <Content>Bare footnote.</Content>
          </CharacterStyleRange>
        </Footnote>
      XML
      expect(footnote.character_style_range.length).to eq(1)
      expect(footnote.character_style_range.first.text_content)
        .to eq("Bare footnote.")
    end

    it "round-trips through XML" do
      xml = <<~XML
        <Footnote>
          <ParagraphStyleRange>
            <CharacterStyleRange PointSize="9">
              <Content>Keeps text.</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Footnote>
      XML
      reserialized = described_class.to_xml(described_class.from_xml(xml))
      expect(reserialized).to include("<Footnote>")
      expect(reserialized).to include("<ParagraphStyleRange>")
      expect(reserialized).to include("<Content>Keeps text.</Content>")
    end
  end

  describe "parent containers" do
    it "is reachable from CharacterStyleRange" do
      csr = Idml::Elements::CharacterStyleRange.from_xml(<<~XML)
        <CharacterStyleRange Self="c1" PointSize="12">
          <Content>Body.</Content>
          <Footnote>
            <ParagraphStyleRange>
              <CharacterStyleRange PointSize="9">
                <Content>Note.</Content>
              </CharacterStyleRange>
            </ParagraphStyleRange>
          </Footnote>
        </CharacterStyleRange>
      XML
      expect(csr.footnote.length).to eq(1)
      expect(csr.footnote.first).to be_a(described_class)
    end

    it "is reachable from StoryInner" do
      inner = Idml::Elements::StoryInner.from_xml(<<~XML)
        <Story Self="s1">
          <Footnote>
            <ParagraphStyleRange>
              <CharacterStyleRange PointSize="9">
                <Content>Story-level note.</Content>
              </CharacterStyleRange>
            </ParagraphStyleRange>
          </Footnote>
        </Story>
      XML
      expect(inner.footnote.length).to eq(1)
    end

    it "keeps footnote text out of the CSR body text" do
      csr = Idml::Elements::CharacterStyleRange.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Body.</Content>
          <Footnote>
            <ParagraphStyleRange>
              <CharacterStyleRange PointSize="9">
                <Content>Note.</Content>
              </CharacterStyleRange>
            </ParagraphStyleRange>
          </Footnote>
        </CharacterStyleRange>
      XML
      expect(csr.text_content).to eq("Body.")
    end
  end
end
