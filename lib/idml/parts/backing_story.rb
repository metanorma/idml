# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/BackingStory.xml`. BackingStory is the root
    # of the document's logical XML structure. Root is
    # `<idPkg:BackingStory>`; the inner `<XmlStory>` carries the
    # structure tree. XmlStory declares every attribute from
    # `XmlStory_Object` in
    # `reference-docs/schemas/package/XML/BackingStory.rnc`.
    class BackingStory < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/BackingStory.xml"

      attribute :dom_version, :string
      attribute :xml_story, Idml::Elements::XmlStory, collection: true

      xml do
        root "BackingStory"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "XmlStory", to: :xml_story
      end
    end
  end
end
