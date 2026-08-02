# frozen_string_literal: true

module Idml
  module Elements
    # `<Table>` — a table page item. Carries geometry attributes and a
    # collection of TableRow children. The table's width and height are
    # typically derived from PathPointArray anchors, but rendered here
    # using the ItemTransform + a bounding-box approximation.
    class Table < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :content_type, :string
      attribute :item_transform, :string
      attribute :visible, :boolean
      attribute :fill_color, :string
      attribute :stroke_color, :string
      attribute :stroke_weight, :float
      attribute :table_row, Idml::Elements::TableRow, collection: true
      attribute :properties, Idml::Elements::Properties, collection: true

      xml do
        root "Table"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "ContentType", to: :content_type
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "Visible", to: :visible
        map_attribute "FillColor", to: :fill_color
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_element "TableRow", to: :table_row
        map_element "Properties", to: :properties
      end

      def geometric_bounds
        properties.first&.first_geometry&.bounding_box
      end
    end
  end
end
