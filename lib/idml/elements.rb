# frozen_string_literal: true

module Idml
  # Typed models for IDML elements that appear inside parts. Every
  # element we need to query or manipulate has a typed class here so
  # the gem stays fully model-driven — no ad-hoc XML libraries.
  module Elements
    autoload :Content,              "idml/elements/content"
    autoload :XmlElement,           "idml/elements/xml_element"
    autoload :CharacterStyleRange,  "idml/elements/character_style_range"
    autoload :ParagraphStyleRange,  "idml/elements/paragraph_style_range"
    autoload :StoryInner,           "idml/elements/story_inner"
  end
end
