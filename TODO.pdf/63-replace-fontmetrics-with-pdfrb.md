# TODO PDF 63: Replace FontMetrics with pdfrb measurement API

## Goal

Replace `Idml::TextEngine::FontMetrics` (200+ lines of TTF binary parsing
via Fontisan) with pdfrb 0.15.0's native `Fonts#measure_text` and
`Fonts#metrics_for`. Eliminates the Fontisan dependency for text layout.

## Motivation

pdfrb 0.15.0 now provides:
- `document.fonts.measure_text(text, font:, size:)` → width in points
- `document.fonts.metrics_for(font)` → { ascent:, descent:, cap_height:, ... }

The idml gem's FontMetrics class duplicates this by parsing TTF tables
(head, hhea, hmtx, cmap) via Fontisan. The text engine (Shaper,
LineBreaker) could use pdfrb's measurement instead.

## Plan

1. Create a `PdfrbFontMetrics` adapter that implements the FontMetrics
   interface (`glyph_width`, `measure_text`, `units_per_em`, etc.) using
   pdfrb's `Fonts#measure_text` and `#metrics_for`.
2. Update `FontResolver` to return `PdfrbFontMetrics` instances.
3. Remove `fontisan` from gemspec dependencies.
4. Remove `text_engine/font_metrics.rb` (200+ lines).

## Dependencies

- pdfrb 0.15.0 (DONE — has measure_text and metrics_for)
- TODO 62 (pdfrb 0.15.0 migration — DONE)
