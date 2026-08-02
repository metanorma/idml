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
      attribute :visible, :boolean
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
        map_attribute "Visible", to: :visible
        map_element "Image", to: :image
      end
    end
  end
end
