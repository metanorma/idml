# frozen_string_literal: true

module Idml
  module Elements
    # `<Properties>` — a common child element on page items and
    # story style ranges. Carries optional PathBoundingBox,
    # PathGeometry, Label, and the paragraph-decoration color value
    # elements (RuleAboveColor, ParagraphShadingColor, …) used on
    # PSR/CSR Properties. Only the modeled children are populated
    # from XML; others are ignored.
    class Properties < Lutaml::Model::Serializable
      attribute :path_bounding_box, :string
      attribute :path_geometry, Idml::Elements::PathGeometry,
                collection: true
      attribute :rule_above_color, Idml::Elements::TypedValue
      attribute :rule_below_color, Idml::Elements::TypedValue
      attribute :paragraph_shading_color, Idml::Elements::TypedValue
      attribute :paragraph_border_color, Idml::Elements::TypedValue
      attribute :text_wrap_offset, Idml::Elements::TypedValue
      attribute :paragraph_border_gap_color, Idml::Elements::TypedValue

      xml do
        root "Properties"
        map_element "PathBoundingBox", to: :path_bounding_box
        map_element "PathGeometry", to: :path_geometry
        map_element "RuleAboveColor", to: :rule_above_color
        map_element "RuleBelowColor", to: :rule_below_color
        map_element "ParagraphShadingColor", to: :paragraph_shading_color
        map_element "ParagraphBorderColor", to: :paragraph_border_color
        map_element "TextWrapOffset", to: :text_wrap_offset
        map_element "ParagraphBorderGapColor", to: :paragraph_border_gap_color
      end

      def first_geometry
        path_geometry.first
      end
    end
  end
end
