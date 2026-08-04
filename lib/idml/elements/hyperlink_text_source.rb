# frozen_string_literal: true

module Idml
  module Elements
    # `<HyperlinkTextSource>` — source anchor of a hyperlink in a
    # story. Per `HyperlinkTextSource_Object` in
    # `reference-docs/schemas/package/Stories/Story.rnc`. The `Self`
    # attribute is referenced by `<Hyperlink Source="...">` in the
    # document designmap.
    #
    # Note on text range: IDML's HyperlinkTextSource wraps the
    # character content it covers (it is a sibling of `<Content>`
    # inside a `<CharacterStyleRange>`). The wrapper's position in
    # the story flow determines the range — there is no explicit
    # `StartIndex`/`EndIndex` on the element itself.
    class HyperlinkTextSource < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :hidden, :boolean
      attribute :applied_character_style, :string

      xml do
        root "HyperlinkTextSource"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Hidden", to: :hidden
        map_attribute "AppliedCharacterStyle", to: :applied_character_style
      end
    end
  end
end
