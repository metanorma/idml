# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Validation::Validator do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:validator) { described_class.new }

  let(:jing_present) do
    ENV.fetch("PATH", "").split(File::PATH_SEPARATOR).any? do |dir|
      File.executable?(File.join(dir,
                                 "java")) && File.exist?(described_class::DEFAULT_JING_JAR)
    end
  end

  before do
    skip "Java and Jing required for validation spec" unless jing_present
  end

  describe "#validate_part" do
    it "returns ok for a valid Spread" do
      xml = package.read_part("Spreads/Spread_ud1.xml")
      result = validator.validate_part("Spreads/Spread_ud1.xml", xml)
      expect(result).to be_ok
      expect(result.errors).to be_empty
    end

    it "returns ok for designmap" do
      xml = package.read_part("designmap.xml")
      result = validator.validate_part("designmap.xml", xml)
      expect(result).to be_ok
    end

    it "returns errors for malformed XML" do
      broken = "<idPkg:Spread xmlns:idPkg=\"http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging\" DOMVersion=\"21.5\"><Unclosed></idPkg:Spread>"
      result = validator.validate_part("Spreads/Spread_broken.xml", broken)
      expect(result).not_to be_ok
      expect(result.errors).not_to be_empty
    end

    it "returns an error result when no schema is mapped" do
      result = validator.validate_part("META-INF/container.xml", "<x/>")
      expect(result).not_to be_ok
      expect(result.errors.first).to include("no schema mapping")
    end
  end

  describe "#validate_package" do
    it "validates every part with a schema mapping" do
      results = validator.validate_package(package)
      expect(results).to all(satisfy { |r| r.ok? || r.errors.any? })
      %w[designmap.xml XML/Tags.xml
         Resources/Fonts.xml].each do |n|
        expect(results.map(&:part_name)).to include(n)
      end
    end

    it "skips mimetype and META-INF entries" do
      results = validator.validate_package(package)
      expect(results.map(&:part_name)).not_to include("mimetype")
      expect(results.map(&:part_name)).not_to include("META-INF/container.xml")
    end
  end
end
