# frozen_string_literal: true

module Idml
  module Elements
    # `<ParagraphStyleRange>` — block-level text run with a paragraph
    # style applied. Contains CharacterStyleRange children (the inline
    # runs) and may nest further ParagraphStyleRange.
    class ParagraphStyleRange < Lutaml::Model::Serializable
      attribute :character_style_range, Idml::Elements::CharacterStyleRange,
                collection: true
      attribute :paragraph_style_range, Idml::Elements::ParagraphStyleRange,
                collection: true
      attribute :content, Idml::Elements::Content, collection: true
      attribute :xml_element, Idml::Elements::XmlElement, collection: true

      xml do
        root "ParagraphStyleRange"
        map_element "CharacterStyleRange", to: :character_style_range
        map_element "ParagraphStyleRange", to: :paragraph_style_range
        map_element "Content", to: :content
        map_element "XMLElement", to: :xml_element
      end

      def text_content
        parts = content.map(&:text)
        character_style_range.each { |c| parts << c.text_content }
        paragraph_style_range.each { |p| parts << p.text_content }
        parts.join
      end

      def each_xml_element(&block)
        xml_element.each do |e|
          yield e
          e.each_xml_element(&block)
        end
        character_style_range.each { |c| c.each_xml_element(&block) }
        paragraph_style_range.each { |p| p.each_xml_element(&block) }
      end
    end
  end
end
