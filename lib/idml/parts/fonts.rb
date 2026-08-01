# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/Fonts.xml`. Lists every font family
    # and font face used in the document.
    class Fonts < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Fonts.xml"

      attribute :dom_version, :string

      xml do
        root "Fonts"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
