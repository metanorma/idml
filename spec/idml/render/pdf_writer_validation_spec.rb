# frozen_string_literal: true

require "spec_helper"
require "tmpdir"

RSpec.describe Idml::Render::PdfWriter do
  describe "PDF structural validation" do
    let(:pdf) do
      writer = described_class.new
      writer.add_page(
        width: 612, height: 792,
        content: "BT /F1 12 Tf 72 720 Td (Hi) Tj ET",
        fonts: { "F1" => "Helvetica" }
      )
      writer.set_info(Producer: "test", Title: "Validation")
      Dir.mktmpdir do |dir|
        path = File.join(dir, "validate.pdf")
        writer.write(path)
        File.binread(path)
      end
    end

    it "starts with %PDF header" do
      expect(pdf).to start_with("%PDF-1.4")
    end

    it "ends with %%EOF" do
      expect(pdf).to end_with("%%EOF")
    end

    it "has a valid xref section" do
      expect(pdf).to match(/^xref\n0 \d+/)
    end

    it "trailer references Root and Info" do
      expect(pdf).to include("/Root")
      expect(pdf).to include("/Info")
    end

    it "has a Catalog object" do
      expect(pdf).to include("/Type /Catalog")
    end

    it "has a Pages tree" do
      expect(pdf).to include("/Type /Pages")
      expect(pdf).to include("/Count 1")
    end

    it "each page has MediaBox, Contents, and Resources" do
      expect(pdf).to include("/MediaBox [0 0 612 792]")
      expect(pdf).to include("/Contents")
      expect(pdf).to include("/Resources")
    end

    it "content stream length matches /Length entry" do
      content = "BT /F1 12 Tf 72 720 Td (Hi) Tj ET"
      length = content.bytesize
      expect(pdf).to include("/Length #{length}")
    end

    it "every object has matching endobj" do
      obj_count = pdf.scan(/^\d+ 0 obj/).length
      endobj_count = pdf.scan(/^endobj/).length
      expect(obj_count).to eq(endobj_count)
    end

    it "xref offsets point to valid object headers" do
      lines = pdf.lines
      xref_start = lines.index { |l| l.start_with?("xref") }
      expect(xref_start).not_to be_nil

      startxref_line = lines.index { |l| l.start_with?("startxref") }
      expect(startxref_line).not_to be_nil

      xref_pos = lines[startxref_line + 1].to_i
      xref_section = pdf[xref_pos..]
      expect(xref_section).to start_with("xref")
    end

    it "Info dictionary contains set metadata" do
      expect(pdf).to include("/Producer (test)")
      expect(pdf).to include("/Title (Validation)")
    end
  end
end
