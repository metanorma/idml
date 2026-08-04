# frozen_string_literal: true

module Idml
  module Elements
    # `<HyperlinkPageDestination>` — target of an IDML hyperlink or
    # bookmark. The `DestinationPage` attribute references a Spread
    # Page by Self, which the renderer maps to a PDF page index.
    #
    # Attributes per `HyperlinkPageDestination_Object` in
    # `reference-docs/schemas/package/designmap.rnc`.
    class HyperlinkPageDestination < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :name_manually, :boolean
      attribute :destination_page, :string
      attribute :view_setting, :string
      attribute :view_percentage, :float
      attribute :hidden, :boolean
      attribute :destination_unique_key, :integer

      xml do
        root "HyperlinkPageDestination"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "NameManually", to: :name_manually
        map_attribute "DestinationPage", to: :destination_page
        map_attribute "ViewSetting", to: :view_setting
        map_attribute "ViewPercentage", to: :view_percentage
        map_attribute "Hidden", to: :hidden
        map_attribute "DestinationUniqueKey", to: :destination_unique_key
      end
    end
  end
end
