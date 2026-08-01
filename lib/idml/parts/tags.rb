# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/Tags.xml`. Root is `<idPkg:Tags>`; children
    # are `<XMLTag>` elements. XmlTag declares every attribute from
    # `XMLTag_Object` in
    # `reference-docs/schemas/package/XML/Tags.rnc`.
    class Tags < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/Tags.xml"

      attribute :dom_version, :string
      attribute :xml_tag, Idml::Elements::XmlTag, collection: true

      xml do
        root "Tags"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "XMLTag", to: :xml_tag
      end
    end
  end
end
