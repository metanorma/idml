# frozen_string_literal: true

module Idml
  module Composition
    # Insert one package's structural content into another. Both
    # packages are prefixed first to avoid Self collisions; then the
    # source's BackingStory XMLElement tree is appended to the
    # destination's, and the source's Stories are added to the
    # destination's package. The merge goes through the typed
    # BackingStory model — no ad-hoc XML libraries.
    class InsertIdml
      def initialize(package)
        @package = package
      end

      def call(source:)
        dest_prefixed = Prefix.new(@package).call(prefix: "dest_")
        source_prefixed = Prefix.new(source).call(prefix: "src_")

        parts = dest_prefixed.each_part.to_a.to_h { |n, c| [n, c] }
        merge_backing_story!(parts, dest_prefixed, source_prefixed)
        merge_stories!(parts, source_prefixed)
        merge_spreads!(parts, source_prefixed)
        rewrite_designmap!(parts, source_prefixed)

        write_merged(parts)
      end

      private

      def merge_backing_story!(parts, dest, source)
        dest_xml = dest.read_part("XML/BackingStory.xml")
        source_xml = source.read_part("XML/BackingStory.xml")
        parts["XML/BackingStory.xml"] =
          BackingStoryMerger.new(dest_xml, source_xml).call
      end

      def merge_stories!(parts, source)
        source.part_names.grep(%r{\AStories/}).each do |name|
          parts[name] = source.read_part(name)
        end
      end

      def merge_spreads!(parts, source)
        source.part_names.grep(%r{\ASpreads/}).each do |name|
          parts[name] = source.read_part(name)
        end
        source.part_names.grep(%r{\AMasterSpreads/}).each do |name|
          parts[name] = source.read_part(name)
        end
      end

      def rewrite_designmap!(parts, source)
        return unless parts.key?("designmap.xml")

        parts["designmap.xml"] =
          merged_designmap(parts["designmap.xml"], source)
      end

      def merged_designmap(dest_xml, source)
        src_dm = Idml::Parts::Designmap.from_xml(source.read_part("designmap.xml"))
        src_stories = src_dm.story_list.to_s.split
        return dest_xml if src_stories.empty?

        dest_dm = Idml::Parts::Designmap.from_xml(dest_xml)
        existing = dest_dm.story_list.to_s.split
        dest_dm.story_list = (existing + src_stories).uniq.join(" ")
        Idml::Parts::Designmap.to_xml(dest_dm)
      end

      def write_merged(parts)
        path = File.join(Dir.mktmpdir, "merged.idml")
        Package.write(parts: parts, to: path)
      end

      # Append source's XMLElement children to dest's BackingStory via
      # the typed BackingStory model.
      class BackingStoryMerger
        def initialize(dest_xml, source_xml)
          @dest_xml = dest_xml
          @source_xml = source_xml
        end

        def call
          dest = Idml::Parts::BackingStory.from_xml(@dest_xml)
          source = Idml::Parts::BackingStory.from_xml(@source_xml)
          source.xml_story.each { |story| dest.xml_story << story }
          Idml::Parts::BackingStory.to_xml(dest)
        end
      end
    end
  end
end
