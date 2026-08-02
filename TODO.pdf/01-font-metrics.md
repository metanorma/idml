# TODO PDF 01: Font metrics reader

## Goal

Read OpenType/TrueType font files and expose per-glyph advance widths
and kerning pairs. This is the foundation of the text engine — without
font metrics, we can't measure text or position glyphs.

## Acceptance criteria

- [ ] `Idml::TextEngine::FontMetrics.open(path)` loads a .ttf or .otf
      file and parses the `head`, `hhea`, `hmtx`, `cmap`, and `kern`
      (or `GPOS`) tables.
- [ ] `#glyph_width(codepoint)` returns the advance width for a
      Unicode codepoint, scaled to the font's `unitsPerEm`.
- [ ] `#kerning_pair(left_cp, right_cp)` returns the kerning value
      for a glyph pair (0 if none).
- [ ] `#ascent`, `#descent`, `#line_gap`, `#units_per_em` expose
      vertical metrics.
- [ ] Uses `ttfunk` (Prawn's font reader) as the parsing backend —
      battle-tested, pure Ruby, MIT license.
- [ ] Spec: load a known font (e.g., DejaVuSans.ttf), verify glyph
      widths for 'A', 'a', ' ', and verify ascent/descent.

## Files

- `lib/idml/text_engine.rb` — module + autoloads.
- `lib/idml/text_engine/font_metrics.rb`
- `spec/idml/text_engine/font_metrics_spec.rb`

## Design notes

- `ttfunk` parses the binary font format. We wrap it in a typed
  `FontMetrics` class that exposes a clean API (no TTFunk types leak).
- Cache glyph widths after first lookup (most documents reuse the
  same glyphs heavily).
- The IDML `Fonts.xml` lists font family + style names. We need a
  resolver that maps `Name="Minion Pro"` + `FontStyleName="Regular"`
  to a .ttf/.otf file on disk. This is TODO 02.

## Dependencies

- `ttfunk` gem (add to gemspec).
