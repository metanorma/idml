# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `MasterSpreads/MasterSpread_*.xml`. Root is
    # `<idPkg:MasterSpread>`; the inner `<MasterSpread>` carries
    # the actual master content. MasterSpreadObject declares every
    # attribute from `MasterSpread_Object` in
    # `reference-docs/schemas/package/MasterSpreads/MasterSpread.rnc`.
    class MasterSpread < Lutaml::Model::Serializable
      include Idml::Part

      part_file %r{\AMasterSpreads/MasterSpread_[^/]+\.xml\z}

      attribute :dom_version, :string
      attribute :master_spread, Idml::Elements::MasterSpreadObject,
                collection: true

      xml do
        root "MasterSpread"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "MasterSpread", to: :master_spread
      end
    end
  end
end
