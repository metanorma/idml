# TODO PDF 61: Known limitations and future work

## Status: DOCUMENTED — refreshed 2026-08-20

Previously listed limitations (font embedding, tagged PDF, per-run
styling, dead code) were resolved by TODOs 52/53/55/67/76 long ago;
this list reflects the current state.

## Known limitations

### Text layout
- **Hyphenation** is not implemented (Hyphenation* attributes are
  parsed but unused); a hyphenation dictionary would be required.
- **Justification**: word/letter spacing caps apply (TODO 119) and
  MaximumGlyphScaling stretches as the last resort (TODO 129);
  MinimumGlyphScaling compression and ToBinding / RTL binding
  alignment are not applied.
- **Keep options**: whole-paragraph KeepAllLinesTogether (TODO
  123) and KeepWithNext (TODO 127) are honored; partial keep
  windows (KeepFirstLines / KeepLastLines) are not.
- **First baseline**: AscentOffset and FixedHeight are honored
  (TODO 128); CapHeight / XHeight approximate as leading.
- **StartParagraph** breaks act at frame/column granularity — no
  odd/even page parity.
- **Text wrap** (TODO 114): BoundingBox mode only; Shape contour
  following and Inverse mode are not implemented.

### CJK
- **Mojikumi**: CJK/Latin auto script spacing is applied (TODO
  125); full class-based punctuation compression tables are not.
- **Vertical mode**: Latin rotation is per glyph (not run-grouped);
  ruby placement is beside-column; keep options do not apply.

### Structural features
- **Endnotes** (TODO 117): reference markers render; endnote TEXT
  rendering is gated on a real fixture (the EndnoteTextRange
  reference chain is opaque without one).
- **Footnotes** number per story; overflow balancing (NoSplitting)
  is not modeled; the simple-render fallback shows markers without
  footnote text.
- **Anchored objects** render at stored geometry; AnchorType
  text-reflow is not simulated.
- **Tables** do not span frames (no repeated header rows); diagonal
  cell strokes are modeled but not drawn.
- **Inline anchored objects / footnotes inside table cells** are
  not handled.

## Future enhancements

- Hyphenation dictionary integration
- Shape-mode text wrap contours
- Frame-spanning tables with header repeats
- Class-based mojikumi tables
- Performance benchmark for 100+ page documents
