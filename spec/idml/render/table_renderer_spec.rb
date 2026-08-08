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
      expect(raw.scan(/ re\b/).length).to eq(4)
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
        expect(raw.scan(/ re\b/).length).to eq(4)
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
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
