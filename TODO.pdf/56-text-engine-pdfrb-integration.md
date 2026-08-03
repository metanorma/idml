# TODO PDF 56: Text engine full integration with pdfrb Canvas

## Goal

Re-integrate the text engine (Shaper → LineBreaker → Justifier →
VerticalLayout) into TextFrameRenderer using pdfrb Canvas. Each line
of shaped/broken text is emitted as a separate `canvas.text` call
at the computed baseline position.

## Status: DONE

## What was implemented

TextFrameRenderer has two rendering paths:
1. **engine_render** (when FontMetrics available): shapes text via
   Shaper, breaks lines via LineBreaker at frame width, positions
   each line at decreasing baseline_y, emits `canvas.text` per line.
   Lines beyond frame bottom are skipped.
2. **simple_render** (fallback): one `canvas.text` per styled run at
   sequential y positions.

The FontMetrics comes from `context.font_resolver.resolve(family_name:)`.
On systems where the default font is available as .ttf (not .ttc), the
text engine provides proper word-wrap.

## Acceptance criteria

- [x] TextFrameRenderer tries FontResolver for metrics.
- [x] When metrics available: Shaper → LineBreaker → per-line canvas.text.
- [x] When metrics unavailable: simple one-text-per-run fallback.
- [x] Frame bounds respected (lines beyond frame bottom skipped).
- [x] Chain head check prevents duplicate text in overflow frames.
- [x] Text frame insets subtracted from frame box.
