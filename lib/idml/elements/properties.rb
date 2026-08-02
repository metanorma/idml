# frozen_string_literal: true

module Idml
  module Elements
    # `<Properties>` — a common child element on page items. Carries
    # optional PathBoundingBox, PathGeometry, and Label. Only the
    # modeled children are populated from XML; others are ignored.
    class Properties < Lutaml::Model::Serializable
      attribute :path_bounding_box, :string
      attribute :path_geometry, Idml::Elements::PathGeometry,
                collection: true

      xml do
        root "Properties"
        map_element "PathBoundingBox", to: :path_bounding_box
        map_element "PathGeometry", to: :path_geometry
      end

      def first_geometry
        path_geometry.first
      end
    end
  end
end
