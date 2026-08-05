# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements::CharacterStyleRange do
  describe "#text_content" do
    it "joins Content elements" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Hello</Content>
          <Content>World</Content>
        </CharacterStyleRange>
      XML
      expect(csr.text_content).to eq("HelloWorld")
    end

    it "includes HyperlinkTextSource wrapped text" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Click </Content>
          <HyperlinkTextSource Self="HyperlinkTextSource/h1" Name="link">
            <Content>here</Content>
          </HyperlinkTextSource>
        </CharacterStyleRange>
      XML
      expect(csr.text_content).to eq("Click here")
    end
  end

  describe "#attributed_text" do
    it "returns plain chars with no source_self" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Hi</Content>
        </CharacterStyleRange>
      XML
      result = csr.attributed_text
      expect(result.length).to eq(2)
      expect(result.none? { |t| t.key?(:source_self) }).to be true
    end

    it "tags chars inside HyperlinkTextSource with source Self" do
      csr = described_class.from_xml(<<~XML)
        <CharacterStyleRange Self="c1">
          <Content>Click </Content>
          <HyperlinkTextSource Self="HyperlinkTextSource/h1" Name="link">
            <Content>here</Content>
          </HyperlinkTextSource>
        </CharacterStyleRange>
      XML
      result = csr.attributed_text
      linked, plain = result.partition { |t| t.key?(:source_self) }

      expect(plain.map { |t| t[:char] }.join).to eq("Click ")
      expect(linked.map { |t| t[:char] }.join).to eq("here")
      expect(linked.map { |t| t[:source_self] }.uniq)
        .to eq(["HyperlinkTextSource/h1"])
    end
  end
end
