# TODO PDF 70: Stroke styling — line cap, join, dash patterns

## Status: PLANNED (not started)

## Goal

Honor IDML stroke styling attributes by routing through pdfrb 0.4.0's
stroke-style Canvas setters:

- `line_width=` (already used — TODO 31)
- `line_cap=` — RoundButt/RoundJoin cap shape
- `line_join=` — miter/round/bevel corner joining
- `miter_limit=` — clamps spikes on sharp angles
- `dash_pattern=` — dashed/dotted stroke styles

## Background

pdfrb 0.4.0 exposes the full PDF graphics-state stroke suite. IDML
exposes the matching attributes through `<DashedStrokeStyle>` and
`<DottedStrokeStyle>` elements in `Resources/Graphic.xml`, plus
per-item `StrokeColor`/`StrokeWeight` (already handled).

IDML → PDF stroke mapping:

| IDML                                | PDF                       |
|-------------------------------------|---------------------------|
| `EndCap="RoundCap"`                 | `line_cap = 1` (Round)    |
| `EndCap="ButtCap"`                  | `line_cap = 0` (Butt)     |
| `EndCap="ProjectingCap"`            | `line_cap = 2` (Square)   |
| `Join="RoundJoin"`                  | `line_join = 1`           |
| `Join="MiterJoin"`                  | `line_join = 0`           |
| `Join="BevelJoin"`                  | `line_join = 2`           |
| `<DashedStrokeStyle DashArray="...">` | `dash_pattern = [arr, 0]` |
| `<DottedStrokeStyle DotArray="...">`  | `dash_pattern = [arr, 0]` (dots are short dashes) |

## Plan

1. `Parts::Graphic` already exposes `dashed_stroke_style` and
   `dotted_stroke_style` collections — add accessors on the renderer
   context.
2. New `Render::StrokeStyle` helper that resolves an
   `Elements::DashedStrokeStyle` / `DottedStrokeStyle` (or stroke-style
   self-id reference on the item) to a `{ line_cap:, line_join:,
   miter_limit:, dash_pattern: }` hash.
3. Each stroke renderer (Rectangle, Polygon, GraphicLine) calls
   `StrokeStyle.apply(canvas, item, context)` before `canvas.stroke`.

## Acceptance criteria

- [ ] Dashed strokes render with correct dash array.
- [ ] Dotted strokes render as zero-length dashes with round caps.
- [ ] Round/miter/bevel joins produce matching PDF output.
- [ ] Plain strokes (no style) render exactly as before.
- [ ] Spec covers dashed, dotted, round-join, and pass-through cases.

## Dependencies

- pdfrb 0.4.0 `line_cap=`, `line_join=`, `miter_limit=`, `dash_pattern=`
  (DONE — all confirmed in pdfrb 0.4.0).
- IDML element models for stroke styles (DONE — already generated from RNC).
