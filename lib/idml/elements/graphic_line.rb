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
      attribute :visible, :boolean

      xml do
        root "GraphicLine"
        map_attribute "Self", to: :self_attr
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_attribute "StrokeTint", to: :stroke_tint
        map_attribute "Visible", to: :visible
      end
    end
  end
end
