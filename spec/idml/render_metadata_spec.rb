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
end
