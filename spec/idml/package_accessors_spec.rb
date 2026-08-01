# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Package do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { described_class.new(fixture_path) }

  describe "#designmap" do
    it "returns a Designmap instance" do
      expect(package.designmap).to be_a(Idml::Parts::Designmap)
    end

    it "exposes DOMVersion" do
      expect(package.designmap.dom_version).to eq("21.5")
    end

    it "memoizes the result" do
      first = package.designmap
      expect(package.designmap).to equal(first)
    end
  end

  describe "#dom_version" do
    it "reads the version from designmap" do
      expect(package.dom_version).to eq("21.5")
    end
  end

  %i[backing_story fonts graphic style preferences tags].each do |accessor|
    describe "##{accessor}" do
      it "returns a typed instance" do
        instance = package.public_send(accessor)
        expect(instance).to respond_to(:to_xml)
      end
    end
  end

  describe "#mapping" do
    it "returns nil when Mapping.xml is absent" do
      expect(package.mapping).to be_nil
    end
  end

  describe "#style_mapping" do
    it "returns nil when StyleMapping.xml is absent" do
      expect(package.style_mapping).to be_nil
    end
  end

  describe "#spreads" do
    it "returns every Spread in the package" do
      spreads = package.spreads
      expect(spreads.length).to eq(2)
      expect(spreads).to all(be_a(Idml::Parts::Spread))
    end
  end

  describe "#master_spreads" do
    it "returns every MasterSpread" do
      expect(package.master_spreads.length).to eq(1)
      expect(package.master_spreads.first).to be_a(Idml::Parts::MasterSpread)
    end
  end

  describe "#stories" do
    it "returns every Story" do
      expect(package.stories.length).to eq(4)
      expect(package.stories).to all(be_a(Idml::Parts::Story))
    end
  end
end
