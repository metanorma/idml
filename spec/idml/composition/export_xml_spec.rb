# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Composition::ExportXml do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  it "returns a String" do
    result = described_class.new(package).call
    expect(result).to be_a(String)
  end

  it "returns empty string when no BackingStory structure" do
    pkg = Idml::Package.new(File.expand_path(
                              "../../fixtures/patrick_agostini/text.idml", __dir__
                            ))
    allow(pkg).to receive(:backing_story).and_return(nil)
    expect(described_class.new(pkg).call).to eq("")
  end
end
