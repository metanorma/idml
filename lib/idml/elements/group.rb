# frozen_string_literal: true

module Idml
  module Elements
    # `<Group>` — a container for grouped page items. Carries an
    # `ItemTransform` and contains child page items (Rectangle,
    # TextFrame, Polygon, Group, etc.).
    class Group < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :item_transform, :string
      attribute :visible, :boolean
      attribute :rectangle, Idml::Elements::Rectangle, collection: true
      attribute :text_frame, Idml::Elements::TextFrame, collection: true
      attribute :polygon, Idml::Elements::Polygon, collection: true
      attribute :graphic_line, Idml::Elements::GraphicLine, collection: true
      attribute :group, Idml::Elements::Group, collection: true

      xml do
        root "Group"
        map_attribute "Self", to: :self_attr
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "Visible", to: :visible
        map_element "Rectangle", to: :rectangle
        map_element "TextFrame", to: :text_frame
        map_element "Polygon", to: :polygon
        map_element "GraphicLine", to: :graphic_line
        map_element "Group", to: :group
      end
    end
  end
end
