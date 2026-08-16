# frozen_string_literal: true

module Idml
  module Elements
    # `<Path>` — a standalone compound-path page item. Schema-faithful
    # model of `Path_Object` in
    # `reference-docs/schemas/package/Spreads/Spread.rnc`. Carries
    # geometry via `Properties/EntirePath` (a flat list of x/y pairs)
    # or via PathPoint children.
    #
    # The renderer treats a Path like a Polygon — it draws the path
    # points as a filled/stroked polygon. Bezier curve rendering
    # (via LeftDirection/RightDirection) is a refinement; see TODO 106.
    class Path < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :path_type, :string
      attribute :item_transform, :string
      attribute :fill_color, :string
      attribute :fill_tint, :float
      attribute :stroke_color, :string
      attribute :stroke_weight, :float
      attribute :stroke_tint, :float
      attribute :visible, :boolean
      attribute :name, :string
      attribute :item_layer, :string
      attribute :properties, Idml::Elements::Properties, collection: true
      attribute :transparency_setting, Idml::Elements::TransparencySetting
      attribute :text_wrap_preference, Idml::Elements::TextWrapPreference
      attribute :anchored_object_setting,
                Idml::Elements::AnchoredObjectSetting

      xml do
        root "Path"
        map_attribute "Self", to: :self_attr
        map_attribute "PathType", to: :path_type
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_attribute "StrokeTint", to: :stroke_tint
        map_attribute "Visible", to: :visible
        map_attribute "Name", to: :name
        map_attribute "ItemLayer", to: :item_layer
        map_element "Properties", to: :properties
        map_element "TransparencySetting", to: :transparency_setting
        map_element "TextWrapPreference", to: :text_wrap_preference
        map_element "AnchoredObjectSetting", to: :anchored_object_setting
      end

      def geometric_bounds
        @geometric_bounds ||= first_geometry&.bounding_box
      end

      def first_geometry
        properties.first&.first_geometry
      end
    end
  end
end
