# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Parts::Raw do
  let(:xml) { "<Foo><Bar/>Hello</Foo>" }

  it "is NOT a Lutaml::Model::Serializable (it's a passthrough)" do
    expect(described_class.ancestors).not_to include(Lutaml::Model::Serializable)
  end

  it "includes Idml::Part" do
    expect(described_class.ancestors).to include(Idml::Part)
  end

  describe ".from_xml / #to_xml" do
    it "round-trips the XML verbatim (lossless)" do
      raw = described_class.from_xml(xml)
      expect(raw.to_xml).to eq(xml)
    end

    it "exposes the wrapped XML via #xml" do
      raw = described_class.from_xml(xml)
      expect(raw.xml).to eq(xml)
    end
  end
end
