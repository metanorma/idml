# frozen_string_literal: true

module Idml
  module Elements
    # `<Endnote>` — a story-level endnote reference. The endnote's
    # TEXT lives in a separate story flagged `IsEndnoteStory="true"`;
    # this element points at it via `EndnoteTextRange` (schema:
    # Endnote_Object in Stories/Story.rnc — Self plus the range
    # reference; no inline content). Rendering design in
    # TODO.pdf/117-endnote-support.md.
    class Endnote < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :endnote_text_range, :string

      xml do
        root "Endnote"
        map_attribute "Self", to: :self_attr
        map_attribute "EndnoteTextRange", to: :endnote_text_range
      end
    end
  end
end
