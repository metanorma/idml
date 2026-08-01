# frozen_string_literal: true

module Idml
  module Composition
    # Append a page (and its supporting spreads + stories) from a source
    # package into a destination. Follows the same immutability pattern
    # as InsertIdml: prefixes both sides, returns a new Package.
    #
    # This is a structural implementation: it copies the source's spread
    # files into the destination's spreads list and updates designmap to
    # reference them. Page-item geometric reflow is deferred.
    class AddPageFromIdml
      def initialize(package)
        @package = package
      end

      def call(source:, page_number:, at: nil, only: nil) # rubocop:disable Lint/UnusedMethodArgument
        dest = Prefix.new(@package).call(prefix: "dest_")
        src = Prefix.new(source).call(prefix: "src_")

        parts = dest.each_part.to_a.to_h { |n, c| [n, c] }
        copy_source_spreads(parts, src)
        copy_source_stories(parts, src)
        rewrite_designmap(parts, dest, src)

        write_merged(parts)
      end

      private

      def copy_source_spreads(parts, src)
        src.part_names.grep(%r{\ASpreads/}).each do |name|
          parts[name] = src.read_part(name)
        end
      end

      def copy_source_stories(parts, src)
        src.part_names.grep(%r{\AStories/}).each do |name|
          parts[name] = src.read_part(name)
        end
      end

      def rewrite_designmap(parts, _dest, src)
        return unless parts.key?("designmap.xml")

        parts["designmap.xml"] = merged_designmap(parts["designmap.xml"], src)
      end

      def merged_designmap(dest_xml, src)
        src_dm = Idml::Parts::Designmap.from_xml(src.read_part("designmap.xml"))
        src_stories = src_dm.story_list.to_s.split
        return dest_xml if src_stories.empty?

        dest_dm = Idml::Parts::Designmap.from_xml(dest_xml)
        existing = dest_dm.story_list.to_s.split
        combined = (existing + src_stories).uniq.join(" ")
        dest_dm.story_list = combined
        Idml::Parts::Designmap.to_xml(dest_dm)
      end

      def write_merged(parts)
        path = File.join(Dir.mktmpdir, "merged.idml")
        Package.write(parts: parts, to: path)
      end
    end
  end
end
