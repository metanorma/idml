# TODO PDF 67: Multi-run text batching via Canvas#text_rich

## Status: DONE

## What was implemented

`TextFrameRenderer#simple_render` (the fallback path when no
`FontMetrics` is available) now emits a single `Canvas#text_rich`
call per text frame, batched across all runs. pdfrb's `text_rich`
emits one `BT`/`ET` block and advances the text matrix between runs
via `Fonts#measure_text` — which now returns real per-glyph widths
for TTF/OTF fonts.

## Architecture

`TextFrameRenderer#render_text` chooses between two paths:

- **`engine_render`** — used when `context.font_metrics` is present.
  Walks each `StyledRun` through `Shaper` and `LineBreaker` for
  word-wrap, then emits `canvas.text_lines` per run.
- **`simple_render`** — fallback when metrics are absent. Builds a
  `{ text:, font:, size: }` array and emits one `canvas.text_rich`
  call. pdfrb's measurement handles run advance.

Both paths use the same `frame_box` geometry (via `Placement.box`).

## Why two paths

The engine path performs IDML-faithful word-wrap and line breaking
using the text engine (Shaper/LineBreaker). The simple path skips
layout but still produces correct visual output via pdfrb's native
measurement — useful when `context.font_metrics` is nil (e.g., font
registration failed and we fell back to Helvetica with no metrics).

As pdfrb's measurement API stabilises, a future refactor could merge
the two paths and let pdfrb handle both layout and emission.

## Verification

- `lib/idml/render/renderers/text_frame_renderer.rb:97` — `simple_render`.
- `spec/idml/render/render_pdfrb_pipeline_spec.rb` — integration
  spec verifies BT/ET emission.
- `spec/idml/render/text_frame_renderer_spec.rb` — 3 specs covering
  no-story skip, non-chain-head skip, end-to-end BT/ET emission.

## Acceptance criteria

- [x] `TextFrameRenderer#simple_render` uses `canvas.text_rich`.
- [x] Single BT/ET block per frame in fallback path.
- [x] Render spec verifies text emission end-to-end.
