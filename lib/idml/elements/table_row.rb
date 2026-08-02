# frozen_string_literal: true

module Idml
  module Elements
    # `<TableRow>` — a horizontal row within a table. Contains a
    # collection of TableCell children.
    class TableRow < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :index, :integer
      attribute :single_row_height, :float
      attribute :minimum_height, :float
      attribute :maximum_height, :float
      attribute :table_cell, Idml::Elements::TableCell, collection: true

      xml do
        root "TableRow"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Index", to: :index
        map_attribute "SingleRowHeight", to: :single_row_height
        map_attribute "MinimumHeight", to: :minimum_height
        map_attribute "MaximumHeight", to: :maximum_height
        map_element "TableCell", to: :table_cell
      end
    end
  end
end
