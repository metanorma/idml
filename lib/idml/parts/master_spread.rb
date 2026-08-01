# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `MasterSpreads/MasterSpread_*.xml`.
    class MasterSpread < Lutaml::Model::Serializable
      include Idml::Part

      part_file %r{\AMasterSpreads/MasterSpread_[^/]+\.xml\z}

      attribute :dom_version, :string

      xml do
        root "MasterSpread"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
