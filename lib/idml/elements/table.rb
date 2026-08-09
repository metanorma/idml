# frozen_string_literal: true

module Idml
  module Elements
    # `<Table>` — a table page item. Carries geometry, body/header
    # row counts, column layout, and border styling. Two child
    # collections hold the table's content:
    #
    # - `row` — schema-faithful `<Row>` siblings (real IDML).
    # - `cell` — schema-faithful `<Cell>` siblings (real IDML).
    # - `table_row` — legacy nested `<TableRow><TableCell>` form
    #   (synthetic test fixture only; see TODO 84).
    #
    # The renderer auto-detects which layout is present.
    class Table < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :content_type, :string
      attribute :item_transform, :string
      attribute :visible, :boolean
      attribute :fill_color, :string
      attribute :stroke_color, :string
      attribute :stroke_weight, :float

      # Schema-faithful layout attributes (from Table_Object in
      # Stories/Story.rnc). The renderer consults these to compute
      # column widths and to clip body/header/footer regions.
      attribute :header_row_count, :integer
      attribute :footer_row_count, :integer
      attribute :body_row_count, :integer
      attribute :column_count, :integer
      attribute :single_column_width, :float
      attribute :table_direction, :string

      # Outer-border strokes (TopBorderStrokeWeight, etc.). Useful
      # when the renderer draws the table's bounding rectangle.
      attribute :top_border_stroke_weight, :float
      attribute :top_border_stroke_color, :string
      attribute :left_border_stroke_weight, :float
      attribute :left_border_stroke_color, :string
      attribute :bottom_border_stroke_weight, :float
      attribute :bottom_border_stroke_color, :string
      attribute :right_border_stroke_weight, :float
      attribute :right_border_stroke_color, :string

      attribute :table_row, Idml::Elements::TableRow, collection: true
      attribute :cell, Idml::Elements::Cell, collection: true
      attribute :row, Idml::Elements::Row, collection: true
      attribute :column, Idml::Elements::Column, collection: true
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
        map_attribute "HeaderRowCount", to: :header_row_count
        map_attribute "FooterRowCount", to: :footer_row_count
        map_attribute "BodyRowCount", to: :body_row_count
        map_attribute "ColumnCount", to: :column_count
        map_attribute "SingleColumnWidth", to: :single_column_width
        map_attribute "TableDirection", to: :table_direction
        map_attribute "TopBorderStrokeWeight", to: :top_border_stroke_weight
        map_attribute "TopBorderStrokeColor", to: :top_border_stroke_color
        map_attribute "LeftBorderStrokeWeight", to: :left_border_stroke_weight
        map_attribute "LeftBorderStrokeColor", to: :left_border_stroke_color
        map_attribute "BottomBorderStrokeWeight",
                      to: :bottom_border_stroke_weight
        map_attribute "BottomBorderStrokeColor",
                      to: :bottom_border_stroke_color
        map_attribute "RightBorderStrokeWeight", to: :right_border_stroke_weight
        map_attribute "RightBorderStrokeColor", to: :right_border_stroke_color
        map_element "TableRow", to: :table_row
        map_element "Cell", to: :cell
        map_element "Row", to: :row
        map_element "Column", to: :column
        map_element "Properties", to: :properties
      end

      def geometric_bounds
        @geometric_bounds ||= properties.first&.first_geometry&.bounding_box
      end
    end
  end
end
