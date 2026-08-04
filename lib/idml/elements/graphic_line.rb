# frozen_string_literal: true

module Idml
  module Elements
    # `<GraphicLine>` — a straight line page item. Carries stroke
    # attributes and an `ItemTransform`.
    class GraphicLine < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :item_transform, :string
      attribute :stroke_color, :string
      attribute :stroke_weight, :float
      attribute :stroke_tint, :float
      attribute :end_cap, :string
      attribute :end_join, :string
      attribute :miter_limit, :float
      attribute :stroke_dash_and_gap, :string
      attribute :visible, :boolean
      attribute :item_layer, :string
      attribute :properties, Idml::Elements::Properties, collection: true
      attribute :transparency_setting, Idml::Elements::TransparencySetting

      xml do
        root "GraphicLine"
        map_attribute "Self", to: :self_attr
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_attribute "StrokeTint", to: :stroke_tint
        map_attribute "EndCap", to: :end_cap
        map_attribute "EndJoin", to: :end_join
        map_attribute "MiterLimit", to: :miter_limit
        map_attribute "StrokeDashAndGap", to: :stroke_dash_and_gap
        map_attribute "Visible", to: :visible
        map_attribute "ItemLayer", to: :item_layer
        map_element "Properties", to: :properties
        map_element "TransparencySetting", to: :transparency_setting
      end

      def geometric_bounds
        @geometric_bounds ||= properties.first&.first_geometry&.bounding_box
      end
    end
  end
end
