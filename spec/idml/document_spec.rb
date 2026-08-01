# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Document do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:document) { described_class.new(package) }

  describe "#dom_version" do
    it "delegates to the package" do
      expect(document.dom_version).to eq("21.5")
    end
  end

  describe "#find_by_self" do
    it "finds the part containing the given Self id" do
      part_name = document.find_by_self("uce")
      expect(part_name).to be_a(String)
      expect(part_name).to match(/\.xml\z/)
    end

    it "returns nil for an unknown Self" do
      expect(document.find_by_self("nonsensical_id")).to be_nil
    end
  end

  describe "#story_text" do
    it "returns the concatenated Content runs for the story" do
      text = document.story_text("u164")
      expect(text).to be_a(String)
    end

    it "returns empty string for an unknown story" do
      expect(document.story_text("nope")).to eq("")
    end
  end

  describe "#each_story" do
    it "yields [self_id, text] for every story" do
      pairs = document.each_story.to_a
      expect(pairs.length).to eq(4)
      self_ids = pairs.map(&:first)
      expect(self_ids).to include("u164", "u13c", "ue1", "ufe")
    end

    it "returns an Enumerator without a block" do
      expect(document.each_story).to be_an(Enumerator)
    end
  end

  describe "#xml_structure" do
    it "returns the typed BackingStory instance" do
      structure = document.xml_structure
      expect(structure).to be_a(Idml::Parts::BackingStory)
    end
  end

  describe "#tagged_elements" do
    it "returns a tuple per XMLElement across every story" do
      elements = document.tagged_elements
      expect(elements).to be_an(Array)
      expect(elements.first.length).to eq(3) if elements.any?
    end
  end
end
