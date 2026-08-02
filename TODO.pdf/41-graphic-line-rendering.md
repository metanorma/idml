# TODO PDF 41: GraphicLine rendering

## Goal

Implement `GraphicLineRenderer` to render IDML `<GraphicLine>` elements as
stroked PDF paths using PathPointArray vertices.

## Acceptance criteria

- [ ] GraphicLineRenderer emits `m` (move) + `l` (line-to) operators.
- [ ] StrokeColor resolved via ColorResolver.
- [ ] StrokeWeight applied via `Path.stroke_width`.
- [ ] ItemTransform applied to path coordinates.
- [ ] Y-axis flip via `Geometry.bounds_to_pdf_rect`.
- [ ] Spec: render a GraphicLine with known endpoints, verify `m`/`l`/`S` in PDF.

## Dependencies

- TODO 28 (PathGeometry models).
- TODO 31 (stroke rendering).
