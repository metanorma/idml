# frozen_string_literal: true

module Idml
  module Elements
    # The inner `<Story Self="...">` element wrapped by the
    # `<idPkg:Story>` file root. Carries the actual text flow content
    # (paragraph and character style runs).
    class StoryInner < Lutaml::Model::Serializable
      attribute :self_id, :string
      attribute :paragraph_style_range, Idml::Elements::ParagraphStyleRange,
                collection: true
      attribute :content, Idml::Elements::Content, collection: true
      attribute :xml_element, Idml::Elements::XmlElement, collection: true

      xml do
        root "Story"
        map_attribute "Self", to: :self_id
        map_element "ParagraphStyleRange", to: :paragraph_style_range
        map_element "Content", to: :content
        map_element "XMLElement", to: :xml_element
      end

      def text_content
        parts = content.map(&:text)
        paragraph_style_range.each { |p| parts << p.text_content }
        xml_element.each { |e| parts << e.text_content }
        parts.join
      end

      def each_xml_element(&block)
        xml_element.each { |e| e.each_xml_element(&block) }
        paragraph_style_range.each { |p| p.each_xml_element(&block) }
      end
    end
  end
end
