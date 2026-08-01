# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Resources/Graphic.xml`. Defines colors, tints,
    # gradients, strokes, and other graphic resources referenced by
    # page items. Typed children are the most-used _Object types from
    # `reference-docs/schemas/package/Resources/Graphic.rnc`; rarer
    # ones (Ink, MixedInkGroup, PastedSmoothShade, StrokeStyle
    # variants) can be added via the same codegen pattern.
    class Graphic < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Graphic.xml"

      attribute :dom_version, :string
      attribute :color, Idml::Elements::Color, collection: true
      attribute :tint, Idml::Elements::Tint, collection: true
      attribute :gradient, Idml::Elements::Gradient, collection: true
      attribute :swatch, Idml::Elements::Swatch, collection: true

      xml do
        root "Graphic"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "Color", to: :color
        map_element "Tint", to: :tint
        map_element "Gradient", to: :gradient
        map_element "Swatch", to: :swatch
      end
    end
  end
end
