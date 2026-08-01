# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/Preferences.xml`. Document-level and
    # application-level preferences (one of the largest parts by element
    # count — full modeling is incremental).
    class Preferences < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Preferences.xml"

      attribute :dom_version, :string

      xml do
        root "Preferences"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
