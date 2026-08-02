# frozen_string_literal: true

module Idml
  module Elements
    # `<PathPointArray>` — a collection of PathPointType elements
    # defining the vertices of a path.
    class PathPointArray < Lutaml::Model::Serializable
      attribute :path_point_type, Idml::Elements::PathPointType,
                collection: true

      xml do
        root "PathPointArray"
        map_element "PathPointType", to: :path_point_type
      end

      def anchors
        path_point_type
      end
    end
  end
end
