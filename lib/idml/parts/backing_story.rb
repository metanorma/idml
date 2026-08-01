# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/BackingStory.xml`. BackingStory is the root
    # of the document's logical XML structure (the tagged-content tree
    # visible in InDesign's Structure panel).
    class BackingStory < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/BackingStory.xml"

      attribute :dom_version, :string

      xml do
        root "BackingStory"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
