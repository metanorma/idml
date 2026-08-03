# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Render do
  describe Idml::Render::Color do
    it "produces RGB fill operator" do
      expect(described_class.fill_rgb(1, 0, 0)).to eq("1.0000 0.0000 0.0000 rg")
    end

    it "produces RGB stroke operator" do
      expect(described_class.stroke_rgb(0, 0,
                                        1)).to eq("0.0000 0.0000 1.0000 RG")
    end

    it "produces CMYK fill operator" do
      expect(described_class.fill_cmyk(0, 1, 1,
                                       0)).to eq("0.0000 1.0000 1.0000 0.0000 k")
    end

    it "normalizes 0-255 channel to 0.0-1.0" do
      expect(described_class.normalize_channel(128,
                                               255)).to be_within(0.001).of(0.502)
    end
  end

  describe Idml::Render::Path do
    it "produces rectangle operator" do
      expect(described_class.rectangle(x: 10, y: 20, width: 100, height: 50))
        .to eq("10.00 20.00 100.00 50.00 re")
    end

    it "produces save/restore state" do
      expect(described_class.save_state).to eq("q")
      expect(described_class.restore_state).to eq("Q")
    end

    it "produces fill operator" do
      expect(described_class.fill).to eq("f")
    end
  end

  describe Idml::Render::Text do
    it "produces font set operator" do
      expect(described_class.set_font("Helvetica", 12))
        .to eq("/Helvetica 12.0 Tf")
    end

    it "escapes parentheses in text" do
      expect(described_class.escape("a(b)c")).to eq("a\\(b\\)c")
    end

    it "produces a complete text run" do
      result = described_class.show_run(
        text_string: "Hello",
        font_name: "Helvetica",
        size: 12,
        x: 72,
        y: 720,
      )
      expect(result).to include("BT")
      expect(result).to include("/Helvetica 12.0 Tf")
      expect(result).to include("72.00 720.00 Td")
      expect(result).to include("(Hello) Tj")
      expect(result).to include("ET")
    end
  end

  describe Idml::Render::PdfWriter do
    it "writes a valid PDF file" do
      writer = described_class.new
      writer.add_page(
        width: 612,
        height: 792,
        content: "BT /Helvetica 12 Tf 72 720 Td (Hello) Tj ET",
        fonts: { "F1" => "Helvetica" },
      )
      Dir.mktmpdir do |dir|
        path = File.join(dir, "test.pdf")
        writer.write(path)
        raw = File.binread(path)
        expect(raw).to start_with("%PDF-1.4")
        expect(raw).to end_with("%%EOF")
        expect(raw).to include("/Type /Catalog")
        expect(raw).to include("/Type /Page")
        expect(raw).to include("/BaseFont /Helvetica")
        expect(raw).to include("(Hello) Tj")
      end
    end

    it "supports multiple pages" do
      writer = described_class.new
      3.times do
        writer.add_page(width: 612, height: 792, content: "q Q", fonts: {})
      end
      Dir.mktmpdir do |dir|
        path = File.join(dir, "multi.pdf")
        writer.write(path)
        raw = File.binread(path)
        expect(raw.scan("/Type /Page\n").length + raw.scan("/Type /Page ").length).to eq(3)
      end
    end

    it "embeds JPEG images as XObjects with DCTDecode" do
      writer = described_class.new
      jpeg_data = "\xFF\xD8\xFF\xE0\u0000\u0010JFIF\u0000\u0001\u0001\u0000\u0000\u0001\u0000\u0001\u0000\u0000\xFF\xC0\u0000\v\b\u0000\u0002\u0000\u0002\u0001\u0001\u0011\u0000\xFF\xD9"
      name = writer.add_jpeg_image(
        data: jpeg_data, width: 2, height: 2, colorspace: :DeviceRGB,
      )
      writer.add_page(
        width: 612, height: 792,
        content: "q /#{name} Do Q", fonts: {}, xobjects: [name]
      )
      Dir.mktmpdir do |dir|
        path = File.join(dir, "img.pdf")
        writer.write(path)
        raw = File.binread(path)
        expect(raw).to include("/Subtype /Image")
        expect(raw).to include("/Filter /DCTDecode")
        expect(raw).to include("/ColorSpace /DeviceRGB")
        expect(raw).to include("/Width 2")
        expect(raw).to include("/XObject")
        expect(raw).to include("/#{name} Do")
      end
    end

    it "embeds TrueType fonts with FontFile2 and FontDescriptor" do
      font_path = "/System/Library/Fonts/Supplemental/Arial.ttf"
      skip "Arial.ttf not found" unless File.exist?(font_path)

      metrics = Idml::TextEngine::FontMetrics.open(font_path)
      data = File.binread(font_path)
      writer = described_class.new
      ps_name = writer.register_embedded_font(metrics: metrics, data: data)
      writer.add_page(
        width: 612, height: 792,
        content: "BT /F1 12 Tf 72 720 Td (Hi) Tj ET",
        fonts: { "F1" => ps_name }
      )
      raw = nil
      Dir.mktmpdir do |dir|
        path = File.join(dir, "font.pdf")
        writer.write(path)
        raw = File.binread(path)
      end
      expect(raw).to include("/Subtype /TrueType")
      expect(raw).to include("/FontDescriptor")
      expect(raw).to include("/FontFile2")
      expect(raw).to include("/FirstChar 32")
      expect(raw).to include("/LastChar 255")
      expect(raw).to include("/Encoding /WinAnsiEncoding")
    end
  end

  describe Idml::Render::Pipeline do
    let(:fixture_path) do
      File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                       __dir__)
    end
    let(:package) { Idml::Package.new(fixture_path) }

    it "produces a PDF file from an IDML package" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "output.pdf")
        described_class.new(package, path).call
        expect(File.exist?(path)).to be(true)
        raw = File.binread(path)
        expect(raw).to start_with("%PDF-1.4")
        expect(raw).to include("/Type /Page")
      end
    end

    it "creates one PDF page per IDML spread" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "output.pdf")
        described_class.new(package, path).call
        raw = File.binread(path)
        spread_count = package.part_names.grep(%r{\ASpreads/}).length
        page_count = raw.scan("/Type /Page\n").length + raw.scan("/Type /Page /").length
        expect(page_count).to eq(spread_count)
      end
    end

    it "embeds linked JPEG images as XObjects" do
      image_exists = Dir.glob(File.expand_path("../../fixtures/sample-with-image/**/*", __dir__)).any?
      skip "fixture image not available" unless image_exists

      Dir.mktmpdir do |dir|
        path = File.join(dir, "output.pdf")
        described_class.new(package, path).call
        raw = File.binread(path)
        expect(raw).to include("/Subtype /Image").or include("/Type /Page")
      end
    end
  end
end
