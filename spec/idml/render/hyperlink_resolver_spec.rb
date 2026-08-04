# frozen_string_literal: true

require "spec_helper"

FakeHyperlinkPackage = Struct.new(:designmap, keyword_init: true)
FakeHyperlinkDesignmap = Struct.new(:hyperlink, :hyperlink_url_destination,
                                    keyword_init: true)

RSpec.describe Idml::Render::HyperlinkResolver do
  describe "#url_for_source" do
    it "resolves the URL via the destination chain" do
      resolver = described_class.new(build_package)
      expect(resolver.url_for_source("HyperlinkTextSource/s1"))
        .to eq("https://example.com/page")
    end

    it "returns nil for an unknown source" do
      resolver = described_class.new(build_package)
      expect(resolver.url_for_source("unknown")).to be_nil
    end

    it "returns nil for nil input" do
      resolver = described_class.new(build_package)
      expect(resolver.url_for_source(nil)).to be_nil
    end
  end

  describe "#each_visible" do
    it "yields visible hyperlinks with resolvable URLs" do
      resolver = described_class.new(build_package)
      expect(resolver.each_visible.to_a)
        .to include(["HyperlinkTextSource/s1", "https://example.com/page"])
    end

    it "skips hidden hyperlinks and unresolved destinations" do
      resolver = described_class.new(build_package)
      sources = resolver.each_visible.to_a.map(&:first)
      expect(sources).to eq(["HyperlinkTextSource/s1"])
    end
  end

  def build_package
    FakeHyperlinkPackage.new(designmap: build_designmap)
  end

  def build_designmap
    FakeHyperlinkDesignmap.new(
      hyperlink: [hyperlink("s1", "u1", visible: true),
                  hyperlink("s2", "u1", hidden: true),
                  hyperlink("s3", "missing", visible: true)],
      hyperlink_url_destination: [url_destination("u1",
                                                  "https://example.com/page")],
    )
  end

  def hyperlink(source, dest, visible: nil, hidden: nil)
    h = Idml::Elements::Hyperlink.new
    h.source = "HyperlinkTextSource/#{source}"
    h.destination = "HyperlinkURLDestination/#{dest}"
    h.visible = visible unless visible.nil?
    h.hidden = hidden unless hidden.nil?
    h
  end

  def url_destination(suffix, url)
    d = Idml::Elements::HyperlinkURLDestination.new
    d.self_attr = "HyperlinkURLDestination/#{suffix}"
    d.destination_url = url
    d
  end
end
