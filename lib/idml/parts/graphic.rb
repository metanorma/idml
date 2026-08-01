# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/Graphic.xml`. Defines colors, tints,
    # gradients, strokes, and other graphic resources referenced by
    # page items.
    class Graphic < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Graphic.xml"

      attribute :dom_version, :string

      xml do
        root "Graphic"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
      end
    end
  end
end
