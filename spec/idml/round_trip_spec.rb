# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe "IDML whole-package round-trip" do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  it "round-trips every part with byte-equivalent content" do
    parts = package.each_part.to_a.to_h { |name, content| [name, content] }

    Dir.mktmpdir do |dir|
      output = File.join(dir, "round-trip.idml")
      Idml::Package.write(parts: parts, to: output)

      repkg = Idml::Package.new(output)
      expect(repkg.part_names).to match_array(package.part_names)

      package.each_part do |name, original|
        round_tripped = repkg.read_part(name)
        expect(round_tripped.bytes).to eq(original.bytes), name
      end
    end
  end

  it "keeps the mimetype entry stored and first" do
    parts = package.each_part.to_a.to_h { |name, content| [name, content] }

    Dir.mktmpdir do |dir|
      output = File.join(dir, "round-trip.idml")
      Idml::Package.write(parts: parts, to: output)

      header = File.binread(output, 60).bytes
      expect(header[0..3]).to eq([0x50, 0x4B, 0x03, 0x04])
      compression = header[8] | (header[9] << 8)
      expect(compression).to eq(0)
      name_length = header[26] | (header[27] << 8)
      expect(header[30...(30 + name_length)].pack("C*")).to eq("mimetype")
    end
  end

  it "parses every part into a typed model or Raw fallback" do
    package.part_names.each do |name|
      instance = package.part(name)
      expect(instance).to respond_to(:to_xml)
    end
  end
end
