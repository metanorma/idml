# frozen_string_literal: true

require "spec_helper"

# The schema source of truth, read at spec time so the model's
# attribute set cannot drift from the RNC silently: a Table built
# with EVERY schema attribute set must round-trip every attribute.
TABLE_RNC_PATH = File.expand_path(
  "../../../reference-docs/schemas/package/Stories/Story.rnc", __dir__
)

RSpec.describe Idml::Elements::Table do
  def schema_attributes
    source = File.read(TABLE_RNC_PATH)
    table_def = source[/^Table_Object = element Table \{.*?^\}$/m]
    table_def.scan(/attribute (\w+) \{/).flatten
  end

  it "round-trips every Table_Object attribute from the RNC" do
    skip "RNC schema not present" unless File.exist?(TABLE_RNC_PATH)

    all_attrs = schema_attributes
    xml_attrs = all_attrs.map { |a| %(#{a}="1") }.join(" ")
    table = described_class.from_xml("<Table #{xml_attrs}/>")
    reserialized = described_class.to_xml(table)

    missing = all_attrs.reject { |a| reserialized.include?(%(#{a}=")) }
    expect(missing).to be_empty,
                       "attributes dropped by the model: #{missing.inspect}"
  end

  it "parses and round-trips a late-declared schema attribute" do
    table = described_class.from_xml(<<~XML)
      <Table Self="t1" BottomInset="6" StartRowStrokeWeight="0.5"
             StartRow="1"/>
    XML
    expect(table.bottom_inset).to eq(6.0)
    expect(table.start_row_stroke_weight).to eq(0.5)
    expect(table.start_row).to eq("1")

    reserialized = described_class.to_xml(table)
    expect(reserialized).to include('BottomInset="6.0"')
    expect(reserialized).to include('StartRowStrokeWeight="0.5"')
  end

  it "keeps parsing the rendering-relevant subset" do
    table = described_class.from_xml(<<~XML)
      <Table Self="t1" HeaderRowCount="1" ColumnCount="2" ColumnFillsPriority="columns"/>
    XML
    expect(table.header_row_count).to eq(1)
    expect(table.column_count).to eq(2)
    expect(table.column_fills_priority).to eq("columns")
  end
end
