# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/StyleMapping.xml`. Maps XML tags to
    # paragraph/character styles for round-trip XML import/export.
    class StyleMapping < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/StyleMapping.xml"

      attribute :dom_version, :string

      xml do
        root "StyleMapping"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
