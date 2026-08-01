# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Composition::Prefix do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  it "returns a new Package (no mutation of the receiver)" do
    result = described_class.new(package).call(prefix: "test_")
    expect(result).to be_a(Idml::Package)
    expect(result.path).not_to eq(package.path)
  end

  it "prefixes every Self attribute in every part" do
    prefixed = described_class.new(package).call(prefix: "pre_")

    sample_names = %w[designmap.xml Spreads/Spread_ud1.xml
                      Stories/Story_u164.xml]
    sample_names.each do |name|
      original = package.read_part(name)
      new = prefixed.read_part(name)
      original.scan(/Self="([^"]+)"/).each do |(self_id)|
        expect(new).to include(%(Self="pre_#{self_id}"))
      end
    end
  end

  it "leaves the mimetype entry untouched" do
    prefixed = described_class.new(package).call(prefix: "x_")
    expect(prefixed.read_part("mimetype")).to eq(package.read_part("mimetype"))
  end
end

# InsertIdml, AddPageFromIdml, ImportXml, ExportXml each have their own
# dedicated spec file:
#   spec/idml/composition/insert_idml_spec.rb
#   spec/idml/composition/add_page_from_idml_spec.rb
#   spec/idml/composition/import_xml_spec.rb
#   spec/idml/composition/export_xml_spec.rb
