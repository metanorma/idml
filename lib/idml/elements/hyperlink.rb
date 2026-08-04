# frozen_string_literal: true

module Idml
  module Elements
    # `<Hyperlink>` — connects a hyperlink source to a destination.
    # Per `Hyperlink_Object` in
    # `reference-docs/schemas/package/designmap.rnc`.
    class Hyperlink < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :source, :string
      attribute :destination, :string
      attribute :visible, :boolean
      attribute :hidden, :boolean

      xml do
        root "Hyperlink"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "Source", to: :source
        map_attribute "Destination", to: :destination
        map_attribute "Visible", to: :visible
        map_attribute "Hidden", to: :hidden
      end
    end
  end
end
