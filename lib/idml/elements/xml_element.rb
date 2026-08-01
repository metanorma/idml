# frozen_string_literal: true

module Idml
  module Elements
    # `<XMLElement>` — a node in the document's logical XML structure
    # tree (the Structure panel in InDesign). Self is the unique id;
    # MarkupTag is the XML tag name applied; XMLContent is a cross-
    # reference to a Story that holds the element's text flow. Children
    # form the recursive tree.
    class XmlElement < Lutaml::Model::Serializable
      attribute :self_id, :string
      attribute :markup_tag, :string
      attribute :xml_content, :string
      attribute :children, Idml::Elements::XmlElement, collection: true
      attribute :content, Idml::Elements::Content, collection: true

      xml do
        root "XMLElement"
        map_attribute "Self", to: :self_id
        map_attribute "MarkupTag", to: :markup_tag
        map_attribute "XMLContent", to: :xml_content
        map_element "XMLElement", to: :children
        map_element "Content", to: :content
      end
    end
  end
end
