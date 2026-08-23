# frozen_string_literal: true

module Idml
  module Render
    # Shape-mode text wrap: builds a PDF-space polygon from a page
    # item's PathGeometry (Bézier segments flattened at a fixed
    # resolution) and measures the horizontal overlap of a text
    # line's band with the polygon, expanded by the wrap offsets.
    # Band coverage uses even-odd ray casting at the band's
    # midline, so compound paths with holes wrap correctly.
    module WrapContour
      FLATTEN_STEPS = 8

      # A wrap shape: flattened polygons (one per subpath) plus the
      # TextWrapOffset bounds.
      Shape = Struct.new(:polygons, :offset, keyword_init: true)

      # Builds the wrap shape for an item's PathGeometry and wrap
      # preference. Returns nil when the item has no geometry.
      def self.shape(item, pref, page_height)
        polygons = polygons_for(item, page_height)
        return nil if polygons.empty?

        Shape.new(polygons: polygons, offset: wrap_offset(pref))
      end

      def self.polygons_for(item, page_height)
        transform = Geometry.parse_transform(item.item_transform)
        paths = item.properties.flat_map do |props|
          props.path_geometry.flat_map(&:geometry_path_type)
        end
        paths.filter_map do |path|
          points = flatten_path(path, transform, page_height)
          points.length >= 3 ? points : nil
        end
      end
      private_class_method :polygons_for

      # Flattens one subpath's Bézier segments into line segments
      # in PDF space (ItemTransform applied, y flipped).
      def self.flatten_path(path, transform, page_height)
        anchors = path.points
        return [] if anchors.length < 2

        open = path.path_open == true
        segments = open ? anchors.length - 1 : anchors.length
        points = [pdf_point(anchors.first, transform, page_height)]
        segments.times do |index|
          from = anchors[index]
          to = anchors[(index + 1) % anchors.length]
          append_segment(points, from, to, transform, page_height)
        end
        points
      end
      private_class_method :flatten_path

      def self.append_segment(points, from, to, transform, page_height)
        c1 = pair_or_nil(from, :right_direction, transform, page_height)
        c2 = pair_or_nil(to, :left_direction, transform, page_height)
        start = points.last
        if c1.nil? && c2.nil?
          points << pdf_point(to, transform, page_height)
          return
        end

        c1 ||= start
        c2 ||= pdf_point(to, transform, page_height)
        (1..FLATTEN_STEPS).each do |step|
          t = step.to_f / FLATTEN_STEPS
          points << bezier_point(start, c1, c2,
                                 pdf_point(to, transform, page_height), t)
        end
      end
      private_class_method :append_segment

      def self.bezier_point(p0, p1, p2, p3, t)
        u = 1 - t
        w0 = u * u * u
        w1 = 3 * u * u * t
        w2 = 3 * u * t * t
        w3 = t * t * t
        [
          (w0 * p0[0]) + (w1 * p1[0]) + (w2 * p2[0]) + (w3 * p3[0]),
          (w0 * p0[1]) + (w1 * p1[1]) + (w2 * p2[1]) + (w3 * p3[1]),
        ]
      end
      private_class_method :bezier_point

      def self.pair_or_nil(point, direction_attr, transform, page_height)
        raw = point.public_send(direction_attr)
        raw = nil if raw && raw.strip.empty?
        raw && pdf_pair(raw, transform, page_height)
      end
      private_class_method :pair_or_nil

      def self.pdf_point(point, transform, page_height)
        pdf_pair(point.anchor, transform, page_height)
      end
      private_class_method :pdf_point

      def self.pdf_pair(raw, transform, page_height)
        x, y = raw.to_s.split(/\s+/).map(&:to_f)
        tx, ty = Geometry.apply_transform(transform, x, y)
        [tx, page_height - ty]
      end
      private_class_method :pdf_pair

      # The wrap offsets from Properties > TextWrapOffset
      # ("top left bottom right"); zero when absent.
      def self.wrap_offset(pref)
        raw = pref.properties.first&.text_wrap_offset&.value
        parts = raw.to_s.split(/\s+/).map(&:to_f)
        return [0.0, 0.0] if parts.length < 4

        [parts[1], parts[3]] # left, right
      end
      private_class_method :wrap_offset

      # Total horizontal overlap of the text line's band with the
      # shape, expanded by the offsets and clipped to the frame.
      def self.overlap_width(shape, line_y, line_height, frame_x,
                             frame_right)
        mid_y = line_y + (line_height / 2.0)
        width = shape.polygons.sum do |polygon|
          polygon_overlap(polygon, mid_y, shape.offset)
        end
        clip_width(width, frame_x, frame_right)
      end

      # Even-odd intervals at mid_y expanded by [left, right]
      # offsets, summed (separate subpaths sum; the common case is
      # one polygon).
      def self.polygon_overlap(polygon, mid_y, offset)
        crossings = edge_crossings(ring(polygon), mid_y).sort
        return 0.0 if crossings.length < 2

        left, right = offset
        crossings.each_slice(2).sum do |entry_x, exit_x|
          (exit_x + right) - (entry_x - left)
        end
      end
      private_class_method :polygon_overlap

      # Closes the polygon ring (each_cons alone misses the
      # last→first edge).
      def self.ring(polygon)
        polygon + [polygon.first]
      end
      private_class_method :ring

      def self.edge_crossings(points, mid_y)
        points.each_cons(2).filter_map do |(x1, y1), (x2, y2)|
          next unless crosses_midline?(y1, y2, mid_y)

          t = (mid_y - y1) / (y2 - y1)
          x1 + (t * (x2 - x1))
        end
      end
      private_class_method :edge_crossings

      def self.crosses_midline?(y1, y2, mid_y)
        (y1 <= mid_y && y2 > mid_y) || (y2 <= mid_y && y1 > mid_y)
      end
      private_class_method :crosses_midline?

      def self.clip_width(width, frame_x, frame_right)
        [width, frame_right - frame_x].min
      end
      private_class_method :clip_width
    end
  end
end
