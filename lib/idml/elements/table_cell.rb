# frozen_string_literal: true

module Idml
  module Elements
    # `<TableCell>` — a single cell within a table row. Carries the
    # cell's content type and dimensions.
    class TableCell < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :column, :integer
      attribute :row, :integer
      attribute :key_value, :string

      xml do
        root "TableCell"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Column", to: :column
        map_attribute "Row", to: :row
        map_attribute "KeyValue", to: :key_value
      end
    end
  end
end
