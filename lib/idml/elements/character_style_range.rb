# frozen_string_literal: true

module Idml
  module Elements
    # `<CharacterStyleRange>` — inline run of text with a single
    # character style applied. Contains Content (the text) and may
    # contain nested XMLElement (tagged inline content) or further
    # CharacterStyleRange (style overrides).
    class CharacterStyleRange < Lutaml::Model::Serializable
      attribute :content, Idml::Elements::Content, collection: true
      attribute :xml_element, Idml::Elements::XmlElement, collection: true
      attribute :character_style_range, Idml::Elements::CharacterStyleRange,
                collection: true

      xml do
        root "CharacterStyleRange"
        map_element "Content", to: :content
        map_element "XMLElement", to: :xml_element
        map_element "CharacterStyleRange", to: :character_style_range
      end

      def text_content
        parts = content.map(&:text)
        character_style_range.each { |c| parts << c.text_content }
        parts.join
      end

      def each_xml_element(&block)
        xml_element.each do |e|
          yield e
          e.each_xml_element(&block)
        end
        character_style_range.each { |c| c.each_xml_element(&block) }
      end
    end
  end
end
