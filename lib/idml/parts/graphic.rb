# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for the package's `graphic.xml` part.
    # Every child element from `reference-docs/schemas/package/Resources/Graphic.rnc` is typed — generated
    # via `scripts/rnc_to_lutaml.rb` + `scripts/assemble_element.rb`.
    class Graphic < Lutaml::Model::Serializable
      include Idml::Part

      part_file "Resources/Graphic.xml"

      attribute :dom_version, :string
      attribute :color, Idml::Elements::Color, collection: true
      attribute :ink, Idml::Elements::Ink, collection: true
      attribute :mixed_ink_group, Idml::Elements::MixedInkGroup, collection: true
      attribute :mixed_ink, Idml::Elements::MixedInk, collection: true
      attribute :pasted_smooth_shade, Idml::Elements::PastedSmoothShade, collection: true
      attribute :tint, Idml::Elements::Tint, collection: true
      attribute :swatch, Idml::Elements::Swatch, collection: true
      attribute :gradient, Idml::Elements::Gradient, collection: true
      attribute :gradient_stop, Idml::Elements::GradientStop, collection: true
      attribute :stroke_style, Idml::Elements::StrokeStyle, collection: true
      attribute :dashed_stroke_style, Idml::Elements::DashedStrokeStyle, collection: true
      attribute :dotted_stroke_style, Idml::Elements::DottedStrokeStyle, collection: true
      attribute :striped_stroke_style, Idml::Elements::StripedStrokeStyle, collection: true

      xml do
        root "Graphic"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "Color", to: :color
        map_element "Ink", to: :ink
        map_element "MixedInkGroup", to: :mixed_ink_group
        map_element "MixedInk", to: :mixed_ink
        map_element "PastedSmoothShade", to: :pasted_smooth_shade
        map_element "Tint", to: :tint
        map_element "Swatch", to: :swatch
        map_element "Gradient", to: :gradient
        map_element "GradientStop", to: :gradient_stop
        map_element "StrokeStyle", to: :stroke_style
        map_element "DashedStrokeStyle", to: :dashed_stroke_style
        map_element "DottedStrokeStyle", to: :dotted_stroke_style
        map_element "StripedStrokeStyle", to: :striped_stroke_style
      end
    end
  end
end
