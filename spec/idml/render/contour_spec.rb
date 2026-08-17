# frozen_string_literal: true

require "spec_helper"

# Records path-construction calls without a PDF backend, so the
# Bézier math can be asserted exactly.
ContourRecordingCanvas = Struct.new(:ops, keyword_init: true) do
  def move_to(*coords)
    ops << [:move_to, *coords]
  end

  def curve_to(*coords)
    ops << [:curve_to, *coords]
  end

  def close_path
    ops << [:close_path]
  end
end

# rubocop:disable RSpec/SpecFilePathFormat
RSpec.describe Idml::Render::Contour do
  def geometry(points:, path_open: "false")
    points_xml = points.map do |anchor, left, right|
      %(<PathPointType Anchor="#{anchor}" LeftDirection="#{left}" RightDirection="#{right}"/>)
    end.join
    Idml::Elements::PathGeometry.from_xml(<<~XML)
      <PathGeometry>
        <GeometryPathType PathOpen="#{path_open}">
          <PathPointArray>#{points_xml}</PathPointArray>
        </GeometryPathType>
      </PathGeometry>
    XML
  end

  def straight(points)
    points.map { |a| [a, a, a] }
  end

  describe ".draw_path" do
    it "moves to the first anchor and curves through the rest" do
      geom = geometry(points: straight(["0 0", "0 100", "100 100", "100 0"]))
      canvas = ContourRecordingCanvas.new(ops: [])
      paths = geom.geometry_path_type

      described_class.draw_path(canvas, paths, nil, 400)

      expect(canvas.ops.first).to eq([:move_to, 0.0, 400.0])
      expect(canvas.ops.count { |op| op[0] == :curve_to }).to eq(4)
      expect(canvas.ops.last).to eq([:close_path])
    end

    it "uses LeftDirection / RightDirection as segment controls" do
      geom = geometry(points: [
                        ["0 0", "0 0", "10 10"],
                        ["0 100", "20 20", "0 100"],
                      ])
      canvas = ContourRecordingCanvas.new(ops: [])

      described_class.draw_path(canvas, geom.geometry_path_type, nil, 400)

      curve = canvas.ops.find { |op| op[0] == :curve_to }
      expect(curve[1, 2]).to eq([10.0, 390.0])   # right handle of point 1
      expect(curve[3, 2]).to eq([20.0, 380.0])   # left handle of point 2
      expect(curve[5, 2]).to eq([0.0, 300.0])    # anchor of point 2
    end

    it "applies the item transform and y-flips every coordinate" do
      geom = geometry(points: straight(["0 0", "0 100"]))
      canvas = ContourRecordingCanvas.new(ops: [])

      described_class.draw_path(canvas, geom.geometry_path_type,
                                "1 0 0 1 50 25", 400)

      expect(canvas.ops.first).to eq([:move_to, 50.0, 375.0])
    end

    it "does not close an open path and draws one fewer segment" do
      geom = geometry(path_open: "true",
                      points: straight(["0 0", "0 100", "100 100"]))
      canvas = ContourRecordingCanvas.new(ops: [])

      described_class.draw_path(canvas, geom.geometry_path_type, nil, 400)

      expect(canvas.ops.count { |op| op[0] == :curve_to }).to eq(2)
      expect(canvas.ops).not_to include([:close_path])
    end

    it "draws one subpath per GeometryPathType" do
      two_paths = Idml::Elements::PathGeometry.from_xml(<<~XML)
        <PathGeometry>
          <GeometryPathType PathOpen="false">
            <PathPointArray>
              <PathPointType Anchor="0 0" LeftDirection="0 0" RightDirection="0 0"/>
              <PathPointType Anchor="0 10" LeftDirection="0 10" RightDirection="0 10"/>
            </PathPointArray>
          </GeometryPathType>
          <GeometryPathType PathOpen="false">
            <PathPointArray>
              <PathPointType Anchor="50 0" LeftDirection="50 0" RightDirection="50 0"/>
              <PathPointType Anchor="50 10" LeftDirection="50 10" RightDirection="50 10"/>
            </PathPointArray>
          </GeometryPathType>
        </PathGeometry>
      XML
      canvas = ContourRecordingCanvas.new(ops: [])

      described_class.draw_path(canvas, two_paths.geometry_path_type,
                                nil, 400)

      expect(canvas.ops.count { |op| op[0] == :move_to }).to eq(2)
      expect(canvas.ops.count { |op| op[0] == :close_path }).to eq(2)
    end

    it "skips degenerate subpaths with fewer than two points" do
      geom = Idml::Elements::PathGeometry.from_xml(<<~XML)
        <PathGeometry>
          <GeometryPathType PathOpen="false">
            <PathPointArray>
              <PathPointType Anchor="0 0" LeftDirection="0 0" RightDirection="0 0"/>
            </PathPointArray>
          </GeometryPathType>
        </PathGeometry>
      XML
      canvas = ContourRecordingCanvas.new(ops: [])

      described_class.draw_path(canvas, geom.geometry_path_type, nil, 400)

      expect(canvas.ops).to be_empty
    end
  end

  describe ".geometry_paths" do
    it "collects paths across all Properties of the item" do
      oval = Idml::Elements::Oval.from_xml(<<~XML)
        <Oval Self="o1">
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="0 0" LeftDirection="0 0" RightDirection="0 0"/>
                  <PathPointType Anchor="0 50" LeftDirection="0 50" RightDirection="0 50"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
        </Oval>
      XML
      expect(described_class.geometry_paths(oval).length).to eq(1)
    end
  end

  describe ".render end-to-end" do
    let(:writer) { Idml::Render::PdfrbWriter.new }
    let(:canvas) { writer.add_page(width: 400, height: 400) }

    def build_oval(fill_color: "Color/Red")
      Idml::Elements::Oval.from_xml(<<~XML)
        <Oval Self="o1" ItemTransform="1 0 0 1 100 100" FillColor="#{fill_color}">
          <Properties>
            <PathGeometry>
              <GeometryPathType PathOpen="false">
                <PathPointArray>
                  <PathPointType Anchor="0 25" LeftDirection="-13.8 25" RightDirection="13.8 25"/>
                  <PathPointType Anchor="25 50" LeftDirection="25 36.2" RightDirection="25 63.8"/>
                  <PathPointType Anchor="50 25" LeftDirection="63.8 25" RightDirection="36.2 25"/>
                  <PathPointType Anchor="25 0" LeftDirection="25 13.8" RightDirection="25 -13.8"/>
                </PathPointArray>
              </GeometryPathType>
            </PathGeometry>
          </Properties>
        </Oval>
      XML
    end

    def context_for(item)
      resolver = Struct.new(:table, keyword_init: true) do
        def resolve(name)
          table[name]
        end
      end
      Idml::Render::RenderContext.new(
        item: item,
        color_resolver: resolver.new(
          table: { "Color/Red" => { model: :rgb, r: 1, g: 0, b: 0 } },
        ),
        page_height: 400,
      )
    end

    it "fills the Bézier ellipse, not a rectangle" do
      Idml::Render::Renderers::OvalRenderer.render(
        canvas, context_for(build_oval)
      )
      write_to_temp_pdf(writer, "contour-oval") do |path|
        raw = File.binread(path)
        expect(raw.scan(/ c\b/).length).to eq(4)
        expect(raw).to match(/ f\b/)
        expect(raw).not_to include(" re")
      end
    end

    it "falls back to the bounding box when there is no geometry" do
      item = Struct.new(
        :visible, :fill_color, :geometric_bounds, :item_transform,
        :stroke_color, :stroke_weight, :transparency_setting, :properties,
        keyword_init: true
      ).new(
        visible: true, fill_color: "Color/Red",
        geometric_bounds: [0, 0, 100, 100], item_transform: "1 0 0 1 0 0",
        stroke_color: nil, stroke_weight: nil,
        transparency_setting: nil, properties: []
      )
      Idml::Render::Renderers::OvalRenderer.render(
        canvas, context_for(item)
      )
      write_to_temp_pdf(writer, "contour-fallback") do |path|
        expect(File.binread(path)).to include(" re")
      end
    end
  end
end
# rubocop:enable RSpec/SpecFilePathFormat
