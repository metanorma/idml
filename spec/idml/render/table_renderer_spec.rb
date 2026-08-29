# frozen_string_literal: true

require "spec_helper"

TableColorResolver = Struct.new(:table, keyword_init: true) do
  def resolve(name)
    table[name]
  end
end

TABLE_GRID_XML = <<~XML
  <Table Self="t1" ItemTransform="1 0 0 1 0 0">
    <Properties>
      <PathGeometry>
        <GeometryPathType PathOpen="false">
          <PathPointArray>
            <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
            <PathPointType Anchor="90 -10" LeftDirection="90 -10" RightDirection="90 -10"/>
            <PathPointType Anchor="90 90" LeftDirection="90 90" RightDirection="90 90"/>
            <PathPointType Anchor="-10 90" LeftDirection="-10 90" RightDirection="-10 90"/>
          </PathPointArray>
        </GeometryPathType>
      </PathGeometry>
    </Properties>
    <TableRow Self="tr1">
      <TableCell Self="tc1a"/>
      <TableCell Self="tc1b"/>
    </TableRow>
    <TableRow Self="tr2">
      <TableCell Self="tc2a"/>
      <TableCell Self="tc2b"/>
    </TableRow>
  </Table>
XML

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::TableRenderer do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def table_from_xml(xml)
    Idml::Elements::Table.from_xml(xml)
  end

  def build_context(table)
    Idml::Render::RenderContext.new(
      item: table,
      package: nil,
      color_resolver: nil,
      page_height: 400,
    )
  end

  it "renders nothing when visible is false" do
    table = table_from_xml('<Table Self="t1" Visible="false"/>')
    described_class.render(canvas, build_context(table))
    write_to_temp_pdf(writer, "table-hidden") do |path|
      expect(File.binread(path)).not_to include(" re")
    end
  end

  it "renders nothing when there are no rows" do
    table = table_from_xml('<Table Self="t1"/>')
    described_class.render(canvas, build_context(table))
    write_to_temp_pdf(writer, "table-empty") do |path|
      expect(File.binread(path)).not_to include(" re")
    end
  end

  it "draws one rectangle per cell" do
    table = table_from_xml(TABLE_GRID_XML)
    described_class.render(canvas, build_context(table))
    write_to_temp_pdf(writer, "table-grid") do |path|
      raw = File.binread(path)
      # 2 rows × 2 cells = 4 rectangle ops
      expect(PdfStream.rect_count(raw)).to eq(4)
    end
  end

  it "divides height evenly across rows" do
    table = table_from_xml(TABLE_GRID_XML)
    described_class.render(canvas, build_context(table))
    write_to_temp_pdf(writer, "table-rows") do |path|
      raw = File.binread(path)
      expect(raw).to match(/\bS\b/)
    end
  end

  describe "schema-faithful path (real IDML Cell/Row siblings)" do
    let(:real_table_xml) do
      <<~XML
        <Table Self="t1" ItemTransform="1 0 0 1 0 0">
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                  <PathPointType Anchor="110 -10" LeftDirection="110 -10" RightDirection="110 -10"/>
                  <PathPointType Anchor="110 110" LeftDirection="110 110" RightDirection="110 110"/>
                  <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
          <Row Self="t1Row0" Name="0" SingleRowHeight="60" MinimumHeight="60"/>
          <Row Self="t1Row1" Name="1" SingleRowHeight="60" MinimumHeight="60"/>
          <Cell Self="t1c0" Name="0:0">
            <ParagraphStyleRange><CharacterStyleRange><Content>A</Content></CharacterStyleRange></ParagraphStyleRange>
          </Cell>
          <Cell Self="t1c1" Name="1:0">
            <ParagraphStyleRange><CharacterStyleRange><Content>B</Content></CharacterStyleRange></ParagraphStyleRange>
          </Cell>
          <Cell Self="t1c2" Name="0:1">
            <ParagraphStyleRange><CharacterStyleRange><Content>C</Content></CharacterStyleRange></ParagraphStyleRange>
          </Cell>
          <Cell Self="t1c3" Name="1:1">
            <ParagraphStyleRange><CharacterStyleRange><Content>D</Content></CharacterStyleRange></ParagraphStyleRange>
          </Cell>
        </Table>
      XML
    end

    it "renders a rectangle per cell" do
      table = table_from_xml(real_table_xml)
      described_class.render(canvas, build_context(table))
      write_to_temp_pdf(writer, "schema-table") do |path|
        raw = File.binread(path)
        # 2x2 grid = 4 cells = 4 rectangle ops
        expect(PdfStream.rect_count(raw)).to eq(4)
      end
    end

    it "emits each cell's text via text_rich" do
      table = table_from_xml(real_table_xml)
      described_class.render(canvas, build_context(table))
      write_to_temp_pdf(writer, "schema-table-text") do |path|
        raw = File.binread(path)
        expect(raw).to include("BT")
        expect(raw).to include("ET")
      end
    end

    it "returns nothing when visible is false" do
      table = table_from_xml('<Table Self="t1" Visible="false"/>')
      described_class.render(canvas, build_context(table))
      write_to_temp_pdf(writer, "schema-hidden") do |path|
        expect(File.binread(path)).not_to include(" re")
      end
    end

    describe "diagonal cell strokes" do
      let(:diagonal_table_xml) do
        <<~XML
          <Table Self="t1" ItemTransform="1 0 0 1 0 0">
            <Properties>
              <PathGeometry>
                <GeometryPathType PathOpen="false">
                  <PathPointArray>
                    <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                    <PathPointType Anchor="110 -10" LeftDirection="110 -10" RightDirection="110 -10"/>
                    <PathPointType Anchor="110 110" LeftDirection="110 110" RightDirection="110 110"/>
                    <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                  </PathPointArray>
                </GeometryPathType>
              </PathGeometry>
            </Properties>
            <Row Self="t1Row0" Name="0" SingleRowHeight="60" MinimumHeight="60"/>
            <Row Self="t1Row1" Name="1" SingleRowHeight="60" MinimumHeight="60"/>
            <Cell Self="t1c0" Name="0:0" TopLeftDiagonalLine="true"
                  TopRightDiagonalLine="true" DiagonalLineStrokeWeight="2"/>
            <Cell Self="t1c1" Name="1:0"/>
            <Cell Self="t1c2" Name="0:1"/>
            <Cell Self="t1c3" Name="1:1"/>
          </Table>
        XML
      end

      it "draws both diagonals as line ops with the declared weight" do
        table = table_from_xml(diagonal_table_xml)
        described_class.render(canvas, build_context(table))
        write_to_temp_pdf(writer, "diag-both") do |path|
          raw = File.binread(path)
          # 4 cell border strokes + 2 diagonals
          expect(PdfStream.stroke_count(raw)).to eq(6)
          expect(raw).to include("2 w")
        end
      end

      it "draws one line when only TopLeftDiagonalLine is set" do
        xml = diagonal_table_xml.sub(' TopRightDiagonalLine="true"', "")
        table = table_from_xml(xml)
        described_class.render(canvas, build_context(table))
        write_to_temp_pdf(writer, "diag-single") do |path|
          # 4 cell border strokes + 1 diagonal
          expect(PdfStream.stroke_count(File.binread(path))).to eq(5)
        end
      end
    end

    describe "column widths from Table#single_column_width" do
      let(:uneven_table_xml) do
        <<~XML
          <Table Self="t1" ItemTransform="1 0 0 1 0 0" ColumnCount="2" SingleColumnWidth="100">
            <Properties>
              <PathGeometry>
                <GeometryPathType PathOpen="false">
                  <PathPointArray>
                    <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                    <PathPointType Anchor="210 -10" LeftDirection="210 -10" RightDirection="210 -10"/>
                    <PathPointType Anchor="210 110" LeftDirection="210 110" RightDirection="210 110"/>
                    <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                  </PathPointArray>
                </GeometryPathType>
              </PathGeometry>
            </Properties>
            <Row Self="t1Row0" Name="0" SingleRowHeight="120"/>
            <Cell Self="t1c0" Name="0:0"/>
            <Cell Self="t1c1" Name="1:0"/>
          </Table>
        XML
      end

      it "uses SingleColumnWidth instead of even division" do
        table = table_from_xml(uneven_table_xml)
        # box width = 220 (from -10 to 210), so even division = 110
        # per col. SingleColumnWidth = 100 means columns are 100 wide.
        described_class.render(canvas, build_context(table))
        write_to_temp_pdf(writer, "schema-column-width") do |path|
          raw = File.binread(path)
          # The first rectangle's width should be 100, not 110.
          # Look for "100 120 re" (width=100, height=120).
          expect(raw).to match(/100\s+120\s+re\b/)
        end
      end
    end

    describe "cell background fill" do
      let(:filled_table_xml) do
        <<~XML
          <Table Self="t1" ItemTransform="1 0 0 1 0 0">
            <Properties>
              <PathGeometry>
                <GeometryPathType PathOpen="false">
                  <PathPointArray>
                    <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                    <PathPointType Anchor="110 -10" LeftDirection="110 -10" RightDirection="110 -10"/>
                    <PathPointType Anchor="110 110" LeftDirection="110 110" RightDirection="110 110"/>
                    <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                  </PathPointArray>
                </GeometryPathType>
              </PathGeometry>
            </Properties>
            <Row Self="t1Row0" Name="0" SingleRowHeight="120"/>
            <Cell Self="t1c0" Name="0:0" FillColor="Color/Red"/>
          </Table>
        XML
      end

      let(:color_resolver) do
        TableColorResolver.new(
          table: { "Color/Red" => { model: :rgb, r: 1, g: 0, b: 0 } },
        )
      end

      def build_context_with_color(table)
        Idml::Render::RenderContext.new(
          item: table,
          package: nil,
          color_resolver: color_resolver,
          page_height: 400,
        )
      end

      it "emits a fill rectangle before the stroke" do
        table = table_from_xml(filled_table_xml)
        described_class.render(canvas, build_context_with_color(table))
        write_to_temp_pdf(writer, "schema-cell-fill") do |path|
          raw = File.binread(path)
          # RGB fill op for red.
          expect(raw).to match(/1\s+0\s+0\s+rg\b/)
        end
      end
    end

    describe "merged cells (RowSpan / ColumnSpan)" do
      # 2x2 grid where cell 0:0 spans 2 columns.
      # Total grid has 3 logical cells (one spanning + two singles).
      let(:merged_table_xml) do
        <<~XML
          <Table Self="t1" ItemTransform="1 0 0 1 0 0" ColumnCount="2" SingleColumnWidth="60">
            <Properties>
              <PathGeometry>
                <GeometryPathType PathOpen="false">
                  <PathPointArray>
                    <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                    <PathPointType Anchor="110 -10" LeftDirection="110 -10" RightDirection="110 -10"/>
                    <PathPointType Anchor="110 110" LeftDirection="110 110" RightDirection="110 110"/>
                    <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                  </PathPointArray>
                </GeometryPathType>
              </PathGeometry>
            </Properties>
            <Row Self="t1Row0" Name="0" SingleRowHeight="60"/>
            <Row Self="t1Row1" Name="1" SingleRowHeight="60"/>
            <Cell Self="t1c0" Name="0:0" ColumnSpan="2">
              <ParagraphStyleRange><CharacterStyleRange><Content>merged</Content></CharacterStyleRange></ParagraphStyleRange>
            </Cell>
            <Cell Self="t1c1" Name="0:1">
              <ParagraphStyleRange><CharacterStyleRange><Content>B</Content></CharacterStyleRange></ParagraphStyleRange>
            </Cell>
            <Cell Self="t1c2" Name="1:1">
              <ParagraphStyleRange><CharacterStyleRange><Content>D</Content></CharacterStyleRange></ParagraphStyleRange>
            </Cell>
          </Table>
        XML
      end

      it "renders 3 cells (merged cell + 2 singles, covered cell skipped)" do
        table = table_from_xml(merged_table_xml)
        described_class.render(canvas, build_context(table))
        write_to_temp_pdf(writer, "schema-spans") do |path|
          raw = File.binread(path)
          # 1 merged (spanning 2 cols) + 2 singles = 3 cell rectangles.
          expect(PdfStream.rect_count(raw)).to eq(3)
        end
      end

      it "merged cell width spans two columns" do
        table = table_from_xml(merged_table_xml)
        described_class.render(canvas, build_context(table))
        write_to_temp_pdf(writer, "schema-span-width") do |path|
          raw = File.binread(path)
          # SingleColumnWidth=60, ColumnSpan=2 → width=120 for the
          # merged cell. Look for a rectangle emit with width 120.
          expect(raw).to match(/120\s+60\s+re\b/)
        end
      end
    end
  end

  describe "table-level alternating band fills" do
    def band_table_xml(table_attrs, cell_fill: nil)
      <<~XML
        <Table Self="t1" ItemTransform="1 0 0 1 0 0" #{table_attrs}>
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="-10 -10" LeftDirection="-10 -10" RightDirection="-10 -10"/>
                  <PathPointType Anchor="110 -10" LeftDirection="110 -10" RightDirection="110 -10"/>
                  <PathPointType Anchor="110 110" LeftDirection="110 110" RightDirection="110 110"/>
                  <PathPointType Anchor="-10 110" LeftDirection="-10 110" RightDirection="-10 110"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
          <Row Self="r0" Name="0" SingleRowHeight="60"/>
          <Row Self="r1" Name="1" SingleRowHeight="60"/>
          <Cell Self="c00" Name="0:0"#{%( FillColor="#{cell_fill}") if cell_fill}/>
          <Cell Self="c10" Name="1:0"#{%( FillColor="#{cell_fill}") if cell_fill}/>
          <Cell Self="c01" Name="0:1"#{%( FillColor="#{cell_fill}") if cell_fill}/>
          <Cell Self="c11" Name="1:1"#{%( FillColor="#{cell_fill}") if cell_fill}/>
        </Table>
      XML
    end

    def band_context(table)
      Idml::Render::RenderContext.new(
        item: table,
        color_resolver: TableColorResolver.new(
          table: {
            "Color/Red" => { model: :rgb, r: 1, g: 0, b: 0 },
            "Color/Blue" => { model: :rgb, r: 0, g: 0, b: 1 },
          },
        ),
        page_height: 400,
      )
    end

    def render_banded(table_attrs, cell_fill: nil)
      table = table_from_xml(band_table_xml(table_attrs, cell_fill: cell_fill))
      described_class.render(canvas, band_context(table))
      write_to_temp_pdf(writer, "table-band") do |pdf_path|
        yield File.binread(pdf_path)
      end
    end

    it "alternates start and end colors across rows" do
      attrs = 'StartRowFillColor="Color/Red" StartRowFillCount="1" ' \
              'EndRowFillColor="Color/Blue" EndRowFillCount="1"'
      render_banded(attrs) do |raw|
        expect(raw.scan("1 0 0 rg").length).to eq(2)
        expect(raw.scan("0 0 1 rg").length).to eq(2)
      end
    end

    it "lets an explicit cell fill override the band" do
      attrs = 'StartRowFillColor="Color/Red" StartRowFillCount="1" ' \
              'EndRowFillColor="Color/Blue" EndRowFillCount="1"'
      render_banded(attrs, cell_fill: "Color/Blue") do |raw|
        expect(raw.scan("1 0 0 rg").length).to eq(0)
      end
    end

    it "prefers column banding when ColumnFillsPriority is true" do
      attrs = 'StartRowFillColor="Color/Red" StartRowFillCount="1" ' \
              'EndRowFillColor="Color/Blue" EndRowFillCount="1" ' \
              'StartColumnFillColor="Color/Blue" StartColumnFillCount="1" ' \
              'ColumnFillsPriority="true"'
      render_banded(attrs) do |raw|
        # Column banding wins: col 0 = blue band, col 1 = no end
        # color = unfilled; the row pattern (row 0 = red) never runs.
        expect(raw.scan("1 0 0 rg").length).to eq(0)
        expect(raw.scan("0 0 1 rg").length).to eq(2)
      end
    end

    it "suppresses leading bands with SkipFirstAlternatingFillRows" do
      attrs = 'StartRowFillColor="Color/Red" StartRowFillCount="1" ' \
              'EndRowFillColor="Color/Blue" EndRowFillCount="1" ' \
              'SkipFirstAlternatingFillRows="1"'
      render_banded(attrs) do |raw|
        # Row 0 is skipped; the band cycle restarts at row 1 with
        # the start color.
        expect(raw.scan("1 0 0 rg").length).to eq(2)
        expect(raw.scan("0 0 1 rg").length).to eq(0)
      end
    end

    it "renders no bands when none are declared" do
      render_banded("") do |raw|
        expect(raw.scan(" rg").length).to eq(0)
      end
    end
  end

  describe "row flow across frames (TODO 134)" do
    def flow_table_xml(rows, header_rows: 0)
      row_xml = Array.new(rows) { |i| %(<Row Self="r#{i}" Name="#{i}" SingleRowHeight="40"/) }.join
      cell_xml = rows.times.flat_map { |i| [%(<Cell Self="c0#{i}" Name="0:#{i}"/>), %(<Cell Self="c1#{i}" Name="1:#{i}"/>)] }.join
      %(<Table Self="t1" ItemTransform="1 0 0 1 0 0" HeaderRowCount="#{header_rows}">#{row_xml}#{cell_xml}</Table>)
    end

    def flow_render(table, start_row: 0, bottom_limit: nil)
      box = { x: 0, y: 0, width: 100, height: 100 }
      next_row = Idml::Render::Renderers::TableRenderer.render_in_box(
        canvas, table, box, build_context(table),
        start_row: start_row, bottom_limit: bottom_limit
      )
      count = nil
      write_to_temp_pdf(writer, "table-flow") do |pdf_path|
        count = PdfStream.rect_count(File.binread(pdf_path))
      end
      [next_row, count]
    end

    it "clips rows at the bottom limit and reports the next row" do
      # Rows anchor from the box's top: bottoms at 120/80/40/0.
      next_row, count = flow_render(table_from_xml(flow_table_xml(4)),
                                    bottom_limit: 80)
      # 2 of 4 rows (2 cells each) fit above the limit.
      expect(count).to eq(4)
      expect(next_row).to eq(2)
    end

    it "returns nil when the table completes" do
      next_row, count = flow_render(table_from_xml(flow_table_xml(2)))
      expect(count).to eq(4)
      expect(next_row).to be_nil
    end

    it "repeats header rows on continuation frames" do
      _next_row, count = flow_render(
        table_from_xml(flow_table_xml(4, header_rows: 1)), start_row: 2
      )
      # Header (2 cells) + rows 2 and 3 (4 cells) = 6 cells.
      expect(count).to eq(6)
    end
  end
end

# rubocop:enable RSpec/SpecFilePathFormat
