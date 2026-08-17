# frozen_string_literal: true

module Idml
  module Render
    # Renders a page item's PathGeometry as true Bézier contours on
    # a pdfrb canvas. Shared by OvalRenderer, PathRenderer, and
    # PolygonRenderer: every item whose Properties carry a
    # PathGeometry draws its actual outline — PathPointType anchors
    # with LeftDirection / RightDirection control handles,
    # ItemTransform applied, y flipped into PDF space — instead of
    # its bounding box. Paint op selection (fill / stroke /
    # gradient) lives in ShapePaint. Items without usable geometry
    # fall back to the bounding-box rectangle.
    module Contour
      # Renders the item's contours with fill/stroke from
      # ShapePaint. Returns true when painted.
      def self.render(canvas, context)
        item = context.item
        return false if item.visible == false

        paths = geometry_paths(item)
        return rectangle_fallback(canvas, item, context) if paths.empty?

        ShapePaint.paint(canvas, item, context) do |c|
          draw_path(c, paths, item.item_transform, context.page_height)
        end
      end

      def self.rectangle_fallback(canvas, item, context)
        box = Placement.box(item, context.page_height)
        return false unless box

        ShapePaint.paint(canvas, item, context) do |c|
          c.rectangle(box[:x], box[:y], box[:width], box[:height])
        end
      end
      private_class_method :rectangle_fallback

      # All GeometryPathType children across the item's Properties.
      def self.geometry_paths(item)
        item.properties.flat_map do |props|
          props.path_geometry.flat_map(&:geometry_path_type)
        end
      end

      # Constructs the full path on the canvas: one subpath per
      # GeometryPathType, each starting at its first anchor and
      # curving through every subsequent anchor via the points'
      # control handles. Closed paths (PathOpen false or absent)
      # loop back to the first anchor and close.
      def self.draw_path(canvas, paths, item_transform, page_height)
        transform = Geometry.parse_transform(item_transform)
        paths.each do |path|
          draw_subpath(canvas, path, transform, page_height)
        end
      end

      def self.draw_subpath(canvas, path, transform, page_height)
        points = path.points
        return if points.length < 2

        open = path.path_open == true
        anchors = points.map do |point|
          pdf_pair(point.anchor, transform, page_height)
        end
        canvas.move_to(anchors.first[0], anchors.first[1])
        draw_segments(canvas, points, anchors, transform, page_height, open)
        canvas.close_path unless open
      end
      private_class_method :draw_subpath

      def self.draw_segments(canvas, points, anchors, transform,
                             page_height, open)
        segment_count = open ? points.length - 1 : points.length
        segment_count.times do |index|
          from = points[index]
          to = points[(index + 1) % points.length]
          c1 = control_point(from, :right_direction, from.anchor,
                             transform, page_height)
          c2 = control_point(to, :left_direction, to.anchor,
                             transform, page_height)
          to_anchor = anchors[(index + 1) % points.length]
          canvas.curve_to(c1[0], c1[1], c2[0], c2[1],
                          to_anchor[0], to_anchor[1])
        end
      end
      private_class_method :draw_segments

      # Control point for one end of a segment: the point's
      # direction handle when present, else the anchor itself
      # (degenerate control = straight-ish curve).
      def self.control_point(point, direction_attr, fallback, transform,
                             page_height)
        raw = point.public_send(direction_attr)
        raw = nil if raw && raw.strip.empty?
        pdf_pair(raw || fallback, transform, page_height)
      end
      private_class_method :control_point

      # Parses an IDML "x y" pair, applies the item transform, and
      # flips y into PDF space (origin bottom-left).
      def self.pdf_pair(raw, transform, page_height)
        x, y = raw.to_s.split(/\s+/).map(&:to_f)
        tx, ty = Geometry.apply_transform(transform, x, y)
        [tx, page_height - ty]
      end
      private_class_method :pdf_pair
    end
  end
end
