# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Parts do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe ".register / .class_for" do
    it "returns Designmap for designmap.xml" do
      expect(described_class.class_for("designmap.xml")).to eq(Idml::Parts::Designmap)
    end

    it "returns Spread for any Spreads/Spread_*.xml" do
      expect(described_class.class_for("Spreads/Spread_ud1.xml")).to eq(Idml::Parts::Spread)
      expect(described_class.class_for("Spreads/Spread_u15d.xml")).to eq(Idml::Parts::Spread)
    end

    it "returns Story for any Stories/Story_*.xml" do
      expect(described_class.class_for("Stories/Story_u164.xml")).to eq(Idml::Parts::Story)
    end

    it "returns MasterSpread for MasterSpreads/MasterSpread_*.xml" do
      expect(described_class.class_for("MasterSpreads/MasterSpread_ud8.xml"))
        .to eq(Idml::Parts::MasterSpread)
    end

    it "returns the right class for each Resources/ part" do
      expect(described_class.class_for("Resources/Fonts.xml")).to eq(Idml::Parts::Fonts)
      expect(described_class.class_for("Resources/Graphic.xml")).to eq(Idml::Parts::Graphic)
      expect(described_class.class_for("Resources/Styles.xml")).to eq(Idml::Parts::Style)
      expect(described_class.class_for("Resources/StyleMapping.xml")).to eq(Idml::Parts::StyleMapping)
      expect(described_class.class_for("Resources/Preferences.xml")).to eq(Idml::Parts::Preferences)
    end

    it "returns the right class for each XML/ part" do
      expect(described_class.class_for("XML/BackingStory.xml")).to eq(Idml::Parts::BackingStory)
      expect(described_class.class_for("XML/Tags.xml")).to eq(Idml::Parts::Tags)
      expect(described_class.class_for("XML/Mapping.xml")).to eq(Idml::Parts::Mapping)
    end

    it "returns nil for entries with no typed class (META-INF, mimetype)" do
      expect(described_class.class_for("META-INF/container.xml")).to be_nil
      expect(described_class.class_for("META-INF/metadata.xml")).to be_nil
      expect(described_class.class_for("mimetype")).to be_nil
    end
  end

  describe ".all" do
    it "lists every registered part class" do
      expected = [
        Idml::Parts::Designmap, Idml::Parts::Spread, Idml::Parts::MasterSpread,
        Idml::Parts::Story, Idml::Parts::BackingStory, Idml::Parts::Fonts,
        Idml::Parts::Graphic, Idml::Parts::Style, Idml::Parts::StyleMapping,
        Idml::Parts::Preferences, Idml::Parts::Tags, Idml::Parts::Mapping
      ]
      expect(described_class.all).to match_array(expected)
    end

    it "excludes Raw (Raw is a fallback, not registered)" do
      expect(described_class.all).not_to include(Idml::Parts::Raw)
    end
  end

  # Shared spec: every typed part class behaves as a Lutaml serializable,
  # self-registers, and parses its fixture without error.
  shared_examples "a typed part class" do |part_name, klass|
    it "inherits from Lutaml::Model::Serializable" do
      expect(klass).to be < Lutaml::Model::Serializable
    end

    it "includes Idml::Part" do
      expect(klass.ancestors).to include(Idml::Part)
    end

    it "is registered for its file pattern" do
      expect(described_class.class_for(part_name)).to eq(klass)
    end

    it "parses the fixture part without error" do
      xml = package.read_part(part_name)
      expect { klass.from_xml(xml) }.not_to raise_error
    end

    it "extracts DOMVersion from the fixture" do
      xml = package.read_part(part_name)
      instance = klass.from_xml(xml)
      expect(instance.dom_version).to eq("21.5")
    end
  end

  it_behaves_like "a typed part class", "designmap.xml",                    Idml::Parts::Designmap
  it_behaves_like "a typed part class", "Spreads/Spread_ud1.xml",           Idml::Parts::Spread
  it_behaves_like "a typed part class", "MasterSpreads/MasterSpread_ud8.xml", Idml::Parts::MasterSpread
  it_behaves_like "a typed part class", "Stories/Story_u164.xml",           Idml::Parts::Story
  it_behaves_like "a typed part class", "XML/BackingStory.xml",             Idml::Parts::BackingStory
  it_behaves_like "a typed part class", "Resources/Fonts.xml",              Idml::Parts::Fonts
  it_behaves_like "a typed part class", "Resources/Graphic.xml",            Idml::Parts::Graphic
  it_behaves_like "a typed part class", "Resources/Styles.xml",             Idml::Parts::Style
  it_behaves_like "a typed part class", "Resources/Preferences.xml",        Idml::Parts::Preferences
  it_behaves_like "a typed part class", "XML/Tags.xml",                     Idml::Parts::Tags
end
