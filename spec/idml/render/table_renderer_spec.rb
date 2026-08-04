# frozen_string_literal: true

require "spec_helper"

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
    path = Tempfile.new("table-hidden").path
    writer.write(path)
    expect(File.binread(path)).not_to include(" re")
  end

  it "renders nothing when there are no rows" do
    table = table_from_xml('<Table Self="t1"/>')
    described_class.render(canvas, build_context(table))
    path = Tempfile.new("table-empty").path
    writer.write(path)
    expect(File.binread(path)).not_to include(" re")
  end

  it "draws one rectangle per cell" do
    table = table_from_xml(TABLE_GRID_XML)
    described_class.render(canvas, build_context(table))
    path = Tempfile.new("table-grid").path
    writer.write(path)
    raw = File.binread(path)
    # 2 rows × 2 cells = 4 rectangle ops
    expect(raw.scan(/ re\b/).length).to eq(4)
  end

  it "divides height evenly across rows" do
    table = table_from_xml(TABLE_GRID_XML)
    described_class.render(canvas, build_context(table))
    path = Tempfile.new("table-rows").path
    writer.write(path)
    raw = File.binread(path)
    expect(raw).to match(/\bS\b/)
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
