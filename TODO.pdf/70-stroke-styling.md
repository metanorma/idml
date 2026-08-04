# TODO PDF 70: Stroke styling — line cap, join, dash patterns

## Status: DONE (implemented as TODO 72)

## What was implemented

See [TODO 72](72-stroke-styling.md) for the full implementation
details. Highlights:

- New `Render::StrokeStyle` module with `strokeable?` predicate and
  `apply(canvas, item) { ... }` block-wrapper.
- Element models `Rectangle`, `Polygon`, `GraphicLine` gained
  `end_cap`, `end_join`, `miter_limit`, `stroke_dash_and_gap`
  attributes per the RNC schema.
- Each renderer's stroke path routes through `StrokeStyle.apply`,
  which maps IDML enums to PDF line cap/join codes and emits
  `dash_pattern` from the `StrokeDashAndGap` list.
- 13 dedicated specs in `spec/idml/render/stroke_style_spec.rb`.

## Acceptance criteria

- [x] Dashed strokes render with correct dash array.
- [x] Round/miter/bevel joins produce matching PDF output.
- [x] Round/butt/projecting caps produce matching PDF output.
- [x] Plain strokes (no style attrs) render exactly as before.
- [x] Spec covers dashed, round-join, round-cap, and pass-through cases.

## Dependencies

- pdfrb 0.4.0 `line_cap=`, `line_join=`, `miter_limit=`, `dash_pattern=`
  (DONE).
- IDML element models for stroke styles (DONE).
