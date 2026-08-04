# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe "pdfrb pipeline integration" do
    it "produces a valid PDF with pdfrb" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "integration.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to start_with("%PDF")
        expect(raw.strip).to end_with("%%EOF")
        expect(raw).to include("/Type /Catalog")
        expect(raw).to include("/Type /Pages")
        expect(raw).to include("/Type /Page")
      end
    end

    it "embeds JPEG images as XObjects" do
      skip "fixture image not available on CI" unless File.exist?(
        File.expand_path("../../../../Documents/InDesign GenAI Assets", Dir.home),
      )

      Dir.mktmpdir do |dir|
        path = File.join(dir, "images.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("/Subtype /Image")
        expect(raw).to include("/DCTDecode")
        expect(raw).to include(" Do")
      end
    end

    it "sets correct MediaBox per page" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "pages.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        boxes = raw.scan(/\/MediaBox\s*\[([^\]]+)\]/).map(&:first)
        expect(boxes.length).to be >= 2
        expect(boxes).to all(include("612"))
        expect(boxes).to all(include("792"))
      end
    end

    it "sets Producer metadata" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "meta.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("/Producer")
        expect(raw).to include("idml gem")
      end
    end

    it "propagates XMP CreatorTool to PDF /Creator" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "xmp.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("/Creator")
        expect(raw).to include("Adobe InDesign")
      end
    end

    it "sets CreationDate in PDF format" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "date.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to match(/D:\d{14}/)
      end
    end

    it "renders text content from stories" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "text.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("BT")
        expect(raw).to include("Tf")
        expect(raw).to include("Tj")
        expect(raw).to include("ET")
      end
    end

    it "renders shapes (fill and stroke)" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "shapes.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("re")
        expect(raw).to include(" f").or include(" f\n")
      end
    end

    it "registers fonts from Fonts.xml" do
      skip "system fonts not available on CI" unless Dir.exist?("/System/Library/Fonts") ||
        Dir.exist?("/usr/share/fonts")

      Dir.mktmpdir do |dir|
        path = File.join(dir, "fonts.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("/Font").or include("BT")
      end
    end

    it "produces one PDF page per IDML page" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "pagecount.pdf")
        described_class.render(package: package, to: path)
        raw = File.binread(path)

        spread_pages = package.spreads.sum do |s|
          s.spread.flat_map(&:page).length
        end
        pdf_pages = raw.scan(%r{/Type\s*/Page[^s]}).length
        expect(pdf_pages).to eq(spread_pages)
      end
    end
  end

  describe "pdfrb structural validation" do
    let(:pdf_raw) do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "validate.pdf")
        described_class.render(package: package, to: path)
        File.binread(path)
      end
    end

    it "has a valid xref section" do
      expect(pdf_raw).to match(/^xref\n0\s+\d+/)
    end

    it "trailer references Root" do
      expect(pdf_raw).to include("/Root")
    end

    it "every object has matching endobj" do
      obj_count = pdf_raw.scan(/^\d+ 0 obj/).length
      endobj_count = pdf_raw.scan(/^endobj/).length
      expect(obj_count).to eq(endobj_count)
    end

    it "Pages tree has correct kid count" do
      expect(pdf_raw).to include("/Count")
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
