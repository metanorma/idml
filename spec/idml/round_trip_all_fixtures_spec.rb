# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

# Verifies byte-equivalent round-trip for every .idml under spec/fixtures/.
# Skips any fixture documented as known-broken in
# spec/fixtures/ROUND_TRIP_NOTES.md.
RSpec.describe "IDML round-trip — every fixture" do
  fixtures = Dir[File.expand_path("../fixtures/**/*.idml", __dir__)]

  skip_list = begin
    File.read(File.expand_path("../fixtures/ROUND_TRIP_NOTES.md", __dir__))
      .scan(%r{^-\s+`([^`]+)`}).flatten
  rescue Errno::ENOENT
    []
  end

  fixtures.each do |path|
    rel = path.sub(%r{.*/spec/fixtures/}, "")

    it "#{rel} round-trips byte-equivalent per part" do
      skip "listed in ROUND_TRIP_NOTES.md" if skip_list.include?(rel)

      pkg = Idml::Package.new(path)
      parts = pkg.each_part.to_a.to_h { |name, content| [name, content] }

      Dir.mktmpdir do |dir|
        output = File.join(dir, "round-trip.idml")
        Idml::Package.write(parts: parts, to: output)

        repkg = Idml::Package.new(output)
        expect(repkg.part_names).to match_array(pkg.part_names)

        pkg.each_part do |name, original|
          expect(repkg.read_part(name).bytes).to eq(original.bytes), name
        end
      end
    end
  end
end
