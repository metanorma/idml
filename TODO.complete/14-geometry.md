# TODO 14: Geometry.translate (coordinate transforms)

## Goal

Implement `Idml::Geometry.translate(point, by:)` for coordinate
transforms needed by composition operations that move page items
between packages.

## Acceptance criteria

- [ ] `Geometry.translate(point:, by:)` returns a new `[x, y]` pair
      translated by the given offset.
- [ ] Supports the IDML coordinate convention: origin at bottom-left
      of the spread, y increasing upward.
- [ ] Spec: translate a known point by a known offset, verify the
      math matches SimpleIDML's reference implementation.

## Files

- `lib/idml/geometry.rb`
- `spec/idml/geometry_spec.rb`

## Design notes

- The IDML coordinate system and how page-item coordinates map to
  spread coordinates are documented in
  `~/src/external/SimpleIDML/doc/IDML_insert_idml_coordinate_transformation.*`.
- Start with `translate` (additive offset). Future operations
  (`scale`, `rotate`) can be added as separate methods.

## Dependencies

- None (pure math).
