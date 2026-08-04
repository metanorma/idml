# frozen_string_literal: true

module Idml
  module Elements
    # `<Polygon>` — a polygonal page item. Carries fill/stroke attributes
    # and a PathPointArray defining the vertices.
    class Polygon < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :content_type, :string
      attribute :item_transform, :string
      attribute :fill_color, :string
      attribute :fill_tint, :float
      attribute :stroke_color, :string
      attribute :stroke_weight, :float
      attribute :end_cap, :string
      attribute :end_join, :string
      attribute :miter_limit, :float
      attribute :stroke_dash_and_gap, :string
      attribute :visible, :boolean
      attribute :item_layer, :string
      attribute :properties, Idml::Elements::Properties, collection: true
      attribute :transparency_setting, Idml::Elements::TransparencySetting
      attribute :image, Idml::Elements::Image, collection: true

      xml do
        root "Polygon"
        map_attribute "Self", to: :self_attr
        map_attribute "ContentType", to: :content_type
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_attribute "EndCap", to: :end_cap
        map_attribute "EndJoin", to: :end_join
        map_attribute "MiterLimit", to: :miter_limit
        map_attribute "StrokeDashAndGap", to: :stroke_dash_and_gap
        map_attribute "Visible", to: :visible
        map_attribute "ItemLayer", to: :item_layer
        map_element "Properties", to: :properties
        map_element "TransparencySetting", to: :transparency_setting
        map_element "Image", to: :image
      end

      def geometric_bounds
        @geometric_bounds ||= properties.first&.first_geometry&.bounding_box
      end
    end
  end
end
