# TODO PDF 28: Path geometry models

## Goal

Create typed element models for IDML's path geometry hierarchy:
`PathGeometry`, `GeometryPathType`, `PathPointArray`, `PathPointType`.
Wire them as children of Rectangle, TextFrame, Polygon, GraphicLine via
a `Properties` wrapper.

## Why

Page-item geometry (position, size, shape) is stored in
`Properties/PathGeometry/GeometryPathType/PathPointArray/PathPointType`.
Without modeling this, the renderer cannot determine where to place
shapes or text frames. Currently the renderer uses hardcoded positions.

## Acceptance criteria

- [ ] `Idml::Elements::PathPointType` — Anchor, LeftDirection,
      RightDirection attributes (space-separated "x y" doubles).
- [ ] `Idml::Elements::PathPointArray` — collection of PathPointType.
- [ ] `Idml::Elements::GeometryPathType` — PathOpen attribute +
      PathPointArray child.
- [ ] `Idml::Elements::PathGeometry` — collection of GeometryPathType.
- [ ] `Idml::Elements::Properties` — wrapper containing PathGeometry,
      PathBoundingBox, Label.
- [ ] Rectangle, TextFrame, Polygon, GraphicLine have `properties`
      attribute.
- [ ] Convenience method `geometric_bounds` on each page item: derives
      `[y1, x1, y2, x2]` from PathPointType anchors.
- [ ] Spec: parse fixture Rectangle, verify geometric_bounds matches
      the PathPointArray anchors.

## Files

- `lib/idml/elements/path_point_type.rb`
- `lib/idml/elements/path_point_array.rb`
- `lib/idml/elements/geometry_path_type.rb`
- `lib/idml/elements/path_geometry.rb`
- `lib/idml/elements/properties.rb`
- `lib/idml/elements/rectangle.rb` (add properties)
- `lib/idml/elements/text_frame.rb` (add properties)
- `lib/idml/elements.rb` (autoloads)

## Dependencies

- TODO 14 (page-item element models).
