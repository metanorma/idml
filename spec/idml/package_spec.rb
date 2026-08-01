# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Package do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:expected_part_names) do
    %w[
      META-INF/container.xml
      META-INF/metadata.xml
      MasterSpreads/MasterSpread_ud8.xml
      Resources/Fonts.xml
      Resources/Graphic.xml
      Resources/Preferences.xml
      Resources/Styles.xml
      Spreads/Spread_u15d.xml
      Spreads/Spread_ud1.xml
      Stories/Story_u13c.xml
      Stories/Story_u164.xml
      Stories/Story_ue1.xml
      Stories/Story_ufe.xml
      XML/BackingStory.xml
      XML/Tags.xml
      designmap.xml
      mimetype
    ]
  end

  describe ".open / .new" do
    it "returns a Package for an existing IDML file" do
      pkg = described_class.new(fixture_path)
      expect(pkg).to be_a(described_class)
      expect(pkg.path).to eq(fixture_path)
    end

    it "raises PackageNotFound when the path does not exist" do
      expect { described_class.new("/nonexistent.idml") }
        .to raise_error(Idml::Errors::PackageNotFound, %r{/nonexistent\.idml})
    end

    it "raises InvalidPackage for non-ZIP input on first operation" do
      Dir.mktmpdir do |dir|
        not_a_zip = File.join(dir, "bogus.idml")
        File.write(not_a_zip, "this is not a zip file")
        pkg = described_class.new(not_a_zip)
        expect { pkg.part_names }
          .to raise_error(Idml::Errors::InvalidPackage)
      end
    end
  end

  describe "#part_names" do
    it "returns every entry name in the package, sorted" do
      pkg = described_class.new(fixture_path)
      expect(pkg.part_names).to eq(expected_part_names)
    end

    it "memoizes the result" do
      pkg = described_class.new(fixture_path)
      first = pkg.part_names
      second = pkg.part_names
      expect(second.equal?(first)).to be(true)
    end
  end

  describe "#has_part?" do
    it "returns true for entries that exist" do
      pkg = described_class.new(fixture_path)
      expect(pkg.has_part?("designmap.xml")).to be(true)
      expect(pkg.has_part?("mimetype")).to be(true)
    end

    it "returns false for entries that do not exist" do
      pkg = described_class.new(fixture_path)
      expect(pkg.has_part?("nope.xml")).to be(false)
    end
  end

  describe "#read_part" do
    it "returns the raw XML bytes for the named part" do
      pkg = described_class.new(fixture_path)
      xml = pkg.read_part("XML/Tags.xml")
      expect(xml).to include("<idPkg:Tags")
      expect(xml).to include("XMLTag")
    end

    it "returns the mimetype bytes for the mimetype entry" do
      pkg = described_class.new(fixture_path)
      expect(pkg.read_part("mimetype")).to include("idml-package")
    end

    it "raises PartNotFound for unknown part names" do
      pkg = described_class.new(fixture_path)
      expect { pkg.read_part("nope.xml") }
        .to raise_error(Idml::Errors::PartNotFound, "nope.xml")
    end
  end

  describe "#each_part" do
    it "yields (name, content) pairs for every entry" do
      pkg = described_class.new(fixture_path)
      pairs = pkg.each_part.to_a
      names = pairs.map(&:first)
      expect(names.sort).to eq(expected_part_names)
      expect(pairs.length).to eq(expected_part_names.length)
    end

    it "returns an Enumerator when called without a block" do
      pkg = described_class.new(fixture_path)
      expect(pkg.each_part).to be_an(Enumerator)
    end
  end

  describe ".write" do
    it "writes a new IDML ZIP with the same parts and content" do
      pkg = described_class.new(fixture_path)
      parts = pkg.each_part.to_a.to_h { |name, content| [name, content] }

      Dir.mktmpdir do |dir|
        output = File.join(dir, "out.idml")
        written = described_class.write(parts: parts, to: output)
        expect(written).to be_a(described_class)
        expect(File.exist?(output)).to be(true)

        repkg = described_class.new(output)
        expect(repkg.part_names).to match_array(expected_part_names)

        # Per-entry byte-equivalence (the ZIP container itself may differ
        # in metadata like timestamps, so compare entries only).
        pkg.each_part do |name, original|
          expect(repkg.read_part(name).bytes).to eq(original.bytes), name
        end
      end
    end

    it "writes the mimetype entry stored and first" do
      pkg = described_class.new(fixture_path)
      parts = pkg.each_part.to_a.to_h { |name, content| [name, content] }

      Dir.mktmpdir do |dir|
        output = File.join(dir, "out.idml")
        described_class.write(parts: parts, to: output)

        raw = File.binread(output, 60).bytes
        # Local file header: PK\x03\x04
        expect(raw[0..3]).to eq([0x50, 0x4B, 0x03, 0x04])
        # Compression method at offset 8-9 (little-endian): 0 = stored
        compression_method = raw[8] | (raw[9] << 8)
        expect(compression_method).to eq(0)
        # File name length at offset 26-27 (little-endian)
        name_length = raw[26] | (raw[27] << 8)
        expect(name_length).to eq("mimetype".length)
        # File name itself at offset 30
        name = raw[30...(30 + name_length)].pack("C*")
        expect(name).to eq("mimetype")
      end
    end

    it "raises InvalidPackage when given no parts" do
      expect { described_class.write(parts: {}, to: "/tmp/x.idml") }
        .to raise_error(Idml::Errors::InvalidPackage)
    end
  end
end
