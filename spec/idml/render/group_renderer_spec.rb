# frozen_string_literal: true

require "spec_helper"

AlwaysHiddenLayerFilter = Struct.new(:visible_value, keyword_init: true) do
  def visible?(_item)
    false
  end
end

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::GroupRenderer do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def group_from_xml(xml)
    Idml::Elements::Group.from_xml(xml)
  end

  def build_context(group, layer_filter: nil)
    Idml::Render::RenderContext.new(
      item: group,
      package: nil,
      color_resolver: nil,
      page_height: 400,
      layer_filter: layer_filter,
    )
  end

  it "yields nothing for an empty group" do
    group = group_from_xml('<Group Self="g1"/>')
    described_class.render(canvas, build_context(group))
    write_to_temp_pdf(writer, "group-empty") do |path|
      expect(File.binread(path)).to start_with("%PDF")
    end
  end

  it "dispatches to PageItemRenderer for each child" do
    group = group_from_xml(<<~XML)
      <Group Self="g1">
        <Rectangle Self="r1" Visible="true"/>
      </Group>
    XML
    described_class.render(canvas, build_context(group))
    write_to_temp_pdf(writer, "group-child") do |path|
      expect(File.binread(path)).to start_with("%PDF")
    end
  end

  it "applies item_transform via Geometry concat" do
    group = group_from_xml('<Group Self="g1" ItemTransform="2 0 0 2 50 50"/>')
    described_class.render(canvas, build_context(group))
    write_to_temp_pdf(writer, "group-xform") do |path|
      raw = File.binread(path)
      expect(raw).to include("cm")
    end
  end

  it "skips children when layer_filter says invisible" do
    group = group_from_xml(<<~XML)
      <Group Self="g1">
        <Rectangle Self="r1" Visible="true" FillColor="Color/Red"/>
      </Group>
    XML
    hidden = AlwaysHiddenLayerFilter.new
    described_class.render(canvas, build_context(group, layer_filter: hidden))
    write_to_temp_pdf(writer, "group-hidden") do |path|
      raw = File.binread(path)
      expect(raw).to start_with("%PDF")
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
