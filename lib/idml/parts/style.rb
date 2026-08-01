# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/Styles.xml`. Holds every paragraph,
    # character, object, cell, and table style (grouped under their
    # respective root style groups).
    class Style < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Styles.xml"

      attribute :dom_version, :string

      xml do
        root "Styles"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
