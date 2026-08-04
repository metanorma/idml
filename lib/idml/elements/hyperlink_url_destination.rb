# frozen_string_literal: true

module Idml
  module Elements
    # `<HyperlinkURLDestination>` — URL target of a hyperlink.
    # Per `HyperlinkURLDestination_Object` in
    # `reference-docs/schemas/package/designmap.rnc`.
    class HyperlinkURLDestination < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :destination_url, :string
      attribute :hidden, :boolean
      attribute :destination_unique_key, :integer

      xml do
        root "HyperlinkURLDestination"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "DestinationURL", to: :destination_url
        map_attribute "Hidden", to: :hidden
        map_attribute "DestinationUniqueKey", to: :destination_unique_key
      end
    end
  end
end
