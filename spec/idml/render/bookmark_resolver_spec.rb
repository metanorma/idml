# frozen_string_literal: true

require "spec_helper"

FakeBookmarkPage = Struct.new(:self_attr)
FakeBookmarkSpreadSo = Struct.new(:page)
FakeBookmarkSpread = Struct.new(:spread)
FakeBookmarkDesignmap = Struct.new(:bookmark, :hyperlink_page_destination,
                                   keyword_init: true)
FakeBookmarkPackage = Struct.new(:designmap, :spreads, keyword_init: true)

RSpec.describe Idml::Render::BookmarkResolver do
  let(:package) { build_package }

  describe "#each" do
    it "yields [title, page_index] for each resolvable bookmark" do
      resolver = described_class.new(package)
      results = resolver.each.to_a
      expect(results).to include(["Chapter 1", 0])
      expect(results).to include(["Chapter 2", 1])
    end

    it "skips bookmarks with unresolved destinations" do
      resolver = described_class.new(package)
      expect(resolver.each.to_a.length).to eq(2)
    end
  end

  def build_package
    FakeBookmarkPackage.new(designmap: build_designmap,
                            spreads: build_spreads)
  end

  def build_designmap
    FakeBookmarkDesignmap.new(
      bookmark: [bookmark("Chapter 1", "HyperlinkPageDestination/d1"),
                 bookmark("Chapter 2", "HyperlinkPageDestination/d2"),
                 bookmark("Broken", "HyperlinkPageDestination/missing")],
      hyperlink_page_destination: [destination("d1", "Page/p1"),
                                   destination("d2", "Page/p2")],
    )
  end

  def build_spreads
    [FakeBookmarkSpread.new([FakeBookmarkSpreadSo.new([FakeBookmarkPage.new("Page/p1")])]),
     FakeBookmarkSpread.new([FakeBookmarkSpreadSo.new([FakeBookmarkPage.new("Page/p2")])])]
  end

  def bookmark(name, destination_self)
    bm = Idml::Elements::Bookmark.new
    bm.name = name
    bm.destination = destination_self
    bm
  end

  def destination(suffix, page_self)
    d = Idml::Elements::HyperlinkPageDestination.new
    d.self_attr = "HyperlinkPageDestination/#{suffix}"
    d.destination_page = page_self
    d
  end
end
