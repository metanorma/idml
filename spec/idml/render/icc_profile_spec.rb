# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::IccProfile do
  describe ".srgb_bytes" do
    around do |example|
      original_env = ENV.fetch("IDML_SRGB_ICC", nil)
      ENV.delete("IDML_SRGB_ICC")
      example.run
      ENV["IDML_SRGB_ICC"] = original_env if original_env
    end

    context "when IDML_SRGB_ICC env var points to a real file" do
      let(:tempfile) { Tempfile.new(["icc", ".icc"]) }
      let(:bytes) { "FAKE_ICC_BYTES_\x00\x01\x02".b }

      before do
        tempfile.write(bytes)
        tempfile.close
        ENV["IDML_SRGB_ICC"] = tempfile.path
      end

      after { tempfile.unlink }

      it "returns the env-var file's bytes" do
        expect(described_class.srgb_bytes).to eq(bytes)
      end
    end

    context "when env var is unset" do
      before { ENV.delete("IDML_SRGB_ICC") }

      it "returns bytes from the macOS system profile when present" do
        system_path = "/System/Library/ColorSync/Profiles/sRGB Profile.icc"
        skip "macOS sRGB profile not present" unless File.exist?(system_path)

        bytes = described_class.srgb_bytes
        expect(bytes).to be_a(String)
        expect(bytes.bytesize).to be > 100
      end

      it "returns nil when no candidate path exists" do
        stub_const("Idml::Render::IccProfile::GEM_DATA_PATH", "/nonexistent.icc")
        stub_const("Idml::Render::IccProfile::MACOS_SYSTEM_PATH", "/nonexistent.icc")
        expect(described_class.srgb_bytes).to be_nil
      end
    end
  end
end
