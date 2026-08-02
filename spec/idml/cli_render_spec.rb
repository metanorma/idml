# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::CLI do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end

  describe "render" do
    it "converts IDML to PDF" do
      Dir.mktmpdir do |dir|
        output = File.join(dir, "output.pdf")
        described_class.start(["render", fixture_path, "-o", output])
        expect(File.exist?(output)).to be(true)
        raw = File.binread(output)
        expect(raw).to start_with("%PDF-1.4")
        expect(raw).to end_with("%%EOF")
      end
    end

    it "accepts --font-path option" do
      Dir.mktmpdir do |dir|
        output = File.join(dir, "output.pdf")
        described_class.start([
                                "render", fixture_path, "-o", output,
                                "--font-path", "/System/Library/Fonts"
                              ])
        expect(File.exist?(output)).to be(true)
      end
    end
  end
end
