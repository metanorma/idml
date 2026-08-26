# TODO PDF 61: Known limitations and future work

## Status: DOCUMENTED — refreshed 2026-08-26

Previously listed limitations (font embedding, tagged PDF, per-run
styling, dead code) were resolved by TODOs 52/53/55/67/76 long ago;
this list reflects the current state.

## Known limitations

### Text layout
- **Hyphenation** is not implemented (Hyphenation* attributes are
  parsed but unused); a hyphenation dictionary would be required.
- **Justification**: word/letter spacing caps apply (TODO 119),
  MaximumGlyphScaling stretches (TODO 129) and MinimumGlyphScaling
  compresses overlong lines (TODO 135); ToBinding / RTL binding
  alignment is not applied.
- **Keep options**: KeepAllLinesTogether (TODO 123), KeepWithNext
  (TODO 127), and the KeepFirstLines / KeepLastLines windows
  (TODO 133, line-count approximation) are honored.
- **First baseline**: AscentOffset and FixedHeight are honored
  (TODO 128); CapHeight / XHeight approximate as leading.
- **StartParagraph** breaks act at frame/column granularity — no
  odd/even page parity.
- **Text wrap**: BoundingBoxTextWrap, Contour, and Inverse modes
  render (TODOs 130-131) with TextWrapSide side-awareness (TODO 138:
  LeftSide / RightSide / LargestArea pick the flow side; spine
  variants approximate as BothSides); JumpObject/NextColumn
  approximate as the box; Contour-mode shapes are not side-aware.

### CJK
- **Mojikumi**: script spacing (TODO 125), line-end compression
  (TODO 132), and class-based pair compression (2026-08-26) are
  applied; named mojikumi sets (詳細 etc.) are not modeled.
- **Vertical mode**: Latin rotation is per glyph (not run-grouped);
  ruby placement is beside-column; keep options do not apply.

### Structural features
- **Endnotes** (TODO 117): reference markers render and endnote TEXT
  renders end-of-story with ordinal prefixes; multi-story linkage
  (which endnotes belong to which main story) is not modeled.
- **Footnotes** number per story; overflow balancing (NoSplitting)
  is not modeled; the simple-render fallback shows markers with
  footnote text stacked at the frame bottom (TODO 137).
- **Anchored objects** render at stored geometry; AnchorType
  text-reflow is not simulated.
- **Tables** flow across chained frames with repeated header rows
  (TODO 134) and diagonal cell strokes draw (TODO 136);
  row-spanning cells break at frame boundaries.
- **Inline anchored objects / footnotes inside table cells** are
  not handled.

## Future enhancements

- Hyphenation dictionary integration
- Shape-mode text wrap contours (side-aware)
- Performance benchmark for 100+ page documents
