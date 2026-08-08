# TODO PDF 21: Coordinate transform utility

## Status: DONE — Centralized in `Idml::Geometry` (Y-flip + matrix math)
and `Render::Placement` (item → PDF rect, with memoized
`geometric_bounds`). All renderers use `Placement.box`. See
`lib/idml/geometry.rb`, `lib/idml/render/placement.rb`, TODO 39.

## Goal

Centralize IDML-to-PDF coordinate system conversion in a dedicated
`Idml::Geometry::CoordinateTransform` class. Currently the Y-flip logic
is scattered across `Render::Image.compute_placement` and inline code.

## Why

IDML uses a top-left origin with Y growing downward. PDF uses a
bottom-left origin with Y growing upward. This conversion is needed
for every page item (images, shapes, text). Scattering it leads to
inconsistency and bugs.

## Acceptance criteria

- [ ] `Idml::Geometry::CoordinateTransform` class.
- [ ] `transform(point)` converts an IDML (x, y) to PDF (x, y).
- [ ] `transform_bounds(bounds)` converts GeometricBounds to a PDF rectangle.
- [ ] `combine_transforms(*matrices)` multiplies ItemTransform matrices.
- [ ] All render modules use this class instead of inline math.
- [ ] Spec: known transform values produce expected PDF coordinates.

## Files

- `lib/idml/geometry.rb` (add autoload)
- `lib/idml/geometry/coordinate_transform.rb`
- `lib/idml/render/image.rb` (refactor to use CoordinateTransform)
- `spec/idml/geometry/coordinate_transform_spec.rb`

## Design notes

- The transform takes `page_height` as a parameter (for Y-flip).
- ItemTransform matrices are `a b c d e f` — 2D affine. Matrix
  multiplication combines parent + child transforms.
- The Page element's ItemTransform translates page-local to spread coords.

## Dependencies

- None (can be done independently).
