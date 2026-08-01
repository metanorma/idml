# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Composition::ImportXml do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  it "returns a new Package (no mutation)" do
    result = described_class.new(package).call(xml_string: "<Root/>",
                                               at: "/Root")
    expect(result).to be_a(Idml::Package)
    expect(result.path).not_to eq(package.path)
  end

  it "does not destroy stories when given an unrelated XML" do
    result = described_class.new(package).call(xml_string: "<Root/>",
                                               at: "/Root")
    expect(result.part_names.grep(%r{\AStories/}).length)
      .to eq(package.part_names.grep(%r{\AStories/}).length)
  end
end
