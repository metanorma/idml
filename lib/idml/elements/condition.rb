# frozen_string: true

module Idml
  module Elements
    # `<Condition>` — a single condition declared in `designmap.xml`.
    # Authors tag text runs with one or more conditions (the CSR's
    # `AppliedConditions` attribute is a list of condition Self IDs).
    # The condition's `Visible` flag controls whether tagged text
    # appears in the rendered output.
    #
    # Schema: `Condition_Object` in
    # `reference-docs/schemas/package/designmap.rnc`.
    class Condition < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :indicator_method, :string
      attribute :underline_indicator_appearance, :string
      attribute :visible, :boolean, default: true

      xml do
        root "Condition"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "IndicatorMethod", to: :indicator_method
        map_attribute "UnderlineIndicatorAppearance",
                      to: :underline_indicator_appearance
        map_attribute "Visible", to: :visible
      end
    end
  end
end
