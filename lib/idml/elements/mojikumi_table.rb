# frozen_string_literal: true

module Idml
  module Elements
    # One aki override (per `OverrideMojikumiAkiType_TypeDef`):
    # spacing between the Target and Side character classes, as
    # minimum / desired / maximum.
    class OverrideMojikumiAki < Lutaml::Model::Serializable
      attribute :target_mojikumi_class, :integer
      attribute :side_mojikumi_class, :integer
      attribute :side_is_after_target, :boolean
      attribute :minimum, :float
      attribute :desired, :float
      attribute :maximum, :float
      attribute :compression_priority, :integer
      attribute :aki_does_not_float, :boolean

      xml do
        root "OverrideMojikumiAkiType"
        map_attribute "TargetMojikumiClass", to: :target_mojikumi_class
        map_attribute "SideMojikumiClass", to: :side_mojikumi_class
        map_attribute "SideIsAfterTarget", to: :side_is_after_target
        map_attribute "Minimum", to: :minimum
        map_attribute "Desired", to: :desired
        map_attribute "Maximum", to: :maximum
        map_attribute "CompressionPriority", to: :compression_priority
        map_attribute "AkiDoesNotFloat", to: :aki_does_not_float
      end
    end

    # `<OverrideMojikumiAkiList>` — the per-class-pair override
    # entries of a named mojikumi set.
    class OverrideMojikumiAkiList < Lutaml::Model::Serializable
      attribute :override_mojikumi_aki, OverrideMojikumiAki,
                collection: true

      xml do
        root "OverrideMojikumiAkiList"
        map_element "OverrideMojikumiAkiType",
                    to: :override_mojikumi_aki
      end
    end

    # `<Properties>` inside a MojikumiTable — carries the aki
    # override list.
    class MojikumiTableProperties < Lutaml::Model::Serializable
      attribute :override_mojikumi_aki_list, OverrideMojikumiAkiList,
                collection: true

      xml do
        root "Properties"
        map_element "OverrideMojikumiAkiList",
                    to: :override_mojikumi_aki_list
      end
    end

    # Typed model of `<MojikumiTable>` (TODO 144) — a named
    # mojikumi set declared at the designmap level. Named sets are
    # modeled (parsed and round-tripped) but not yet APPLIED: the
    # renderer keeps using the built-in class-based aki rules (see
    # TODO.pdf/61).
    class MojikumiTable < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :name, :string
      attribute :based_on_mojikumi_set, :string
      attribute :properties, MojikumiTableProperties, collection: true

      xml do
        root "MojikumiTable"
        map_attribute "Self", to: :self_attr
        map_attribute "Name", to: :name
        map_attribute "BasedOnMojikumiSet", to: :based_on_mojikumi_set
        map_element "Properties", to: :properties
      end

      # Aki overrides in document order, flattened across the
      # Properties > OverrideMojikumiAkiList chain.
      def aki_overrides
        properties.flat_map do |prop|
          prop.override_mojikumi_aki_list.flat_map(&:override_mojikumi_aki)
        end
      end
    end
  end
end
