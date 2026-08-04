# frozen_string_literal: true

module Idml
  module Elements
    # `<Bookmark>` — IDML bookmark element. References a
    # `<HyperlinkPageDestination>` (or similar) by Self via the
    # `Destination` attribute. The destination carries the actual
    # page+viewpoint target.
    #
    # Attributes per `Bookmark_Object` in
    # `reference-docs/schemas/package/designmap.rnc`.
    class Bookmark < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :destination, :string

      xml do
        root "Bookmark"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Destination", to: :destination
      end
    end
  end
end
