# TODO PDF 72: Stroke styling — cap, join, miter, dash

## Status: DONE

## What was implemented

Honors IDML stroke-style attributes by routing through pdfrb 0.4.0's
stroke-style Canvas setters:

- `line_cap=` — from IDML `EndCap` (ButtEndCap/RoundEndCap/ProjectingEndCap)
- `line_join=` — from IDML `EndJoin` (MiterEndJoin/RoundEndJoin/BevelEndJoin)
- `miter_limit=` — from IDML `MiterLimit` (ignored when < 1.0)
- `dash_pattern=` — from IDML `StrokeDashAndGap` flat list

New module `Idml::Render::StrokeStyle` exposes:

- `StrokeStyle.strokeable?(item)` — predicate (replaces the per-renderer
  `RectangleRenderer.strokeable?`). Returns a real boolean, not the
  `nil`/value chain Ruby `&&` would produce.
- `StrokeStyle.apply(canvas, item) { ... }` — saves graphics state,
  applies all four style attributes (only those present on the item),
  yields, restores. Scoping prevents cap/join/miter/dash from leaking
  into subsequent strokes on the same page.

Element models `Rectangle`, `Polygon`, `GraphicLine` each gained four
new typed attributes from the RNC schema:

- `end_cap` (`EndCap_EnumValue`)
- `end_join` (`EndJoin_EnumValue`)
- `miter_limit` (`xsd:double`)
- `stroke_dash_and_gap` (`list { xsd:double * }`)

Each renderer's `render_stroke` (or main `render` for GraphicLine)
calls `StrokeStyle.apply(canvas, item) { ... build path ... stroke }`
inside the existing `Blending.wrap`.

## IDML → PDF enum map

| IDML                | PDF code |
|---------------------|----------|
| ButtEndCap          | 0        |
| RoundEndCap         | 1        |
| ProjectingEndCap    | 2        |
| MiterEndJoin        | 0        |
| RoundEndJoin        | 1        |
| BevelEndJoin        | 2        |

## Acceptance criteria

- [x] All four stroke-style setters invoked when their IDML attrs present.
- [x] Items without stroke-style attrs render exactly as before.
- [x] `StrokeStyle.apply` saves/restores graphics state.
- [x] Spec covers all four setters, miter_limit clamp, dash array parse,
      no-attrs pass-through, and `strokeable?` truth table (13 specs).
- [x] `bundle exec rake` green.
