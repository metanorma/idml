# frozen_string_literal: true

module Idml
  module Elements
    # `<HyperlinkTextSource>` — source anchor of a hyperlink in a
    # story. Per `HyperlinkTextSource_Object` in
    # `reference-docs/schemas/package/Stories/Story.rnc`. The `Self`
    # attribute is referenced by `<Hyperlink Source="...">` in the
    # document designmap.
    #
    # The element wraps character content (CSR children + nested
    # HyperlinkTextSource children + Content text). `text_content`
    # walks all those children to produce the wrapped string.
    class HyperlinkTextSource < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :hidden, :boolean
      attribute :applied_character_style, :string
      attribute :character_style_range, Idml::Elements::CharacterStyleRange,
                collection: true
      attribute :hyperlink_text_source, Idml::Elements::HyperlinkTextSource,
                collection: true
      attribute :content, Idml::Elements::Content, collection: true

      xml do
        root "HyperlinkTextSource"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Hidden", to: :hidden
        map_attribute "AppliedCharacterStyle", to: :applied_character_style
        map_element "CharacterStyleRange", to: :character_style_range
        map_element "HyperlinkTextSource", to: :hyperlink_text_source
        map_element "Content", to: :content
      end

      def text_content
        parts = content.map(&:text)
        character_style_range.each { |c| parts << c.text_content }
        hyperlink_text_source.each { |nested| parts << nested.text_content }
        parts.join
      end
    end
  end
end
