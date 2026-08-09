# frozen_string: true

module Idml
  module Elements
    # `<Column>` — a column definition within an IDML Table. Carries
    # the column's width (SingleColumnWidth), type (HeaderColumn /
    # BodyColumn), insets, and visual properties (fill, diagonal lines).
    #
    # Schema: `Column_Object` in
    # `reference-docs/schemas/package/Stories/Story.rnc`. Real IDML
    # tables have `<Column>` children alongside `<Row>` and `<Cell>`
    # siblings. The `Name` attribute is the column index as a string
    # (e.g., "0", "1", "2").
    #
    # The renderer's SchemaLayout reads `SingleColumnWidth` per column
    # to compute per-column x positions and widths (replaces the
    # even-division / uniform-width fallback).
    class Column < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :single_column_width, :float
      attribute :column_type, :string
      attribute :fill_color, :string
      attribute :fill_tint, :float

      xml do
        root "Column"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "SingleColumnWidth", to: :single_column_width
        map_attribute "ColumnType", to: :column_type
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
      end

      # Column Name is a string integer (e.g., "0", "1").
      # Returns the integer index or nil if Name is missing/invalid.
      def index
        return nil unless name

        Integer(name, 10, exception: false) # rubocop:disable Style/RescueModifier
      end
    end
  end
end
