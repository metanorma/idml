# TODO PDF 30: Shape geometry rendering

## Goal

Render Rectangle, Polygon, and GraphicLine shapes using their actual
PathGeometry — not hardcoded 100×100 rectangles. Apply ItemTransform
and fill/stroke colors.

## Why

Currently `render_rectangle` emits a fixed `0 0 100 100 re` regardless
of the actual shape bounds. Real shapes have arbitrary positions and
sizes derived from PathPointArray anchors.

## Acceptance criteria

- [ ] Rectangle: derive bounds from PathPointType anchors, emit `re`
      operator with correct x/y/width/height.
- [ ] Polygon: emit `m`/`l` path operators from PathPointArray.
- [ ] GraphicLine: emit open path with stroke.
- [ ] ItemTransform applied via `cm` operator.
- [ ] FillColor resolved via ColorResolver, emitted as `rg`/`k`.
- [ ] StrokeColor + StrokeWeight emitted as `RG`/`K` + `w` + `S`.
- [ ] Coordinate Y-flip applied (IDML top-left → PDF bottom-left origin).
- [ ] Spec: render a Rectangle with known PathGeometry, verify PDF
      contains `re` with correct coordinates.

## Files

- `lib/idml/render/renderers/rectangle_renderer.rb`
- `lib/idml/render/renderers/polygon_renderer.rb`
- `lib/idml/render/renderers/graphic_line_renderer.rb`
- `lib/idml/render/coordinate_transform.rb`
- `spec/idml/render/shape_geometry_spec.rb`

## Dependencies

- TODO 26 (renderer registry).
- TODO 28 (path geometry models).
- TODO 22 (ColorResolver).
