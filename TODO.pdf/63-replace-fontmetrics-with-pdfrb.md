# TODO PDF 63: Replace FontMetrics with pdfrb measurement API

## Status: DONE

## What was implemented

`Idml::TextEngine::FontMetrics` (200+ lines of TTF binary parsing via
Fontisan) and `Idml::TextEngine::FontResolver` have been removed. In
their place:

- **`Idml::TextEngine::PdfrbFontMetrics`** — adapter that exposes
  the same measurement surface (`glyph_width`, `measure_text`,
  `units_per_em`, `ascent`, `descent`) by delegating to pdfrb's
  `Fonts#glyph_width` and `Fonts#metrics_for`. pdfrb parses TTF
  tables (cmap, hmtx, head, hhea) via `Pdfrb::Font::TrueType::File`
  and exposes real per-glyph advance widths for any registered font.
- **`Pdfrb::FontResolver`** — used directly by Pipeline for
  PostScriptName → file path resolution. Returns paths as strings,
  no FontMetrics wrapper.

## What was removed

- `lib/idml/text_engine/font_metrics.rb` (200+ lines of Fontisan parsing).
- `lib/idml/text_engine/font_resolver.rb` (Fontisan-coupled resolver).
- `fontisan` gemspec dependency.
- `fontisan` from `spec/anti_patterns_spec.rb` external require allowlist.
- Specs that tested FontMetrics caching and FontResolver resolution.
  Remaining specs (Shaper, LineBreaker, Justifier) now use
  `PdfrbFontMetrics` for their font fixture.

## Pipeline integration

1. `Pipeline#register_font(writer)` finds the font file via
   `Pdfrb::FontResolver#find_by_ps_name` and registers it with
   `pdfrb.fonts.add(path)`, returning a Symbol resource.
2. `Pipeline#build_font_metrics(writer, resource)` wraps the
   resource in a `PdfrbFontMetrics` instance.
3. The metrics object is threaded through `SpreadRenderer` →
   `RenderContext#font_metrics` → `TextFrameRenderer#engine_render`.
4. Shaper and LineBreaker consume `font.units_per_em` and
   `font.glyph_width(codepoint)` exactly as before — the duck-typed
   PdfrbFontMetrics satisfies the same interface.

## Verification

- `lib/idml/text_engine/pdfrb_font_metrics.rb` — adapter.
- `lib/idml/render/pipeline.rb` — font_resolver + font_metrics wiring.
- `spec/idml/text_engine/pdfrb_font_metrics_spec.rb` — 13 specs.
- `spec/idml/text_engine/text_engine_spec.rb` — Shaper/LineBreaker/
  Justifier specs use pdfrb metrics.
- All `bundle exec rake` green (2500+ examples).
- Anti-pattern spec green with `fontisan` removed from allowlist.

## Acceptance criteria

- [x] Pipeline registers fonts via `pdfrb.fonts.add(path)`.
- [x] Shaper/LineBreaker call pdfrb's measurement API via
      PdfrbFontMetrics, not Fontisan.
- [x] `fontisan` removed from gemspec dependencies.
- [x] `FontMetrics` and `FontResolver` deleted from `lib/`.
- [x] Specs use PdfrbFontMetrics fixtures, not Fontisan.
