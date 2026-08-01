# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Spreads/Spread_*.xml`. Root is `<idPkg:Spread>`
    # (wrapper, DOMVersion); the inner `<Spread>` carries the actual
    # spread content. The SpreadObject element class declares every
    # attribute from `Spread_Object` in
    # `reference-docs/schemas/package/Spreads/Spread.rnc`.
    class Spread < Lutaml::Model::Serializable
      include Idml::Part

      part_file %r{\ASpreads/Spread_[^/]+\.xml\z}

      attribute :dom_version, :string
      attribute :spread, Idml::Elements::SpreadObject, collection: true

      xml do
        root "Spread"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "Spread", to: :spread
      end
    end
  end
end
