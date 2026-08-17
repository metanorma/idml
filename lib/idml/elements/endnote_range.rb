# frozen_string_literal: true

module Idml
  module Elements
    # `<EndnoteRange>` — marks the text range in the main story that
    # an endnote references, linking back via `SourceEndnote`
    # (schema: EndnoteRange_Object in Stories/Story.rnc). Pairs with
    # Elements::Endnote; rendering design in
    # TODO.pdf/117-endnote-support.md.
    class EndnoteRange < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :source_endnote, :string

      xml do
        root "EndnoteRange"
        map_attribute "Self", to: :self_attr
        map_attribute "SourceEndnote", to: :source_endnote
      end
    end
  end
end
