# frozen_string_literal: true

module Idml
  module Elements
    # `<Rectangle>` — a rectangular page item. Can carry a fill color,
    # stroke, and contain child `<Image>` elements when used as a
    # graphic frame (`ContentType="GraphicType"`).
    class Rectangle < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :content_type, :string
      attribute :item_transform, :string
      attribute :fill_color, :string
      attribute :fill_tint, :float
      attribute :overprint_fill, :boolean
      attribute :stroke_color, :string
      attribute :stroke_weight, :float
      attribute :stroke_tint, :float
      attribute :end_cap, :string
      attribute :end_join, :string
      attribute :miter_limit, :float
      attribute :stroke_dash_and_gap, :string
      attribute :visible, :boolean
      attribute :name, :string
      attribute :item_layer, :string
      attribute :properties, Idml::Elements::Properties, collection: true
      attribute :transparency_setting, Idml::Elements::TransparencySetting
      attribute :image, Idml::Elements::Image, collection: true

      xml do
        root "Rectangle"
        map_attribute "Self", to: :self_attr
        map_attribute "ContentType", to: :content_type
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
        map_attribute "OverprintFill", to: :overprint_fill
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_attribute "StrokeTint", to: :stroke_tint
        map_attribute "EndCap", to: :end_cap
        map_attribute "EndJoin", to: :end_join
        map_attribute "MiterLimit", to: :miter_limit
        map_attribute "StrokeDashAndGap", to: :stroke_dash_and_gap
        map_attribute "Visible", to: :visible
        map_attribute "Name", to: :name
        map_attribute "ItemLayer", to: :item_layer
        map_element "Properties", to: :properties
        map_element "TransparencySetting", to: :transparency_setting
        map_element "Image", to: :image
      end

      def graphic?
        content_type == "GraphicType"
      end

      # Derives [y1, x1, y2, x2] from the Properties/PathGeometry.
      # Memoised — the PathGeometry walk is non-trivial and bounds
      # are read multiple times per item (Placement.box,
      # ImageCollector#clip_box_for, HyperlinkEmitter).
      def geometric_bounds
        @geometric_bounds ||= first_geometry&.bounding_box
      end

      def first_geometry
        properties.first&.first_geometry
      end
    end
  end
end
