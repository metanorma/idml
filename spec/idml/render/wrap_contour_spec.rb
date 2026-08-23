# frozen_string_literal: true

require "spec_helper"

RSpec.describe Idml::Render::WrapContour do
  def path_geometry_xml(points)
    points_xml = points.map do |anchor, left, right|
      %(<PathPointType Anchor="#{anchor}" LeftDirection="#{left}" RightDirection="#{right}"/>)
    end.join
    <<~XML
      <PathGeometry>
        <GeometryPathType PathOpen="false">
          <PathPointArray>#{points_xml}</PathPointArray>
        </GeometryPathType>
      </PathGeometry>
    XML
  end

  def rect_item(bounds, wrap_offset: nil)
    x1, y1, x2, y2 = bounds
    pts = [[x1, y1], [x1, y2], [x2, y2], [x2, y1]]
    points = pts.map { |a| [a.join(" ")] * 3 }
    offset_xml = wrap_offset ? %(<Properties><TextWrapOffset type="list">#{wrap_offset}</TextWrapOffset></Properties>) : ""
    Idml::Elements::Oval.from_xml(<<~XML)
      <Oval Self="o1">
        <Properties>#{path_geometry_xml(points)}</Properties>
        <TextWrapPreference TextWrapMode="Contour">#{offset_xml}</TextWrapPreference>
      </Oval>
    XML
  end

  def ellipse_item(center_x: 100, center_y: 100, radius_x: 60,
                   radius_y: 40)
    kappa = 0.5523
    points = ellipse_points(center_x, center_y, radius_x, radius_y, kappa)
      .map { |anchor, left, right| [fmt(anchor), fmt(left), fmt(right)] }
    Idml::Elements::Oval.from_xml(<<~XML)
      <Oval Self="o1">
        <Properties>#{path_geometry_xml(points)}</Properties>
        <TextWrapPreference TextWrapMode="Contour"/>
      </Oval>
    XML
  end

  # rubocop:disable Metrics/AbcSize -- pure fixture geometry math
  def ellipse_points(center_x, center_y, radius_x, radius_y, kappa)
    [
      [[center_x, center_y + radius_y],
       [center_x - (kappa * radius_x), center_y + radius_y],
       [center_x + (kappa * radius_x), center_y + radius_y]],
      [[center_x + radius_x, center_y],
       [center_x + radius_x, center_y + (kappa * radius_y)],
       [center_x + radius_x, center_y - (kappa * radius_y)]],
      [[center_x, center_y - radius_y],
       [center_x + (kappa * radius_x), center_y - radius_y],
       [center_x - (kappa * radius_x), center_y - radius_y]],
      [[center_x - radius_x, center_y],
       [center_x - radius_x, center_y - (kappa * radius_y)],
       [center_x - radius_x, center_y + (kappa * radius_y)]],
    ]
  end
  # rubocop:enable Metrics/AbcSize

  def fmt(pair)
    pair.map { |v| format("%<v>g", v: v) }.join(" ")
  end

  def shape_for(item, page_height = 400)
    pref = item.text_wrap_preference
    described_class.shape(item, pref, page_height)
  end

  describe ".shape flattening" do
    it "builds a polygon from a rectangle path (straight controls)" do
      shape = shape_for(rect_item([40, 60, 160, 140]))
      expect(shape).not_to be_nil
      expect(shape.polygons.length).to eq(1)
      xs = shape.polygons.first.map(&:first)
      ys = shape.polygons.first.map(&:last)
      # y flipped into PDF space
      expect(xs.min).to be_within(0.01).of(40)
      expect(ys.min).to be_within(0.01).of(400 - 140)
    end

    it "flattens bezier segments into more points than anchors" do
      shape = shape_for(ellipse_item)
      expect(shape.polygons.first.length).to be > 4
      expect(shape.polygons.first.length).to be >= 4 * 8
    end
  end

  describe ".overlap_width" do
    it "matches the full width at the shape's middle" do
      shape = shape_for(rect_item([40, 60, 160, 140]))
      width = described_class.overlap_width(
        shape, 400 - 100, 12, 0, 400
      )
      expect(width).to be_within(0.01).of(120)
    end

    it "is zero outside the shape's band" do
      shape = shape_for(rect_item([40, 60, 160, 140]))
      width = described_class.overlap_width(
        shape, 400 - 300, 12, 0, 400
      )
      expect(width).to eq(0.0)
    end

    it "is narrower than the bounding box near an ellipse's edge" do
      shape = shape_for(ellipse_item)
      near_top = described_class.overlap_width(
        shape, (400 - 100) + 34, 4, 0, 400
      )
      at_middle = described_class.overlap_width(
        shape, 400 - 100, 4, 0, 400
      )
      expect(near_top).to be > 0
      expect(near_top).to be < at_middle
      expect(at_middle).to be_within(1.0).of(120)
    end

    it "expands the overlap by the TextWrapOffset bounds" do
      item = rect_item([40, 60, 160, 140], wrap_offset: "5 10 5 12")
      shape = shape_for(item)

      width = described_class.overlap_width(shape, 400 - 100, 12, 0, 400)
      # 120 + left 10 + right 12
      expect(width).to be_within(0.01).of(142)
    end

    it "clips the overlap to the frame width" do
      shape = shape_for(rect_item([40, 60, 360, 140]))
      width = described_class.overlap_width(
        shape, 400 - 100, 12, 300, 340
      )
      expect(width).to eq(40)
    end
  end
end
