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

    def scale(point, by: offset(x: 1, y: 1))
      Point.new(point.x * by.x, point.y * by.y)
    end

    # Rotate `point` counterclockwise by `angle_degrees` around `around`.
    def rotate(point, angle_degrees:, around: offset(x: 0, y: 0))
      rad = angle_degrees * Math::PI / 180
      cos = Math.cos(rad)
      sin = Math.sin(rad)
      dx = point.x - around.x
      dy = point.y - around.y
      Point.new(around.x + ((dx * cos) - (dy * sin)),
                around.y + ((dx * sin) + (dy * cos)))
    end

    def offset(x:, y:)
      Point.new(x, y)
    end
  end
end
