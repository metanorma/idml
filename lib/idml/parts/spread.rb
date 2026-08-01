# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Spreads/Spread_*.xml`. The root wrapper element
    # `<idPkg:Spread>` carries `DOMVersion`; the inner `<Spread>` element
    # holds the actual spread content (page items, geometry). This initial
    # model captures the wrapper's attributes; inner content modeling is
    # incremental.
    class Spread < Lutaml::Model::Serializable
      include Idml::Part

      part_file %r{\ASpreads/Spread_[^/]+\.xml\z}

      attribute :dom_version, :string

      xml do
        root "Spread"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
