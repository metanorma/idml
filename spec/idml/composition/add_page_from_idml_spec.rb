# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Composition::AddPageFromIdml do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  it "returns a new Package (no mutation)" do
    result = described_class.new(package)
      .call(source: package, page_number: 1, at: "/Root",
            only: "/Root/page[1]")
    expect(result).to be_a(Idml::Package)
    expect(result.path).not_to eq(package.path)
  end

  it "preserves destination spreads" do
    result = described_class.new(package)
      .call(source: package, page_number: 1, at: "/Root",
            only: "/Root/page[1]")
    dest_spread_count = package.part_names.grep(%r{\ASpreads/}).length
    expect(result.part_names.grep(%r{\ASpreads/}).length).to be >= dest_spread_count
  end

  it "carries source stories through" do
    result = described_class.new(package)
      .call(source: package, page_number: 1, at: "/Root",
            only: "/Root/page[1]")
    source_stories = package.part_names.grep(%r{\AStories/}).length
    expect(result.part_names.grep(%r{\AStories/}).length).to be >= source_stories
  end
end
