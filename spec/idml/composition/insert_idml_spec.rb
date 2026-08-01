# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Composition::InsertIdml do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  it "returns a new Package (no mutation of the receiver)" do
    result = described_class.new(package).call(source: package)
    expect(result).to be_a(Idml::Package)
    expect(result.path).not_to eq(package.path)
  end

  it "prefixes both packages to avoid Self collisions" do
    result = described_class.new(package).call(source: package)
    new_designmap = result.read_part("designmap.xml")
    expect(new_designmap).to include('Self="dest_d"')
  end

  it "merges the source's stories into the destination" do
    result = described_class.new(package).call(source: package)
    expect(result.part_names.grep(%r{\AStories/}).length).to be >= 4
  end
end
