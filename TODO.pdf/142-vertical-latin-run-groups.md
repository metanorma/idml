# TODO PDF 142: Run-grouped Latin rotation in vertical writing

## Status: COMPLETE — implemented 2026-08-27

## Problem

In vertical (StoryOrientation="Vertical") text, every non-CJK glyph
rotated 90° individually — each Latin letter got its own rotated
graphics state and stacked one cell apart. InDesign rotates a whole
Latin run as one block (the word reads sideways as a unit).

## Solution

`TextFrameRenderer#emit_vertical_stack` partitions a vertical run's
glyphs: CJK singletons stay upright; consecutive non-CJK glyphs
(groups never span columns, x-reset on column change) render as ONE
text op inside a single rotated graphics state. The font's natural
advances land each glyph exactly where per-glyph rotation placed
it, so the change is lossless for position — but a whole word now
rotates as a unit and emits one op instead of N. The per-glyph
`emit_vertical_glyph` path is gone (dead after grouping covered it).

## Files

- `lib/idml/render/renderers/text_frame_renderer.rb`
- `spec/idml/render/vertical_render_spec.rb`
- `spec/idml/render/vertical_multirun_spec.rb`
