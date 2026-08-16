# frozen_string_literal: true

module Idml
  module Elements
    # `<Footnote>` — story-embedded footnote content. Schema-faithful
    # model of `Footnote_Object` in
    # `reference-docs/schemas/package/Stories/Story.rnc`: the element
    # declares no attributes; its children are HiddenText /
    # GaijiOwnedItemObject / Table / TextVariableInstance /
    # ParagraphStyleRange / CharacterStyleRange. Of these, the
    # ParagraphStyleRange (with its CSR children) and
    # CharacterStyleRange children carry the footnote text; the rest
    # are parsed by their own models where relevant.
    #
    # A Footnote sits inside the CharacterStyleRange that owns the
    # anchor position: the body-text marker renders where the CSR's
    # text ends, and the Footnote's paragraphs render at the bottom
    # of the frame holding that marker (see Render::Footnote).
    class Footnote < Lutaml::Model::Serializable
      attribute :paragraph_style_range, Idml::Elements::ParagraphStyleRange,
                collection: true
      attribute :character_style_range, Idml::Elements::CharacterStyleRange,
                collection: true

      xml do
        root "Footnote"
        map_element "ParagraphStyleRange", to: :paragraph_style_range
        map_element "CharacterStyleRange", to: :character_style_range
      end
    end
  end
end
