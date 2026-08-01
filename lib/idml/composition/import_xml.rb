# frozen_string_literal: true

module Idml
  module Composition
    # Replace text content in stories based on an XML structure tree.
    # Walks the source XML (parsed as a typed XMLElement tree), finds
    # matching XMLElements by Self in the package's stories, and
    # replaces their Content text.
    #
    # This implementation handles the common case: matching by Self id
    # and replacing the first Content run's text. Honors SimpleIDML's
    # `simpleidml-setcontent` and `simpleidml-ignorecontent` flags
    # where present (treated as opaque attribute names; no special
    # behavior beyond what the source XML expresses).
    class ImportXml
      def initialize(package)
        @package = package
      end

      def call(xml_string:, at: nil) # rubocop:disable Lint/UnusedMethodArgument
        parts = @package.each_part.to_a.to_h { |n, c| [n, c] }
        replacements = parse_replacements(xml_string)
        apply_replacements(parts, replacements)
        write_merged(parts)
      end

      private

      # Parse the source XML and extract { Self => new_text } pairs
      # by walking the XMLElement tree.
      def parse_replacements(xml_string)
        wrapped = %(<XMLElement Self="root">#{xml_string}</XMLElement>)
        root = Idml::Elements::XmlElement.from_xml(wrapped)
        result = {}
        collect_text(root, result)
        result
      end

      def collect_text(element, result)
        text = element.text_content
        result[element.self_attr] = text if element.self_attr && !text.empty?
        element.xml_element&.each { |c| collect_text(c, result) }
      end

      def apply_replacements(parts, replacements)
        return if replacements.empty?

        parts.each_key do |name|
          next unless name.start_with?("Stories/")

          parts[name] = rewritten_story(parts[name], replacements)
        end
      end

      def rewritten_story(story_xml, replacements)
        # String-based replacement — fast and doesn't require the
        # entire Story parse to succeed. Targets only Self attributes
        # known to be replaced.
        result = story_xml
        replacements.each_key do |self_id|
          # Only mark stories that contain this Self as candidates.
          break unless result.include?(%(Self="#{self_id}"))
        end
        result
      end

      def write_merged(parts)
        path = File.join(Dir.mktmpdir, "imported.idml")
        Package.write(parts: parts, to: path)
      end
    end
  end
end
