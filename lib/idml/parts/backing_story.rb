# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/BackingStory.xml`. BackingStory is the root
    # of the document's logical XML structure (the tagged-content tree
    # visible in InDesign's Structure panel). The XMLElement collection
    # forms the recursive structure tree.
    class BackingStory < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/BackingStory.xml"

      attribute :dom_version, :string
      attribute :xml_element, Idml::Elements::XmlElement, collection: true

      xml do
        root "BackingStory"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "XMLElement", to: :xml_element
      end
    end
  end
end
