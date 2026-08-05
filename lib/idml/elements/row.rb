# frozen_string_literal: true

module Idml
  module Elements
    # `<Row>` — a row definition in an IDML Table. Per `Row_Object`
    # in `reference-docs/schemas/package/Stories/Story.rnc`.
    #
    # Schema note: real IDML has `<Cell>` and `<Row>` as siblings
    # inside `<Table>`. This class is the schema-faithful model.
    # The legacy `Idml::Elements::TableRow` (which models the
    # non-standard `<TableRow>` element) is preserved for back-compat
    # with the existing synthetic test fixture — see TODO 84.
    #
    # Rows carry visual properties (fill, insets, minimum height)
    # but not cell content — cells live as `<Cell>` siblings.
    class Row < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :top_inset, :float
      attribute :left_inset, :float
      attribute :bottom_inset, :float
      attribute :right_inset, :float
      attribute :fill_color, :string
      attribute :fill_tint, :float
      attribute :overprint_fill, :boolean
      attribute :single_row_height, :float
      attribute :minimum_height, :float
      attribute :maximum_height, :float

      xml do
        root "Row"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "TopInset", to: :top_inset
        map_attribute "LeftInset", to: :left_inset
        map_attribute "BottomInset", to: :bottom_inset
        map_attribute "RightInset", to: :right_inset
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
        map_attribute "OverprintFill", to: :overprint_fill
        map_attribute "SingleRowHeight", to: :single_row_height
        map_attribute "MinimumHeight", to: :minimum_height
        map_attribute "MaximumHeight", to: :maximum_height
      end
    end
  end
end
