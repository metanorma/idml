# frozen_string_literal: true

module Idml
  # Coordinate-transform helpers for composition operations. The IDML
  # coordinate system has its origin at the bottom-left of the spread,
  # y increasing upward; page item coordinates are spread-relative.
  # When composing two packages, source coordinates must be translated
  # into the destination's coordinate space.
  module Geometry
    Point = Struct.new(:x, :y)

    # 2D affine transform: [a, b, c, d, e, f] representing
    #   x' = a*x + c*y + e
    #   y' = b*x + d*y + f
    Transform = Struct.new(:a, :b, :c, :d, :e, :f)

    module_function

    # Parse an ItemTransform string "a b c d e f" into a Transform.
    def parse_transform(str)
      return nil unless str

      parts = str.split(/\s+/).map(&:to_f)
      return nil unless parts.length == 6

      Transform.new(*parts)
    end

    # Apply a Transform to a point [x, y], returning [x', y'].
    def apply_transform(transform, x, y)
      return [x, y] unless transform

      [(transform.a * x) + (transform.c * y) + transform.e,
       (transform.b * x) + (transform.d * y) + transform.f]
    end

    # Combine (multiply) two transforms: result = outer ∘ inner.
    def combine_transforms(outer, inner)
      return inner unless outer
      return outer unless inner

      Transform.new(
        (outer.a * inner.a) + (outer.c * inner.b),
        (outer.b * inner.a) + (outer.d * inner.b),
        (outer.a * inner.c) + (outer.c * inner.d),
        (outer.b * inner.c) + (outer.d * inner.d),
        (outer.a * inner.e) + (outer.c * inner.f) + outer.e,
        (outer.b * inner.e) + (outer.d * inner.f) + outer.f,
      )
    end

    # Transform IDML geometric_bounds [y1, x1, y2, x2] by applying
    # an optional ItemTransform. Returns new [y1, x1, y2, x2].
    def transform_bounds(bounds, transform = nil)
      return bounds unless transform && bounds

      y1, x1, y2, x2 = bounds
      x1p, y1p = apply_transform(transform, x1, y1)
      x2p, y2p = apply_transform(transform, x2, y2)
      xs = [x1p, x2p]
      ys = [y1p, y2p]
      [ys.min, xs.min, ys.max, xs.max]
    end

    # Convert IDML bounds + ItemTransform string to a PDF rect
    # with Y-axis flip. Single entry point for all renderers.
    def placement_rect(bounds, item_transform_str, page_height)
      transform = parse_transform(item_transform_str)
      transformed = transform_bounds(bounds, transform)
      bounds_to_pdf_rect(transformed, page_height)
    end

    # Convert IDML bounds [y1, x1, y2, x2] to a PDF rectangle
    # { x:, y:, width:, height: } with Y-axis flipped.
    def bounds_to_pdf_rect(bounds, page_height)
      return nil unless bounds && bounds.length == 4

      y1, x1, y2, x2 = bounds
      {
        x: x1,
        y: page_height - y2,
        width: (x2 - x1).abs,
        height: (y2 - y1).abs,
      }
    end

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
