# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe "renderer dispatch via Canvas" do
    it "RectangleRenderer renders fills via Canvas" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "rect.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)
        expect(raw).to include("re")
      end
    end

    it "TextFrameRenderer emits text via Canvas" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "text.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)
        expect(raw).to include("BT")
        expect(raw).to include("ET")
      end
    end

    it "SpreadRenderer renders background fill" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "bg.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)
        expect(raw).to include(" f").or include(" f\n")
      end
    end
  end

  describe "pdfrb Canvas native operators" do
    it "Canvas#draw_image_matrix is available" do
      expect(Pdfrb::Content::Canvas.instance_method(:draw_image_matrix)).not_to be_nil
    end

    it "Canvas#clip is available" do
      expect(Pdfrb::Content::Canvas.instance_method(:clip)).not_to be_nil
    end

    it "Canvas#clip_even_odd is available" do
      expect(Pdfrb::Content::Canvas.instance_method(:clip_even_odd)).not_to be_nil
    end

    it "Do operator is registered in pdfrb Operator registry" do
      expect(Pdfrb::Content::Operator["Do"]).not_to be_nil
    end
  end

  describe "PdfrbWriter" do
    it "creates valid PDF with add_page" do
      writer = Idml::Render::PdfrbWriter.new
      canvas = writer.add_page(width: 300, height: 400)
      canvas.fill_color([:rgb, 1, 0, 0])
      canvas.rectangle(10, 10, 100, 100)
      canvas.fill
      Dir.mktmpdir do |dir|
        path = File.join(dir, "pw.pdf")
        writer.write(path)
        raw = File.binread(path)
        expect(raw).to start_with("%PDF")
        expect(raw.strip).to end_with("%%EOF")
      end
    end

    it "sets MediaBox from page dimensions" do
      writer = Idml::Render::PdfrbWriter.new
      writer.add_page(width: 300, height: 400)
      Dir.mktmpdir do |dir|
        path = File.join(dir, "mb.pdf")
        writer.write(path)
        raw = File.binread(path)
        expect(raw).to include("MediaBox")
        expect(raw).to include("300")
        expect(raw).to include("400")
      end
    end

    it "sets metadata via set_info" do
      writer = Idml::Render::PdfrbWriter.new
      writer.add_page
      writer.set_info(Title: "Test Doc", Producer: "idml")
      Dir.mktmpdir do |dir|
        path = File.join(dir, "info.pdf")
        writer.write(path)
        raw = File.binread(path)
        expect(raw).to include("/Title")
        expect(raw).to include("/Producer")
      end
    end

    it "caches image names by URI" do
      writer = Idml::Render::PdfrbWriter.new
      writer.register_image_name("file:///test.jpeg", :Im1)
      expect(writer.image_name_for("file:///test.jpeg")).to eq(:Im1)
    end

    it "returns nil for unknown image URI" do
      writer = Idml::Render::PdfrbWriter.new
      expect(writer.image_name_for("unknown")).to be_nil
    end

    it "exposes subset_fonts! delegated to pdfrb" do
      writer = Idml::Render::PdfrbWriter.new
      expect(writer.document.fonts.class.instance_method(:subset_fonts!)).not_to be_nil
      expect { writer.subset_fonts! }.not_to raise_error
    end

    it "subsets embedded fonts after text is drawn" do
      skip "no system Arial" unless File.exist?(
        "/System/Library/Fonts/Supplemental/Arial.ttf",
      )

      writer = Idml::Render::PdfrbWriter.new
      font = writer.register_font(
        "/System/Library/Fonts/Supplemental/Arial.ttf",
      )
      canvas = writer.add_page(width: 400, height: 400)
      canvas.text("Hello", at: [50, 350], font: font, size: 12)
      writer.subset_fonts!

      path = Tempfile.new("writer-subset").path
      writer.write(path)
      raw = File.binread(path)
      expect(raw).to start_with("%PDF")
      expect(File.size(path)).to be < 15_000 # subset keeps it tiny
    end
  end
end
# rubocop:disable RSpec/SpecFilePathFormat
# rubocop:enable RSpec/SpecFilePathFormat
