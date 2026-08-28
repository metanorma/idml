# TODO PDF 61: Known limitations and future work

## Status: DOCUMENTED — refreshed 2026-08-28

Previously listed limitations (font embedding, tagged PDF, per-run
styling, dead code) were resolved by TODOs 52/53/55/67/76 long ago;
this list reflects the current state.

## Known limitations

### Text layout
- **Hyphenation**: dictionary-based hyphenation is not implemented
  (Hyphenation* attributes are parsed but unused); compound words
  wrap after explicit hyphens (TODO 139).
- **Justification**: word/letter spacing caps apply (TODO 119),
  MaximumGlyphScaling stretches (TODO 129) and MinimumGlyphScaling
  compresses overlong lines (TODO 135); ToBinding / RTL binding
  alignment is not applied.
- **Keep options**: KeepAllLinesTogether (TODO 123), KeepWithNext
  (TODO 127), and the KeepFirstLines / KeepLastLines windows
  (TODO 133, line-count approximation) are honored.
- **First baseline**: all five modes honor their metrics (TODOs
  128/140); CapHeight / XHeight use standard font proportions
  (0.72 / 0.52 em) until a metrics provider fills them.
- **StartParagraph** breaks act at frame/column granularity — no
  odd/even page parity.
- **Text wrap**: BoundingBoxTextWrap, Contour, and Inverse modes
  render (TODOs 130-131) with TextWrapSide side-awareness for both
  box contours and Contour shapes (TODOs 138/147); JumpObject and
  NextColumn move text below the object (TODOs 143/146) — NextColumn
  in a MULTI-column frame should jump to the next column instead
  (chain integration, future); spine variants approximate as
  BothSides.

### CJK
- **Mojikumi**: script spacing (TODO 125, now actually wired),
  line-end compression (TODO 132), class-based pair compression,
  and named-set aki overrides (TODO 145: OverrideMojikumiAki
  Desired applies per class pair) are applied; Minimum/Maximum
  aki bounds and CompressionPriority are parsed but unused.
- **Vertical mode**: Latin runs rotate as one group per segment
  (TODO 142); ruby placement is beside-column; keep options do
  not apply.

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
- NextColumn wrap via column-jump chaining (multi-column frames)
- Minimum/Maximum mojikumi aki bounds + CompressionPriority
- ToBinding / RTL binding alignment
- Vertical-mode keep options
