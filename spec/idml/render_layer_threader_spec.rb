# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe Idml::Render::LayerFilter do
    describe ".from_designmap" do
      it "builds a filter from the document's layers" do
        filter = described_class.from_designmap(package.designmap)
        expect(filter).to be_a(described_class)
      end

      it "returns EXCLUDE_NONE when no layers exist" do
        filter = described_class.from_designmap(nil)
        expect(filter).to be(described_class::EXCLUDE_NONE)
      end
    end

    describe "#visible?" do
      let(:rect) { Idml::Elements::Rectangle.new }

      it "returns true when item has no ItemLayer" do
        filter = described_class.new(["uce"].to_set)
        rect.item_layer = nil
        expect(filter.visible?(rect)).to be true
      end

      it "returns true when ItemLayer is on a visible layer" do
        filter = described_class.new(["hidden"].to_set)
        rect.item_layer = "uce"
        expect(filter.visible?(rect)).to be true
      end

      it "returns false when ItemLayer is on a hidden layer" do
        filter = described_class.new(["uce"].to_set)
        rect.item_layer = "uce"
        expect(filter.visible?(rect)).to be false
      end

      it "returns true for non-page-item types (Page)" do
        filter = described_class.new(["uce"].to_set)
        page = Idml::Elements::Page.new
        expect(filter.visible?(page)).to be true
      end
    end

    describe "#filter" do
      it "selects only visible items" do
        filter = described_class.new(["hidden"].to_set)
        visible_rect = Idml::Elements::Rectangle.new
        visible_rect.item_layer = "uce"
        hidden_rect = Idml::Elements::Rectangle.new
        hidden_rect.item_layer = "hidden"
        result = filter.filter([visible_rect, hidden_rect])
        expect(result).to eq([visible_rect])
      end
    end
  end

  describe Idml::Render::StoryThreader do
    let(:spread) do
      package.spreads.find do |s|
        s.spread.first.text_frame.length > 1
      end
    end

    describe ".build_chains" do
      it "builds chains from PreviousTextFrame/NextTextFrame links" do
        chains = described_class.build_chains(spread)
        expect(chains).to be_an(Array)
        expect(chains).not_to be_empty
      end

      it "each chain has a story_id and frames array" do
        chains = described_class.build_chains(spread)
        chain = chains.first
        expect(chain.story_id).to be_a(String)
        expect(chain.frames).to be_an(Array)
        expect(chain.frames).not_to be_empty
      end

      it "chain head has previous_text_frame == 'n'" do
        chains = described_class.build_chains(spread)
        head = chains.first.frames.first
        expect(head.previous_text_frame).to eq("n").or be_nil
      end
    end
  end
end
