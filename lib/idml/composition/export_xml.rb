# frozen_string_literal: true

module Idml
  module Composition
    # Produce a flat XML string of the package's logical XML structure
    # tree, with text content inlined from linked Stories. Mirrors
    # SimpleIDML's `IDMLPackage.export_xml`.
    class ExportXml
      def initialize(package)
        @package = package
      end

      def call(at: nil) # rubocop:disable Lint/UnusedMethodArgument
        backing = @package.backing_story
        return "" unless backing&.xml_story&.any?

        story_text_index = build_story_text_index
        nodes = backing.xml_story.flat_map(&:xml_element)
        nodes.map { |e| serialize(e, story_text_index) }.join("\n")
      end

      private

      # Map of Story Self → concatenated text. Lazy-built.
      def build_story_text_index
        @package.stories.each_with_object({}) do |story, h|
          h[story.self_id] = story.text_content if story.self_id
        end
      end

      def serialize(element, story_text_index)
        tag = element_name(element)
        attrs = serialize_attrs(element, story_text_index)
        body = serialize_body(element, story_text_index)
        "<#{tag}#{attrs}>#{body}</#{tag}>"
      end

      def element_name(element)
        return "XMLTag" unless element.markup_tag.to_s.empty?

        element.markup_tag.to_s
      end

      def serialize_attrs(element, story_text_index)
        parts = []
        parts << %(Self="#{element.self_attr}") if element.self_attr
        if element.xml_content
          text = story_text_index[element.xml_content]
          parts << %(XMLContent="#{element.xml_content}") if text
        end
        return "" if parts.empty?

        " #{parts.join(' ')}"
      end

      def serialize_body(element, story_text_index)
        text = inline_text(element, story_text_index)
        children = element.children.map { |c| serialize(c, story_text_index) }
        [text, children].flatten.reject(&:empty?).join
      end

      def inline_text(element, story_text_index)
        text = element.text_content
        return text unless text.empty?

        element.xml_content ? story_text_index[element.xml_content].to_s : ""
      end
    end
  end
end
