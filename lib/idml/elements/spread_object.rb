# frozen_string_literal: true

module Idml
  module Elements
    # Typed model of `<Spread>`. Every attribute from `Spread_Object`
    # in `reference-docs/schemas/package/Spreads/Spread.rnc` is declared,
    # plus typed child-element collections for the page items the
    # renderer needs: Page, Rectangle, TextFrame, Polygon, Group,
    # GraphicLine. Child-element order is preserved via `ordered`.
    class SpreadObject < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :page_transition_type, :string
      attribute :page_transition_direction, :string
      attribute :page_transition_duration, :string
      attribute :show_master_items, :boolean
      attribute :page_count, :integer
      attribute :binding_location, :integer
      attribute :spread_hidden, :boolean
      attribute :allow_page_shuffle, :boolean
      attribute :item_transform, :string
      attribute :flattener_override, :string

      attribute :page, Idml::Elements::Page, collection: true
      attribute :rectangle, Idml::Elements::Rectangle, collection: true
      attribute :oval, Idml::Elements::Oval, collection: true
      attribute :path, Idml::Elements::Path, collection: true
      attribute :text_frame, Idml::Elements::TextFrame, collection: true
      attribute :polygon, Idml::Elements::Polygon, collection: true
      attribute :group, Idml::Elements::Group, collection: true
      attribute :graphic_line, Idml::Elements::GraphicLine, collection: true
      attribute :table, Idml::Elements::Table, collection: true

      xml do
        root "Spread"
        map_attribute "Self", to: :self_attr
        map_attribute "PageTransitionType", to: :page_transition_type
        map_attribute "PageTransitionDirection", to: :page_transition_direction
        map_attribute "PageTransitionDuration", to: :page_transition_duration
        map_attribute "ShowMasterItems", to: :show_master_items
        map_attribute "PageCount", to: :page_count
        map_attribute "BindingLocation", to: :binding_location
        map_attribute "SpreadHidden", to: :spread_hidden
        map_attribute "AllowPageShuffle", to: :allow_page_shuffle
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "FlattenerOverride", to: :flattener_override
        map_element "Page", to: :page
        map_element "Rectangle", to: :rectangle
        map_element "Oval", to: :oval
        map_element "Path", to: :path
        map_element "TextFrame", to: :text_frame
        map_element "Polygon", to: :polygon
        map_element "Group", to: :group
        map_element "GraphicLine", to: :graphic_line
        map_element "Table", to: :table
      end

      def each_page_item(&)
        return enum_for(:each_page_item) unless block_given?

        page_item_collections.each { |col| col.each(&) }
      end

      def page_item_collections
        [page, rectangle, text_frame, polygon, group, graphic_line, table]
      end
    end
  end
end
