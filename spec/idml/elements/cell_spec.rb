# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements::Cell do
  describe "schema-faithful parsing" do
    let(:xml) do
      <<~XML
        <Cell Self="c1" Name="0:0" RowSpan="1" ColumnSpan="1"
              FillColor="Color/Red" FillTint="50"
              VerticalJustification="TopAlign">
          <ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/Normal">
            <CharacterStyleRange Self="csr1">
              <Content>Cell content</Content>
            </CharacterStyleRange>
          </ParagraphStyleRange>
        </Cell>
      XML
    end
    let(:cell) { described_class.from_xml(xml) }

    it "parses Self attribute" do
      expect(cell.self_attr).to eq("c1")
    end

    it "parses Name attribute (col:row encoding)" do
      expect(cell.name).to eq("0:0")
    end

    it "parses FillColor" do
      expect(cell.fill_color).to eq("Color/Red")
    end

    it "parses inline PSR > CSR > Content text" do
      expect(cell.text_content).to eq("Cell content")
    end

    it "computes [col, row] from Name" do
      expect(cell.col_row).to eq([0, 0])
    end

    it "returns nil for malformed Name" do
      cell.name = "invalid"
      expect(cell.col_row).to be_nil
    end
  end

  describe "#text_content" do
    it "returns empty string for cell with no PSR children" do
      cell = described_class.from_xml('<Cell Self="c1" Name="0:0"/>')
      expect(cell.text_content).to eq("")
    end
  end
end
