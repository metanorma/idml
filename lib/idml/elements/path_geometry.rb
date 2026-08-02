# frozen_string_literal: true

module Idml
  module Elements
    # `<PathGeometry>` — the shape geometry of a page item. Contains
    # one or more GeometryPathType elements. Provides a
    # `bounding_box` convenience method that derives [y1, x1, y2, x2]
    # from the anchor points.
    class PathGeometry < Lutaml::Model::Serializable
      attribute :geometry_path_type, Idml::Elements::GeometryPathType,
                collection: true

      xml do
        root "PathGeometry"
        map_element "GeometryPathType", to: :geometry_path_type
      end

      # Returns [y1, x1, y2, x2] from all anchor points across all paths.
      # nil if no points.
      def bounding_box
        pts = all_points
        return nil if pts.empty?

        xs = pts.map(&:x)
        ys = pts.map(&:y)
        [ys.min, xs.min, ys.max, xs.max]
      end

      def all_points
        return [] unless geometry_path_type

        geometry_path_type.flat_map(&:points)
      end
    end
  end
end
