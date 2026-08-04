# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Parts::XmpMeta do
  let(:fixture_path) do
    File.expand_path("../../fixtures/sample-with-image/sample-with-image.idml",
                     __dir__)
  end
  let(:package) { Idml::Package.new(fixture_path) }
  let(:xmp_xml) { package.read_part("META-INF/metadata.xml") }

  describe ".from_xml" do
    it "parses the XMP packet" do
      meta = described_class.from_xml(xmp_xml)
      expect(meta.rdf).to be_a(Idml::Parts::XmpRdf)
    end

    it "extracts xmp:CreatorTool" do
      meta = described_class.from_xml(xmp_xml)
      expect(meta.rdf.creator_tool)
        .to eq("Adobe InDesign 21.5 (Macintosh)")
    end

    it "extracts xmp:CreateDate" do
      meta = described_class.from_xml(xmp_xml)
      expect(meta.rdf.create_date).to start_with("2026-08-01")
    end

    it "extracts xmp:ModifyDate" do
      meta = described_class.from_xml(xmp_xml)
      expect(meta.rdf.modify_date).to start_with("2026-08-01")
    end

    it "extracts dc:format" do
      meta = described_class.from_xml(xmp_xml)
      expect(meta.description.format.value)
        .to eq("application/x-indesign")
    end
  end

  describe "container elements (dc:title, dc:creator, dc:subject)" do
    let(:rich_xml) do
      <<~XML
        <?xpacket begin="" id="W5M0MpCehiHzreSzNTczkc9d"?>
        <x:xmpmeta xmlns:x="adobe:ns:meta/">
          <rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">
            <rdf:Description
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:xmp="http://ns.adobe.com/xap/1.0/">
              <dc:title>
                <rdf:Alt>
                  <rdf:li xml:lang="x-default">Annual Report 2026</rdf:li>
                  <rdf:li xml:lang="en">Annual Report 2026</rdf:li>
                  <rdf:li xml:lang="fr">Rapport Annuel 2026</rdf:li>
                </rdf:Alt>
              </dc:title>
              <dc:creator>
                <rdf:Seq>
                  <rdf:li>Jane Doe</rdf:li>
                  <rdf:li>John Smith</rdf:li>
                </rdf:Seq>
              </dc:creator>
              <dc:description>
                <rdf:Alt>
                  <rdf:li xml:lang="x-default">Quarterly financial report</rdf:li>
                </rdf:Alt>
              </dc:description>
              <dc:subject>
                <rdf:Bag>
                  <rdf:li>finance</rdf:li>
                  <rdf:li>2026</rdf:li>
                  <rdf:li>Q4</rdf:li>
                </rdf:Bag>
              </dc:subject>
              <xmp:CreatorTool>Adobe InDesign 21.5</xmp:CreatorTool>
              <xmp:CreateDate>2026-08-01T15:38:29+08:00</xmp:CreateDate>
            </rdf:Description>
          </rdf:RDF>
        </x:xmpmeta>
        <?xpacket end="w"?>
      XML
    end

    it "extracts dc:title x-default value" do
      meta = described_class.from_xml(rich_xml)
      expect(meta.rdf.title).to eq("Annual Report 2026")
    end

    it "extracts first dc:creator" do
      meta = described_class.from_xml(rich_xml)
      expect(meta.rdf.author).to eq("Jane Doe")
    end

    it "extracts dc:description x-default" do
      meta = described_class.from_xml(rich_xml)
      expect(meta.rdf.description).to eq("Quarterly financial report")
    end

    it "joins dc:subject into keywords" do
      meta = described_class.from_xml(rich_xml)
      expect(meta.rdf.keywords).to eq("finance, 2026, Q4")
    end

    it "extracts xmp:CreatorTool" do
      meta = described_class.from_xml(rich_xml)
      expect(meta.rdf.creator_tool).to eq("Adobe InDesign 21.5")
    end
  end

  describe "missing fields" do
    let(:empty_xml) do
      '<x:xmpmeta xmlns:x="adobe:ns:meta/">' \
        '<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#">' \
        "<rdf:Description/></rdf:RDF>" \
        "</x:xmpmeta>"
    end

    it "returns nil for absent fields without raising" do
      meta = described_class.from_xml(empty_xml)
      expect(meta.rdf.title).to be_nil
      expect(meta.rdf.author).to be_nil
      expect(meta.rdf.keywords).to be_nil
    end
  end
end
