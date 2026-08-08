# TODO PDF 03: Text shaper

## Status: DONE — `Idml::TextEngine::Shaper` produces `ShapedGlyph`
structs (codepoint, width, x/y offsets) consumed by LineBreaker.
See `lib/idml/text_engine/shaper.rb`.

## Goal

Convert a text string + font + size into a sequence of positioned
glyphs with widths and kerning applied. The shaper is the bridge
between raw text and layout.

## Acceptance criteria

- [ ] `Idml::TextEngine::Shaper.shape(text:, font_metrics:, size:)`
      returns an Array of `ShapedGlyph` structs (codepoint, advance
      width at the given size, kerning adjustment vs previous glyph).
- [ ] `ShapedGlyph` struct: `codepoint`, `glyph_id`, `width`
      (scaled to point size), `x_offset`, `y_offset`.
- [ ] Handles basic kerning via `font_metrics.kerning_pair`.
- [ ] `ShapedLine.measure(glyphs)` returns total width.
- [ ] Spec: shape "Hello" in a known font, verify total width
      matches sum of glyph widths ± kerning.

## Files

- `lib/idml/text_engine/shaper.rb`
- `lib/idml/text_engine/shaped_glyph.rb`
- `spec/idml/text_engine/shaper_spec.rb`

## Design notes

- No OpenType feature substitution (GSUB) in the first version.
  Ligatures (fi, fl, ff) and contextual alternates are deferred —
  they require parsing the GSUB table, which is a significant
  undertaking. The text engine renders individual codepoints;
  ligatures appear as separate characters.
- Tracking (letter spacing) is applied as a constant offset per
  glyph. Word spacing is applied at space characters.
- Ruby's String#each_codepoint handles Unicode correctly.

## Dependencies

- TODO 01 (FontMetrics).
