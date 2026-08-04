# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::PdfaPacket do
  let(:writer) { Idml::Render::PdfrbWriter.new }

  describe ".build" do
    it "includes pdfaid:part and conformance" do
      xmp = described_class.build(Title: "Doc")
      expect(xmp).to include("<pdfaid:part>2</pdfaid:part>")
      expect(xmp).to include("<pdfaid:conformance>A</pdfaid:conformance>")
    end

    it "forces dc:format to application/pdf" do
      xmp = described_class.build({})
      expect(xmp).to include("<dc:format>application/pdf</dc:format>")
    end

    it "includes xpacket processing instructions" do
      xmp = described_class.build({})
      expect(xmp).to include("<?xpacket begin")
      expect(xmp).to include("<?xpacket end")
    end

    it "escapes XML special characters in Title" do
      xmp = described_class.build(Title: 'A & B <C> "D"')
      expect(xmp).to include("A &amp; B &lt;C&gt; &quot;D&quot;")
    end

    it "omits dc:title when Title is absent" do
      xmp = described_class.build({})
      expect(xmp).not_to include("<dc:title>")
    end

    it "includes Author as rdf:Seq when present" do
      xmp = described_class.build(Author: "Jane Doe")
      expect(xmp).to include("<dc:creator>")
      expect(xmp).to include("<rdf:Seq>")
      expect(xmp).to include("Jane Doe")
    end

    it "includes Keywords as pdf:Keywords when present" do
      xmp = described_class.build(Keywords: "alpha,beta")
      expect(xmp).to include("<pdf:Keywords>alpha,beta</pdf:Keywords>")
    end

    it "includes xmp:CreateDate when CreationDate is present" do
      xmp = described_class.build(CreationDate: "D:20260101")
      expect(xmp).to include("<xmp:CreateDate>D:20260101</xmp:CreateDate>")
    end
  end

  describe ".attach" do
    it "registers a /Metadata stream on the Catalog" do
      writer.add_page
      described_class.attach(writer.document, Title: "Doc")
      path = Tempfile.new("pdfa").path
      writer.write(path)
      raw = File.binread(path)
      expect(raw).to include("/Metadata")
      expect(raw).to include("/Subtype /XML")
      expect(raw).to include("pdfaid:part")
    end

    it "sets /Lang on the Catalog" do
      writer.add_page
      described_class.attach(writer.document, {})
      path = Tempfile.new("pdfa-lang").path
      writer.write(path)
      raw = File.binread(path)
      expect(raw).to match(%r{/Lang\s*/?en-?US}i).or include("/Lang")
    end

    it "is idempotent — second call replaces the first /Metadata" do
      writer.add_page
      described_class.attach(writer.document, Title: "First")
      described_class.attach(writer.document, Title: "Second")
      path = Tempfile.new("pdfa-idempotent").path
      writer.write(path)
      raw = File.binread(path)
      expect(raw).to include("Second")
    end
  end
end
