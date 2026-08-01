# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/Mapping.xml`. Maps XML tags to styles for
    # XML import/export. Not present in every IDML file.
    class Mapping < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/Mapping.xml"

      attribute :dom_version, :string

      xml do
        root "Mapping"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
