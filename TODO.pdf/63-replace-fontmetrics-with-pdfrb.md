# TODO PDF 63: Replace FontMetrics with pdfrb measurement API

## Status: PARTIALLY UNBLOCKED (subsetting works; measurement still AFM-only)

## Goal

Replace `Idml::TextEngine::FontMetrics` (200+ lines of TTF binary parsing
via Fontisan) with pdfrb's native `Fonts#measure_text`, `#glyph_width`,
and `#metrics_for`.

## What pdfrb 0.4.0 provides

- `Pdfrb::Font::TrueType::File` — real TTF parser with Head, Hhea,
  Cmap, Hmtx, OS2 tables.
- `Pdfrb::Font::TrueType::Subsetter` — real subsetting (TODO 52 uses
  this — DONE).
- `Fonts#glyph_width(char, resource)` — uses AFM metrics (Standard 14)
  only; returns `DEFAULT_WIDTH = 500` for TTF.
- `Fonts#measure_text(text, font:, size:)` — same: AFM or stub
  (`length * 0.5 * size`).
- `Fonts#metrics_for(resource)` — AFM metrics only.

## What still needs pdfrb work

pdfrb's TTF parser exists but is not wired to the measurement API.
`Fonts#glyph_width` reads `@afm_metrics[resource]`, which is only
populated for Standard 14 AFM fonts (Helvetica, Times, Courier,
Symbol, ZapfDingbats). For every other font (any TTF/OTF), it falls
back to the stub.

The per-glyph-width proposal asked for "Look up glyph ID from cmap,
then width from hmtx." The infrastructure is there (Cmap, Hmtx) but
the integration with `Fonts#glyph_width` is pending.

Until pdfrb's measurement API wires the TTF parser, the idml gem's
Shaper and LineBreaker must keep using Fontisan-based FontMetrics
for accurate per-glyph widths.

## Plan (after pdfrb unblocks)

1. `PdfrbWriter#register_font(path)` records the TTF bytes for
   later parsing.
2. New `PdfrbFontMetrics` adapter implements FontMetrics' interface
   by calling `pdfrb.fonts.glyph_width(font_resource, codepoint)`.
3. `FontResolver` returns `PdfrbFontMetrics` for resolved fonts.
4. Remove `text_engine/font_metrics.rb` (200+ lines).

## Acceptance criteria (after pdfrb unblocks)

- [ ] Pipeline registers fonts via `pdfrb.fonts.add(path)`.
- [ ] Shaper/LineBreaker call pdfrb's measurement API, not
      FontMetrics.
- [ ] `fontisan` removed from gemspec dependencies.
- [ ] Spec renders text and verifies line breaks land at correct
      positions for TTF fonts.

## Dependencies

- pdfrb `Fonts#glyph_width` uses parsed TTF tables, not AFM-only.
- pdfrb `Fonts#measure_text` uses parsed TTF tables.
