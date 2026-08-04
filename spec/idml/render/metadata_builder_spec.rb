# frozen_string_literal: true

require "spec_helper"

# Bare package stub for the no-XMP case.
class BarePackageForMetadata
  def has_part?(_name)
    false
  end

  def read_part(_name)
    nil
  end
end

RSpec.describe Idml::Render::MetadataBuilder do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe "#build" do
    it "always includes Producer" do
      metadata = described_class.new(package).build
      expect(metadata[:Producer]).to include("idml gem")
    end

    it "always includes CreationDate in PDF format" do
      metadata = described_class.new(package).build
      expect(metadata[:CreationDate]).to match(/^D:\d{14}/)
    end

    it "extracts Creator from XMP when present" do
      metadata = described_class.new(package).build
      expect(metadata[:Creator]).to include("Adobe InDesign")
    end

    it "extracts CreationDate from XMP when present" do
      metadata = described_class.new(package).build
      expect(metadata[:CreationDate]).to match(/^D:2026/)
    end
  end

  describe "with a package lacking META-INF/metadata.xml" do
    let(:package) { BarePackageForMetadata.new }

    it "falls back to Producer and CreationDate defaults" do
      metadata = described_class.new(package).build
      expect(metadata.keys).to contain_exactly(:Producer, :CreationDate)
    end
  end
end
