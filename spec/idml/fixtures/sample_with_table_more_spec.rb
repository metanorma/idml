# frozen_string_literal: true

require "spec_helper"

# rubocop:disable RSpec/DescribeClass
RSpec.describe "sample-with-table-more fixture" do
  let(:fixture_path) do
    File.expand_path(
      "../../fixtures/sample-with-table-more/sample-with-table-more.idml",
      __dir__,
    )
  end
  let(:package) { Idml::Package.new(fixture_path) }

  describe "package structure" do
    it "parses without error" do
      expect(package).to be_a(Idml::Package)
    end

    it "has 3 spreads" do
      expect(package.spreads.length).to eq(3)
    end

    it "has stories accessible via designmap" do
      expect(package.designmap.story_list).to be_a(String)
      expect(package.designmap.story_list.split(/\s+/).length).to be_positive
    end
  end

  describe "table discovery" do
    let(:table_story) { package.story_by_id("u1b7") }
    let(:tables) do
      tables = []
      table_story.inner.paragraph_style_range.each do |psr|
        psr.character_style_range.each do |csr|
          tables.concat(csr.table)
        end
      end
      tables
    end

    it "finds the Table inside the story's CSR" do
      expect(tables.length).to be_positive
    end

    describe "the parsed Table" do
      let(:table) { tables.first }

      it "has a Self attribute" do
        expect(table.self_attr).to eq("u1b7i1cc")
      end

      it "has 9 Row children" do
        expect(table.row.length).to eq(9)
      end

      it "has 83 Cell children" do
        expect(table.cell.length).to eq(83)
      end

      it "Row Self values match Table Self + Row<N>" do
        expect(table.row.first.self_attr).to eq("u1b7i1ccRow0")
      end

      it "Row Name is the row index" do
        expect(table.row.first.name).to eq("0")
      end
    end

    describe "the first Cell" do
      let(:cell) { tables.first.cell.first }

      it "has Name '0:0' (col:row encoding)" do
        expect(cell.name).to eq("0:0")
      end

      it "decodes Name to [col, row]" do
        expect(cell.col_row).to eq([0, 0])
      end

      it "has text_content from inline PSR > CSR > Content" do
        expect(cell.text_content).to eq("H1")
      end

      it "is a HeaderColumn" do
        expect(cell.column_type).to eq("HeaderColumn")
      end
    end

    describe "subsequent cells" do
      let(:cells) { tables.first.cell }

      it "increments Name col index within a row" do
        expect(cells[0].name).to eq("0:0")
        expect(cells[1].name).to eq("1:0")
        expect(cells[2].name).to eq("2:0")
      end

      it "carries the expected header text" do
        expect(cells[0].text_content).to eq("H1")
        expect(cells[1].text_content).to eq("H2")
      end
    end
  end

  describe "rendering" do
    it "produces a valid PDF" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "table.pdf")
        Idml::Render.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to start_with("%PDF")
        expect(raw.strip).to end_with("%%EOF")
      end
    end

    it "produces one PDF page per IDML page" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "pages.pdf")
        Idml::Render.render(package: package, to: path)
        raw = File.binread(path)

        spread_pages = package.spreads.sum do |s|
          s.spread.flat_map(&:page).length
        end
        pdf_pages = raw.scan(%r{/Type\s*/Page[^s]}).length
        expect(pdf_pages).to eq(spread_pages)
      end
    end

    it "emits text content (BT/ET) from stories" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "text.pdf")
        Idml::Render.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("BT")
        expect(raw).to include("ET")
      end
    end

    it "emits XMP metadata from the IDML packet" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "meta.pdf")
        Idml::Render.render(package: package, to: path)
        raw = File.binread(path)

        expect(raw).to include("/Producer")
        expect(raw).to include("/Creator")
      end
    end

    it "emits tagged PDF structure when tagged: true" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "tagged.pdf")
        Idml::Render.render(package: package, to: path, tagged: true)
        raw = File.binread(path)

        expect(raw).to include("/StructTreeRoot")
        expect(raw).to include("/StructElem")
      end
    end

    it "embeds PDF/A XMP when compliance: :pdfa2a" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "pdfa.pdf")
        Idml::Render.render(package: package, to: path, compliance: :pdfa2a)
        raw = File.binread(path)

        # Decompress ObjStm to find pdfaid:part — pdfrb packs objects
        # into compressed streams, so direct string search fails.
        require "zlib"
        decompressed = raw.scan(/stream\r?\n(.*?)\r?\nendstream/m).map do |s|
          Zlib.inflate(s[0])
        rescue StandardError
          s[0]
        end.join
        combined = raw + decompressed
        expect(combined).to include("pdfaid:part")
        expect(combined).to include("pdfaid:conformance")
      end
    end

    it "renders inline Table discovered via TextFrame > Story > CSR > Table" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "inline-table.pdf")
        Idml::Render.render(package: package, to: path)
        raw = File.binread(path)

        # The fixture has one Table with 83 cells. Each cell produces
        # one rectangle op. Total re ops should be at least 83.
        expect(raw.scan(/ re\b/).length).to be >= 83
      end
    end

    it "applies lossless FlateDecode compression when compress: true" do
      Dir.mktmpdir do |dir|
        plain_path = File.join(dir, "plain.pdf")
        compressed_path = File.join(dir, "compressed.pdf")
        Idml::Render.render(package: package, to: plain_path, compress: false)
        Idml::Render.render(package: package, to: compressed_path,
                            compress: true)
        plain = File.binread(plain_path)
        compressed = File.binread(compressed_path)

        # No data loss — both are valid PDFs.
        expect(compressed).to start_with("%PDF")
        expect(compressed.strip).to end_with("%%EOF")

        # Compression is lossless — content is preserved.
        expect(compressed.scan("FlateDecode").length)
          .to be > plain.scan("FlateDecode").length
        expect(File.size(compressed_path)).to be < File.size(plain_path)
      end
    end

    it "embeds fonts as Type1/CFF with subset prefix (not TrueType)" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "fonts.pdf")
        Idml::Render.render(package: package, to: path, compress: false)
        raw = File.binread(path)

        # pdfrb 0.6.0 fixes: fonts use 6-char subset prefix
        expect(raw).to match(/[A-Z]{6}\+/)
        # Font type is Type1 (CFF-based OTF), not TrueType
        expect(raw).to include("/Subtype /Type1")
        # FontFile3 (CFF), not FontFile2 (TrueType)
        expect(raw).to include("FontFile3")
        expect(raw).not_to include("FontFile2")
      end
    end

    it "emits clean Info dict without spurious /Type/Metadata" do
      Dir.mktmpdir do |dir|
        path = File.join(dir, "info.pdf")
        Idml::Render.render(package: package, to: path, compress: false)
        raw = File.binread(path)

        # pdfrb 0.6.0 fix: no /Type key on Info dict
        expect(raw).not_to include("/Type/Metadata")
      end
    end
  end
end
# rubocop:enable RSpec/DescribeClass
