# frozen_string_literal: true

module Idml
  # Coordinate-transform helpers for composition operations. The IDML
  # coordinate system has its origin at the bottom-left of the spread,
  # y increasing upward; page item coordinates are spread-relative.
  # When composing two packages, source coordinates must be translated
  # into the destination's coordinate space.
  #
  # Future implementation will port SimpleIDML's algorithm documented
  # at SimpleIDML/doc/IDML_insert_idml_coordinate_transformation.*.
  module Geometry
    module_function

    def translate(point, by:)
      raise NotImplementedError,
            "Geometry.translate is not yet implemented; " \
            "see TODO.complete/10-composition.md"
    end
  end
end
