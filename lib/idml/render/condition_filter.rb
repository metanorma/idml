# frozen_string: true

module Idml
  module Render
    # Resolves whether a styled run should render based on its
    # AppliedConditions and the visibility flags declared on the
    # corresponding `<Condition>` elements in `designmap.xml`.
    #
    # A run is visible when either:
    # - It has no AppliedConditions (the common case), OR
    # - Every condition it references is itself Visible.
    #
    # A run is hidden when ANY referenced condition is hidden. This
    # matches InDesign's "hide any text the user has toggled off"
    # semantics.
    #
    # Construction: `ConditionFilter.from_designmap(designmap)`
    # reads the condition collection and indexes by Self. Use
    # `filter.visible?(applied_conditions_string)` per run; pass nil
    # or empty string for untagged runs.
    class ConditionFilter
      def self.from_designmap(designmap)
        conditions = designmap ? designmap.condition : []
        new(conditions)
      end

      def initialize(conditions)
        @visibility_by_self = conditions.to_h do |cond|
          [cond.self_attr, condition_visible?(cond)]
        end
      end

      # `applied_conditions` is the raw PSR/CSR string. IDML encodes
      # it as a space-separated list of condition Self IDs. Returns
      # true when the run should render.
      def visible?(applied_conditions)
        return true if applied_conditions.nil?
        return true if applied_conditions.strip.empty?

        applied_conditions.split.uniq.all? do |cond_self|
          condition_visible?(cond_self)
        end
      end

      private

      # A condition is visible when explicitly Visible="true" OR when
      # the Visibility flag is unset (default true). Only an explicit
      # Visible="false" hides it.
      def condition_visible?(cond_or_self)
        return @visibility_by_self.fetch(cond_or_self, true) if cond_or_self.is_a?(String)

        cond_or_self.visible.nil? || cond_or_self.visible
      end
    end
  end
end
