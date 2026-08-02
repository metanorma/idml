# frozen_string_literal: true

module Idml
  module Elements
    # Typed model of `<MasterSpread>`. Declares attributes from
    # `MasterSpread_Object` in the RNC schema plus typed child-element
    # collections for page items (Page, Rectangle, TextFrame, Polygon,
    # Group, GraphicLine) — same structure as SpreadObject.
    class MasterSpreadObject < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :name_prefix, :string
      attribute :base_name, :string
      attribute :show_master_items, :boolean
      attribute :page_count, :integer
      attribute :overridden_page_item_props, :string
      attribute :primary_text_frame, :string
      attribute :item_transform, :string

      attribute :page, Idml::Elements::Page, collection: true
      attribute :rectangle, Idml::Elements::Rectangle, collection: true
      attribute :text_frame, Idml::Elements::TextFrame, collection: true
      attribute :polygon, Idml::Elements::Polygon, collection: true
      attribute :group, Idml::Elements::Group, collection: true
      attribute :graphic_line, Idml::Elements::GraphicLine, collection: true

      xml do
        root "MasterSpread"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "NamePrefix", to: :name_prefix
        map_attribute "BaseName", to: :base_name
        map_attribute "ShowMasterItems", to: :show_master_items
        map_attribute "PageCount", to: :page_count
        map_attribute "OverriddenPageItemProps", to: :overridden_page_item_props
        map_attribute "PrimaryTextFrame", to: :primary_text_frame
        map_attribute "ItemTransform", to: :item_transform
        map_element "Page", to: :page
        map_element "Rectangle", to: :rectangle
        map_element "TextFrame", to: :text_frame
        map_element "Polygon", to: :polygon
        map_element "Group", to: :group
        map_element "GraphicLine", to: :graphic_line
      end

      def each_page_item(&)
        return enum_for(:each_page_item) unless block_given?

        [page, rectangle, text_frame, polygon, group, graphic_line].each do |col|
          col.each(&)
        end
      end
    end
  end
end
