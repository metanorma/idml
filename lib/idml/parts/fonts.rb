# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/Fonts.xml`. Root is `<idPkg:Fonts>`;
    # children are `<FontFamily>` elements (each containing `<Font>`
    # children). FontFamily and Font declare every attribute from
    # their respective `_Object` definitions in
    # `reference-docs/schemas/package/Resources/Fonts.rnc`.
    class Fonts < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Fonts.xml"

      attribute :dom_version, :string
      attribute :font_family, Idml::Elements::FontFamily, collection: true

      xml do
        root "Fonts"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "FontFamily", to: :font_family
      end
    end
  end
end
