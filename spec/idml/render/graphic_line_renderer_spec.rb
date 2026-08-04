# frozen_string_literal: true

require "spec_helper"

FakeLineItem = Struct.new(
  :stroke_color, :stroke_weight, :geometric_bounds, :item_transform,
  :end_cap, :end_join, :miter_limit, :stroke_dash_and_gap,
  :transparency_setting,
  keyword_init: true
)

FakeLineColorResolver = Struct.new(:table, keyword_init: true) do
  def resolve(name)
    table[name]
  end
end

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Renderers::GraphicLineRenderer do
  let(:writer) { Idml::Render::PdfrbWriter.new }
  let(:canvas) { writer.add_page(width: 400, height: 400) }

  def build_line(overrides = {})
    FakeLineItem.new({
      stroke_color: "Color/Black",
      stroke_weight: 1.5,
      geometric_bounds: [0, 0, 100, 100],
      item_transform: "1 0 0 1 0 0",
      end_cap: nil, end_join: nil, miter_limit: nil,
      stroke_dash_and_gap: nil, transparency_setting: nil
    }.merge(overrides))
  end

  def build_context(line)
    Idml::Render::RenderContext.new(
      item: line,
      color_resolver: FakeLineColorResolver.new(
        table: { "Color/Black" => { model: :rgb, r: 0, g: 0, b: 0 } },
      ),
      page_height: 400,
    )
  end

  it "renders nothing when stroke is not strokeable" do
    line = build_line(stroke_color: nil)
    described_class.render(canvas, build_context(line))
    path = Tempfile.new("line-empty").path
    writer.write(path)
    expect(File.binread(path)).not_to include(" m")
  end

  it "renders nothing when color cannot be resolved" do
    line = build_line(stroke_color: "Color/Missing")
    described_class.render(canvas, build_context(line))
    path = Tempfile.new("line-missing-color").path
    writer.write(path)
    expect(File.binread(path)).not_to include(" m")
  end

  it "draws a line using move_to/line_to/stroke" do
    line = build_line
    described_class.render(canvas, build_context(line))
    path = Tempfile.new("line-basic").path
    writer.write(path)
    raw = File.binread(path)
    expect(raw).to include(" m").or include("\nm\n")
    expect(raw).to include(" l").or include("\nl\n")
  end

  it "applies StrokeStyle within save/restore" do
    line = build_line(end_cap: "RoundEndCap", stroke_dash_and_gap: "3 2")
    described_class.render(canvas, build_context(line))
    path = Tempfile.new("line-styled").path
    writer.write(path)
    raw = File.binread(path)
    expect(raw).to match(/1 J\b/)
    expect(raw).to match(/\[3.*2.*\].*0 d\b/)
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
