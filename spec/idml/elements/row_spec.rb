# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements::Row do
  describe "schema-faithful parsing" do
    let(:xml) do
      <<~XML
        <Row Self="r1" Name="0" SingleRowHeight="24"
            MinimumHeight="20" MaximumHeight="100"
            FillColor="Color/Blue"/>
      XML
    end
    let(:row) { described_class.from_xml(xml) }

    it "parses Self attribute" do
      expect(row.self_attr).to eq("r1")
    end

    it "parses Name attribute (row index)" do
      expect(row.name).to eq("0")
    end

    it "parses SingleRowHeight" do
      expect(row.single_row_height).to eq(24.0)
    end

    it "parses FillColor" do
      expect(row.fill_color).to eq("Color/Blue")
    end
  end
end
