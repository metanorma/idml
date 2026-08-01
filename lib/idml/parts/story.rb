# frozen_string_literal: true

module Idml
  module Parts
    # Typed model for `Stories/Story_*.xml`. The file's root is
    # `<idPkg:Story>` (wrapper, DOMVersion); the inner `<Story Self="...">`
    # holds the actual content. Both are typed — `inner` is a StoryInner
    # instance with full paragraph/character style run coverage.
    class Story < Lutaml::Model::Serializable
      include Idml::Part

      part_file %r{\AStories/Story_[^/]+\.xml\z}

      attribute :dom_version, :string
      attribute :inner, Idml::Elements::StoryInner

      xml do
        root "Story"
        namespace Idml::PackagingNamespace
        map_attribute "DOMVersion", to: :dom_version
        map_element "Story", to: :inner
      end

      def self_id
        inner&.self_attr
      end

      def text_content
        inner&.text_content.to_s
      end

      def each_xml_element(&)
        return enum_for(:each_xml_element) unless block_given? && inner

        inner.each_xml_element(&)
      end
    end
  end
end
