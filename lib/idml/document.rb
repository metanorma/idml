# frozen_string_literal: true

require "nokogiri"

module Idml
  # Cross-part read-only view over a Package. The Package layer stops at
  # "give me part X"; the Document layer answers questions that span
  # parts: "where is Self id `u102`?", "what's the plain text of this
  # story?", "what does the logical XML tree look like?".
  #
  # The Document does NOT own state. It delegates to Package, parses
  # XML lazily via Nokogiri, and caches parsed documents per part name
  # so repeated lookups are cheap.
  class Document
    def initialize(package)
      @package = package
      @parsed_cache = {}
    end

    attr_reader :package

    def dom_version
      @package.dom_version
    end

    # Find an element anywhere in the package by its `Self` attribute.
    # Returns a Nokogiri::XML::Node or nil. Search order: every part
    # except mimetype and META-INF/*.
    def find_by_self(self_id)
      each_parsed_part do |name, doc|
        next if non_searchable?(name)

        node = doc.at_xpath("//*[@Self='#{self_id}']")
        return node if node
      end
      nil
    end

    # Concatenate every <Content> run inside the Story with the given
    # Self attribute. Returns "" if the story is missing or empty.
    def story_text(story_self)
      each_parsed_part do |name, doc|
        next unless name.start_with?("Stories/")

        if doc.at_xpath("//*[@Self='#{story_self}']")
          return content_text(doc)
        end
      end
      ""
    end

    # Yields [self_id, text] for every Story part in the package.
    def each_story
      return enum_for(:each_story) unless block_given?

      @package.part_names.grep(%r{\AStories/}).each do |name|
        doc = parsed_part(name)
        # The file's root is `<idPkg:Story>` (wrapper, no Self). The
        # actual story content lives in the inner `<Story Self="...">`.
        story = doc.at_xpath("//*[local-name()='Story' and @Self]")
        next unless story

        yield story.attribute("Self")&.value, content_text(doc)
      end
    end

    # The logical XML structure tree (BackingStory), as a Nokogiri doc.
    # In InDesign this is what users see in the Structure panel.
    def xml_structure
      return unless @package.has_part?("XML/BackingStory.xml")

      parsed_part("XML/BackingStory.xml")
    end

    # Every <XMLElement> across every Story, with its MarkupTag.
    # Returns Array of [story_name, self_id, markup_tag] tuples.
    def tagged_elements
      result = []
      @package.part_names.grep(%r{\AStories/}).each do |name|
        doc = parsed_part(name)
        doc.xpath("//*[local-name()='XMLElement']").each do |node|
          result << [name,
                     node.attribute("Self")&.value,
                     node.attribute("MarkupTag")&.value]
        end
      end
      result
    end

    private

    def each_parsed_part
      return enum_for(:each_parsed_part) unless block_given?

      @package.part_names.each { |name| yield name, parsed_part(name) }
    end

    def parsed_part(name)
      @parsed_cache[name] ||= Nokogiri::XML(@package.read_part(name))
    end

    def content_text(doc)
      doc.xpath("//*[local-name()='Content']/text()").map(&:content).join
    end

    def non_searchable?(name)
      name == "mimetype" || name.start_with?("META-INF/")
    end
  end
end
