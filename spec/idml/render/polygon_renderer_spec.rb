# frozen_string_literal: true

require "spec_helper"

FakeShape = Struct.new(
  :visible, :fill_color, :geometric_bounds, :item_transform,
  :stroke_color, :stroke_weight, :end_cap, :end_join,
  :miter_limit, :stroke_dash_and_gap, :transparency_setting,
  :properties,
  keyword_init: true
)

FakeShapePackage = Struct.new(:graphic, keyword_init: true)
FakeShapeGraphic = Struct.new(:gradient, keyword_init: true)
FakeShapeColorResolver = Struct.new(:table, keyword_init: true) do
  def resolve(name)
    table[name]
  end
end

# rubocop:disable-next RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::PolygonRenderer do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def build_poly(overrides = {})
    FakeShape.new({
      visible: true,
      fill_color: "Color/Red",
      geometric_bounds: [0, 0, 100, 100],
      item_transform: "1 0 0 1 0 0",
      stroke_color: nil,
      stroke_weight: nil,
      transparency_setting: nil,
      properties: [],
    }.merge(overrides))
  end

  def build_context(poly)
    Idml::Render::RenderContext.new(
      item: poly,
      package: FakeShapePackage.new(graphic: FakeShapeGraphic.new(gradient: [])),
      color_resolver: FakeShapeColorResolver.new(
        table: {
          "Color/Red" => { model: :rgb, r: 1, g: 0, b: 0 },
          "Color/Blue" => { model: :rgb, r: 0, g: 0, b: 1 },
        },
      ),
      page_height: 400,
    )
  end

  it "renders nothing when visible is false" do
    poly = build_poly(visible: false)
    described_class.render(canvas, build_context(poly))
    write_to_temp_pdf(writer, "poly-invisible") do |path|
      expect(File.binread(path)).not_to include(" re")
    end
  end

  it "renders nothing when geometric_bounds is nil" do
    poly = build_poly(geometric_bounds: nil)
    described_class.render(canvas, build_context(poly))
    write_to_temp_pdf(writer, "poly-nobounds") do |path|
      expect(File.binread(path)).not_to include(" re")
    end
  end

  it "renders a fill rectangle when fill_color resolves" do
    poly = build_poly(fill_color: "Color/Red")
    described_class.render(canvas, build_context(poly))
    write_to_temp_pdf(writer, "poly-fill") do |path|
      expect(File.binread(path)).to include(" re")
    end
  end

  it "renders a stroke when stroke_color and weight are set" do
    poly = build_poly(
      fill_color: nil,
      stroke_color: "Color/Blue",
      stroke_weight: 2.0,
      end_cap: "RoundEndCap",
    )
    described_class.render(canvas, build_context(poly))
    write_to_temp_pdf(writer, "poly-stroke") do |path|
      raw = File.binread(path)
      expect(raw).to include(" re")
      expect(raw).to match(/(\b| )S\b/)
    end
  end
end
