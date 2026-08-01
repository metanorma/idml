# frozen_string_literal: true

module Idml
  module Elements
    # `<Content>` — text run. Appears inside CharacterStyleRange and
    # XMLElement. Carries the literal text content.
    class Content < Lutaml::Model::Serializable
      attribute :text, :string

      xml do
        root "Content"
        map_content to: :text
      end
    end
  end
end
