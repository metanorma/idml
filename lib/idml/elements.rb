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
    autoload :SpreadObject,         "idml/elements/spread_object"
    autoload :MasterSpreadObject,   "idml/elements/master_spread_object"
    autoload :XmlStory,             "idml/elements/xml_story"
    autoload :XmlTag,               "idml/elements/xml_tag"
    autoload :FontFamily,           "idml/elements/font_family"
    autoload :Font,                 "idml/elements/font"
    autoload :DocumentObject,       "idml/elements/document_object"
    autoload :XmlExportMap,         "idml/elements/xml_export_map"
    autoload :XmlImportMap,         "idml/elements/xml_import_map"
    autoload :Color,                "idml/elements/color"
    autoload :Tint,                 "idml/elements/tint"
    autoload :Gradient,             "idml/elements/gradient"
    autoload :Swatch,               "idml/elements/swatch"
  end
end
