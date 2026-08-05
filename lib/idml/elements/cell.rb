# frozen_string_literal: true

module Idml
  module Elements
    # `<Cell>` — a single cell in an IDML Table. Per `Cell_Object`
    # in `reference-docs/schemas/package/Stories/Story.rnc`.
    #
    # Schema note: real IDML has `<Cell>` and `<Row>` as **siblings**
    # inside `<Table>`, not nested `<TableRow><TableCell>`. This
    # class is the schema-faithful model. The legacy
    # `Idml::Elements::TableCell` (which models the non-standard
    # `<TableCell>` element) is preserved for back-compat with the
    # existing synthetic test fixture — see TODO 84.
    #
    # The cell's `Name` attribute encodes its column/row position
    # as `"col:row"` (e.g., `"0:0"`, `"1:2"`). Carries text content
    # via inline `<ParagraphStyleRange>` → `<CharacterStyleRange>`
    # → `<Content>` children, the same structure as a Story.
    class Cell < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :row_span, :integer
      attribute :column_span, :integer
      attribute :column_type, :string
      attribute :cell_type, :string
      attribute :top_inset, :float
      attribute :left_inset, :float
      attribute :bottom_inset, :float
      attribute :right_inset, :float
      attribute :fill_color, :string
      attribute :fill_tint, :float
      attribute :overprint_fill, :boolean
      attribute :clip_content_to_cell, :boolean
      attribute :vertical_justification, :string
      attribute :paragraph_spacing_limit, :float
      attribute :rotation_angle, :float
      attribute :applied_cell_style, :string
      attribute :paragraph_style_range, Idml::Elements::ParagraphStyleRange,
                collection: true

      xml do
        root "Cell"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "RowSpan", to: :row_span
        map_attribute "ColumnSpan", to: :column_span
        map_attribute "ColumnType", to: :column_type
        map_attribute "CellType", to: :cell_type
        map_attribute "TextTopInset", to: :top_inset
        map_attribute "TextLeftInset", to: :left_inset
        map_attribute "TextBottomInset", to: :bottom_inset
        map_attribute "TextRightInset", to: :right_inset
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
        map_attribute "OverprintFill", to: :overprint_fill
        map_attribute "ClipContentToTextCell", to: :clip_content_to_cell
        map_attribute "VerticalJustification", to: :vertical_justification
        map_attribute "ParagraphSpacingLimit", to: :paragraph_spacing_limit
        map_attribute "RotationAngle", to: :rotation_angle
        map_attribute "AppliedCellStyle", to: :applied_cell_style
        map_element "ParagraphStyleRange", to: :paragraph_style_range
      end

      def text_content
        paragraph_style_range.filter_map(&:text_content).join
      end

      # Cell name format is "col:row" (e.g., "0:0", "1:2").
      # Returns [col, row] integers or nil if Name is malformed.
      def col_row
        return nil unless name

        parts = name.split(":")
        return nil unless parts.length == 2

        [parts[0].to_i, parts[1].to_i]
      end
    end
  end
end
