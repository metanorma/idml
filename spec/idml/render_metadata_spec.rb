# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Render do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe "PDF Info dictionary" do
    it "embeds Producer and CreationDate" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "meta.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)
        expect(raw).to include("/Info")
        expect(raw).to include("/Producer")
        expect(raw).to include("/CreationDate")
        expect(raw).to match(%r{D:\d{14}})
      end
    end
  end

  describe Idml::TextEngine::FontMetrics do
    it "caches by file path" do
      font_path = "/System/Library/Fonts/Supplemental/Arial.ttf"
      skip "Arial.ttf not found" unless File.exist?(font_path)

      described_class.clear_cache
      m1 = described_class.open(font_path)
      m2 = described_class.open(font_path)
      expect(m1.object_id).to eq(m2.object_id)
    end
  end
end
