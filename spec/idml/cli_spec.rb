# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::CLI do
  let(:fixture_path) do
    File.expand_path("../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end

  describe "version" do
    it "prints the gem version" do
      expect { described_class.start(%w[version]) }
        .to output("#{Idml::VERSION}\n").to_stdout
    end
  end

  describe "parts" do
    it "lists every part name" do
      output = capture_stdout { described_class.start(["parts", fixture_path]) }
      expect(output).to include("designmap.xml")
      expect(output).to include("mimetype")
    end
  end

  describe "round_trip" do
    it "writes a new IDML with the same parts" do
      Dir.mktmpdir do |dir|
        output_path = File.join(dir, "out.idml")
        capture_stdout do
          described_class.start(["round_trip", fixture_path, "-o", output_path])
        end
        expect(File.exist?(output_path)).to be(true)
        new_pkg = Idml::Package.new(output_path)
        expect(new_pkg.part_names).to include("designmap.xml")
      end
    end
  end

  describe "prefix" do
    it "writes a new IDML with prefixed Self attributes" do
      Dir.mktmpdir do |dir|
        output_path = File.join(dir, "prefixed.idml")
        capture_stdout do
          described_class.start(["prefix", fixture_path, "x_", "-o",
                                 output_path])
        end
        expect(File.exist?(output_path)).to be(true)
        new_pkg = Idml::Package.new(output_path)
        expect(new_pkg.read_part("designmap.xml")).to include('Self="x_d"')
      end
    end
  end

  describe "text" do
    it "lists every story with its text when no Self given" do
      output = capture_stdout { described_class.start(["text", fixture_path]) }
      expect(output).to include("[u164]")
    end

    it "prints one story's text when Self given" do
      output = capture_stdout do
        described_class.start(["text", fixture_path, "u164"])
      end
      expect(output).to be_a(String)
    end
  end

  private

  def capture_stdout
    captured = StringIO.new
    original = $stdout
    $stdout = captured
    yield
    captured.string
  ensure
    $stdout = original
  end
end
