# frozen_string_literal: true

module Idml
  module Render
    # Identifies IDML gradient color references and exposes the
    # gradient catalogue from `Resources/Graphic.xml`.
    #
    # The discrete-rectangle approximation that this module used to
    # carry was removed once pdfrb 0.4.0 introduced real PDF shadings
    # (TODOs 49, 66, 68). Today the renderers go through pdfrb's
    # `Shadings#add_axial` / `add_radial` directly; this module's
    # only remaining responsibility is the predicate that distinguishes
    # gradient colour references from solid ones.
    module GradientResolver
      def self.gradient?(name)
        name.is_a?(String) && name.start_with?("Gradient/")
      end
    end
  end
end
