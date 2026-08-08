# frozen_string_literal: true

module Idml
  module Elements
    # `<TableCell>` — a single cell within a table row. Carries the
    # cell's content type, dimensions, and any inline text content
    # (`<CharacterStyleRange>` children that carry the cell's text).
    #
    # IDML's actual schema (`Cell_Object` in
    # `reference-docs/schemas/package/Stories/Story.rnc`) names this
    # element `Cell` and includes many more attributes; this model
    # captures the subset the renderer needs today.
    class TableCell < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :column, :integer
      attribute :row, :integer
      attribute :cell_key_value, :string
      attribute :character_style_range, Idml::Elements::CharacterStyleRange,
                collection: true

      xml do
        root "TableCell"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Column", to: :column
        map_attribute "Row", to: :row
        map_attribute "KeyValue", to: :cell_key_value
        map_element "CharacterStyleRange", to: :character_style_range
      end

      def text_content
        character_style_range.filter_map(&:text_content).join
      end
    end
  end
end
