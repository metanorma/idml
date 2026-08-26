# TODO PDF 137: Footnote text in the simple-render fallback

## Status: COMPLETE — implemented 2026-08-26

## Problem

Without FontMetrics the text renderer falls back to `simple_render`
(one `text_rich` per frame). Footnote markers rendered but the
footnote text itself was dropped entirely.

## Solution

`emit_simple_footnotes` emits after the body block: one `text_rich`
line per footnote paragraph, stacked upward from the frame's bottom
edge below a hairline separator rule (0.5pt, quarter-width — InDesign's
footnote rule proportions). Paragraphs carry their marker prefix from
extraction, so numbering reads correctly.

## Files

- `lib/idml/render/renderers/text_frame_renderer.rb`
- `spec/idml/render/simple_footnote_render_spec.rb`
