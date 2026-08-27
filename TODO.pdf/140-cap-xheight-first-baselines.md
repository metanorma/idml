# TODO PDF 140: CapHeight / XHeight / EmboxHeight first baselines

## Status: COMPLETE — implemented 2026-08-27

## Problem

FirstBaselineOffset honored AscentOffset and FixedHeight (TODO 128)
but approximated CapHeight, XHeight, and EmboxHeight as leading —
text sat noticeably lower than InDesign places it.

## Solution

`TextFrameRenderer#baseline_target` now handles all five modes:

- **CapHeight** — the font's cap-height metric when the provider
  fills it; pdfrb 0.7.1 never does, so the fallback is the standard
  0.72 em proportion (Arial and Helvetica both sit within 1%).
- **XHeight** — 0.52 em (no x-height metric exists in pdfrb).
- **EmboxHeight** — the em box itself: the first paragraph's point
  size.

`PdfrbFontMetrics#cap_height` exposes the metric for when pdfrb
starts populating it.

## Files

- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/text_engine/pdfrb_font_metrics.rb`
- `spec/idml/render/first_baseline_spec.rb`
