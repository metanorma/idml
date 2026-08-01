# frozen_string_literal: true

module Idml
  # Coordinate-transform helpers for composition operations. The IDML
  # coordinate system has its origin at the bottom-left of the spread,
  # y increasing upward; page item coordinates are spread-relative.
  # When composing two packages, source coordinates must be translated
  # into the destination's coordinate space.
  module Geometry
    Point = Struct.new(:x, :y)

    module_function

    def translate(point, by: offset(x: 0, y: 0))
      Point.new(point.x + by.x, point.y + by.y)
    end

    def offset(x:, y:)
      Point.new(x, y)
    end
  end
end
