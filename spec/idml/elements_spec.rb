# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Elements do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:spread) { package.spreads.find { |s| s.spread.first.rectangle.any? } }
  let(:spread_obj) { spread.spread.first }

  describe Idml::Elements::Page do
    it "parses GeometricBounds and computes dimensions" do
      page = spread_obj.page.first
      expect(page.geometric_bounds).to eq("0 0 792 612")
      expect(page.width).to eq(612.0)
      expect(page.height).to eq(792.0)
    end

    it "parses ItemTransform" do
      page = spread_obj.page.first
      expect(page.item_transform).to eq("1 0 0 1 0 -396")
    end

    it "parses AppliedMaster" do
      page = spread_obj.page.first
      expect(page.applied_master).to eq("ud8")
    end
  end

  describe Idml::Elements::Rectangle do
    it "parses from spread XML" do
      rect = spread_obj.rectangle.first
      expect(rect).to be_a(described_class)
      expect(rect.content_type).to eq("GraphicType")
    end

    it "exposes ItemTransform" do
      rect = spread_obj.rectangle.first
      expect(rect.item_transform).to include("1 0 0 1 -251")
    end

    it "knows if it is a graphic frame" do
      rect = spread_obj.rectangle.first
      expect(rect.graphic?).to be true
    end

    it "contains child Image elements" do
      rect = spread_obj.rectangle.first
      expect(rect.image.length).to eq(1)
    end
  end

  describe Idml::Elements::TextFrame do
    it "parses from spread XML" do
      frame = spread_obj.text_frame.first
      expect(frame).to be_a(described_class)
    end

    it "exposes ParentStory" do
      frame = spread_obj.text_frame.first
      expect(frame.parent_story).to match(/\A[u\w]+\z/)
    end

    it "knows if it is a text frame" do
      frame = spread_obj.text_frame.first
      expect(frame.text?).to be true
    end
  end

  describe Idml::Elements::Image do
    let(:image) { spread_obj.rectangle.first.image.first }

    it "parses ItemTransform" do
      expect(image.item_transform).to include("0.10")
    end

    it "contains a Link child" do
      expect(image.link.length).to eq(1)
    end

    it "exposes resource_uri from the Link" do
      expect(image.resource_uri).to start_with("file:")
      expect(image.resource_uri).to include("GenAIImage")
    end
  end

  describe Idml::Elements::Link do
    let(:link) { spread_obj.rectangle.first.image.first.link.first }

    it "parses LinkResourceURI" do
      expect(link.link_resource_uri).to start_with("file:")
    end

    it "parses LinkResourceFormat" do
      expect(link.link_resource_format).to include("JPEG")
    end
  end

  describe Idml::Elements::SpreadObject do
    it "exposes typed child collections" do
      expect(spread_obj.page).to be_an(Array)
      expect(spread_obj.rectangle).to be_an(Array)
      expect(spread_obj.text_frame).to be_an(Array)
    end

    describe "#each_page_item" do
      it "yields every page item regardless of type" do
        items = spread_obj.each_page_item.to_a
        expect(items.length).to eq(spread_obj.page.length +
                                   spread_obj.rectangle.length +
                                   spread_obj.text_frame.length)
      end

      it "yields without a block (returns enumerator)" do
        expect(spread_obj.each_page_item).to be_an(Enumerator)
      end
    end
  end
end
