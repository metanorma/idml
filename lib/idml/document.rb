# frozen_string_literal: true

require "rexml/document"

module Idml
  # Cross-part read-only view over a Package. The Package layer stops at
  # "give me part X"; the Document layer answers questions that span
  # parts: "where is Self id `u102`?", "what's the plain text of this
  # story?", "what does the logical XML tree look like?".
  #
  # The Document does NOT own state. It delegates to Package, parses
  # XML lazily via REXML (stdlib — no Nokogiri), and caches parsed
  # documents per part name so repeated lookups are cheap.
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
    # Returns a REXML::Element or nil. Search order: every part
    # except mimetype and META-INF/*.
    def find_by_self(self_id)
      each_parsed_part do |name, doc|
        next if non_searchable?(name)

        found = find_self_recursive(doc.root, self_id)
        return found if found
      end
      nil
    end

    # Concatenate every <Content> run inside the Story with the given
    # Self attribute. Returns "" if the story is missing or empty.
    def story_text(story_self)
      each_parsed_part do |name, doc|
        next unless name.start_with?("Stories/")

        story = find_first_child_named(doc.root, "Story")
        next unless story&.attribute("Self")&.value == story_self

        return content_text(doc.root)
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
        story = find_first_child_named(doc.root, "Story")
        next unless story&.attribute("Self")

        yield story.attribute("Self").value, content_text(doc.root)
      end
    end

    # The logical XML structure tree (BackingStory), as a REXML document.
    # In InDesign this is what users see in the Structure panel.
    def xml_structure
      return unless @package.has_part?("XML/BackingStory.xml")

      parsed_part("XML/BackingStory.xml")
    end

    def tagged_elements
      story_part_names.each_with_object([]) do |name, acc|
        doc = parsed_part(name)
        next unless doc&.root

        acc.concat(tagged_in(doc.root))
      end
    end

    private

    def each_parsed_part
      return enum_for(:each_parsed_part) unless block_given?

      @package.part_names.each do |name|
        next if non_searchable?(name)

        yield name, parsed_part(name)
      end
    end

    def parsed_part(name)
      return @parsed_cache[name] if @parsed_cache.key?(name)
      return @parsed_cache[name] = nil if non_searchable?(name)

      @parsed_cache[name] = REXML::Document.new(@package.read_part(name))
    end

    def content_text(root)
      texts = []
      root.each_recursive do |node|
        next unless node.name == "Content"

        texts << node.text.to_s
      end
      texts.join
    end

    def find_self_recursive(element, target_id)
      return nil unless element.is_a?(REXML::Element)

      return element if element.attribute("Self")&.value == target_id

      element.each_recursive do |node|
        return node if node.attribute("Self")&.value == target_id
      end
      nil
    end

    def find_first_child_named(root, name)
      found = nil
      root.each_recursive do |el|
        next unless el.name == name

        found = el
        break
      end
      found
    end

    def story_part_names
      @package.part_names.grep(%r{\AStories/})
    end

    def tagged_in(root)
      tuples = []
      root.each_recursive do |node|
        next unless node.name == "XMLElement"

        tuples << [node.attribute("Self")&.value,
                   node.attribute("MarkupTag")&.value]
      end
      tuples
    end

    def non_searchable?(name)
      name == "mimetype" || name.start_with?("META-INF/")
    end
  end
end
