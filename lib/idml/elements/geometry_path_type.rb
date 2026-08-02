# frozen_string_literal: true

module Idml
  module Elements
    # `<GeometryPathType>` — a single path within a PathGeometry.
    # Contains a PathPointArray and a PathOpen flag (true = open path,
    # false = closed path).
    class GeometryPathType < Lutaml::Model::Serializable
      attribute :path_open, :boolean
      attribute :path_point_array, Idml::Elements::PathPointArray,
                collection: true

      xml do
        root "GeometryPathType"
        map_attribute "PathOpen", to: :path_open
        map_element "PathPointArray", to: :path_point_array
      end

      def points
        path_point_array.flat_map(&:path_point_type)
      end
    end
  end
end
