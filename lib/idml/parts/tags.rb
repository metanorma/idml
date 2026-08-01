# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `XML/Tags.xml`. Lists every XML tag defined in
    # the document's logical structure.
    class Tags < Lutaml::Model::Serializable
      include Idml::Part

      part_file "XML/Tags.xml"

      attribute :dom_version, :string

      xml do
        root "Tags"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
