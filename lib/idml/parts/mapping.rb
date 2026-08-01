# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/Mapping.xml`. Maps XML tags to styles for
    # XML import/export. Not present in every IDML file.
    class Mapping < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/Mapping.xml"

      attribute :dom_version, :string
      attribute :xml_export_map, Idml::Elements::XmlExportMap, collection: true
      attribute :xml_import_map, Idml::Elements::XmlImportMap, collection: true

      xml do
        root "Mapping"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "XMLExportMap", to: :xml_export_map
        map_element "XMLImportMap", to: :xml_import_map
      end
    end
  end
end
