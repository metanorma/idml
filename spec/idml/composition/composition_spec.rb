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

RSpec.describe Idml::Composition::InsertIdml do
  it "is implemented (see insert_idml_spec.rb for behavior)"
end

RSpec.describe Idml::Composition::AddPageFromIdml do
  it "raises NotImplementedError" do
    pkg = Idml::Package.new(File.expand_path(
                              "../../fixtures/sample-with-image/sample-with-image.idml", __dir__
                            ))
    expect do
      described_class.new(pkg).call(source: pkg, page_number: 1, at: "/Root",
                                    only: "/Root/page[1]")
    end
      .to raise_error(NotImplementedError)
  end
end

RSpec.describe Idml::Composition::ImportXml do
  it "raises NotImplementedError" do
    pkg = Idml::Package.new(File.expand_path(
                              "../../fixtures/sample-with-image/sample-with-image.idml", __dir__
                            ))
    expect { described_class.new(pkg).call(xml_string: "<Root/>", at: "/Root") }
      .to raise_error(NotImplementedError)
  end
end

RSpec.describe Idml::Composition::ExportXml do
  it "raises NotImplementedError" do
    pkg = Idml::Package.new(File.expand_path(
                              "../../fixtures/sample-with-image/sample-with-image.idml", __dir__
                            ))
    expect { described_class.new(pkg).call }.to raise_error(NotImplementedError)
  end
end
