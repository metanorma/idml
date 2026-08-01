# frozen_string_literal: true

module Idml
  # Cross-part read-only view over a Package. The Package layer stops at
  # "give me part X"; the Document layer answers questions that span
  # parts. Every query routes through typed model methods on the parts
  # — no ad-hoc XML libraries.
  class Document
    def initialize(package)
      @package = package
    end

    attr_reader :package

    def dom_version
      @package.dom_version
    end

    # Locate the part that contains the given Self id. Returns the
    # part name (e.g., "Stories/Story_u164.xml") or nil. String-based
    # search — works for any Self on any element, regardless of typed
    # coverage.
    def find_by_self(self_id)
      pattern = %(Self="#{self_id}")
      @package.part_names.each do |name|
        next if non_searchable?(name)

        return name if @package.read_part(name).include?(pattern)
      end
      nil
    end

    def story_text(story_self)
      story = stories_by_self[story_self]
      story ? story.text_content : ""
    end

    def each_story
      return enum_for(:each_story) unless block_given?

      @package.stories.each do |story|
        yield story.self_id, story.text_content
      end
    end

    def xml_structure
      @package.backing_story
    end

    def tagged_elements
      tagged_in_stories + tagged_in_backing_story
    end

    private

    def stories_by_self
      @stories_by_self ||= @package.stories.each_with_object({}) do |s, h|
        h[s.self_id] = s if s.self_id
      end
    end

    def tagged_in_stories
      @package.stories.flat_map do |story|
        story.each_xml_element.map do |element|
          ["Stories/#{story.self_id}.xml", element.self_id, element.markup_tag]
        end
      end
    end

    def tagged_in_backing_story
      backing = @package.backing_story
      return [] unless backing

      backing.xml_element.flat_map do |root|
        root.each_xml_element.map do |element|
          ["XML/BackingStory.xml", element.self_id, element.markup_tag]
        end
      end
    end

    def non_searchable?(name)
      name == "mimetype" || name.start_with?("META-INF/")
    end
  end
end
