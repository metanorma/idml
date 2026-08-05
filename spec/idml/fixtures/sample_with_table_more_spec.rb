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
  end
end
# rubocop:enable RSpec/DescribeClass
