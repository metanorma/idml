# TODO 27: Geometry scale + rotate

## Goal

Extend `Idml::Geometry` beyond translate to cover scale and rotate.
Completes the coordinate-transform toolkit composition ops need.

## Acceptance criteria

- [ ] `Geometry.scale(point, by:)` returns a new Point scaled by a factor.
- [ ] `Geometry.rotate(point, angle_degrees:, around:)` returns a new Point
      rotated by `angle_degrees` around the `around` Point.
- [ ] Specs cover identity (no-op), single-axis scale, 90°/180°/270°
      rotations, and a non-trivial rotation around an arbitrary origin.

## Files

- `lib/idml/geometry.rb`
- `spec/idml/geometry_spec.rb`

## Design notes

- IDML coordinate system: origin bottom-left of spread, y up.
- Standard math; no XML involved.

## Dependencies

- None.
