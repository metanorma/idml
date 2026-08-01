# frozen_string_literal: true

require "nokogiri"

module Idml
  module Composition
    # Insert one package's structural content into another. Both
    # packages are prefixed first to avoid Self collisions; then the
    # source's BackingStory XML-structure children are appended to
    # the destination's BackingStory, and the source's Stories are
    # added to the destination's Stories/ directory.
    #
    # This is a STRUCTURAL merge: it preserves the XML structure tree
    # and the text flows. It does NOT do the full XPath-based subtree
    # slicing that SimpleIDML's insert_idml supports (deferred). See
    # TODO.complete/13-insert-idml.md for the full plan.
    class InsertIdml
      def initialize(package)
        @package = package
      end

      # `at` and `only` (XPath arguments for the future full
      # implementation) are accepted but not yet used by this
      # structural-merge version. See TODO.complete/13-insert-idml.md.
      def call(source:, at: nil, only: nil) # rubocop:disable Lint/UnusedMethodArgument
        dest_prefixed = Prefix.new(@package).call(prefix: "dest_")
        source_prefixed = Prefix.new(source).call(prefix: "src_")

        parts = dest_prefixed.each_part.to_a.to_h { |n, c| [n, c] }
        merge_backing_story!(parts, dest_prefixed, source_prefixed)
        merge_stories!(parts, dest_prefixed, source_prefixed)

        write_merged(parts)
      end

      private

      def merge_backing_story!(parts, dest, source)
        dest_xml = dest.read_part("XML/BackingStory.xml")
        source_xml = source.read_part("XML/BackingStory.xml")
        parts["XML/BackingStory.xml"] =
          BackingStoryMerger.new(dest_xml, source_xml).call
      end

      def merge_stories!(parts, _dest, source)
        source.part_names.grep(%r{\AStories/}).each do |name|
          parts[name] = source.read_part(name)
        end
      end

      def write_merged(parts)
        path = File.join(Dir.mktmpdir, "merged.idml")
        Package.write(parts: parts, to: path)
      end

      # Append source's XML structure element children into the
      # destination's BackingStory root.
      class BackingStoryMerger
        def initialize(dest_xml, source_xml)
          @dest_xml = dest_xml
          @source_xml = source_xml
        end

        def call
          dest_doc = Nokogiri::XML(@dest_xml, &:noblanks)
          source_doc = Nokogiri::XML(@source_xml, &:noblanks)
          source_doc.root.element_children.each do |child|
            dest_doc.root.add_child(child.dup)
          end
          dest_doc.to_xml
        end
      end
    end
  end
end
