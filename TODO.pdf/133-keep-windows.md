# TODO PDF 133: Partial keep windows (KeepFirstLines / KeepLastLines)

## Status: COMPLETE — implemented 2026-08-24

## What was done

- `StyleResolver::Paragraph` carries `keep_first_lines` /
  `keep_last_lines` from the PSR.
- `consume_paragraphs` defers the whole paragraph when it cannot
  fully fit AND either window binds, approximated by measured line
  counts (TextEngine::Measurement height ÷ leading):
  - KeepFirstLines=N defers when fewer than N lines fit the
    remaining space.
  - KeepLastLines=N defers when the overflow tail for the next
    frame would strand fewer than N lines.

## Known limitations

- Line counts are estimates (pre-measured shape/wrap); runs whose
  mid-paragraph wrap differs from the estimate may defer one line
  early or late.
- Not applied in vertical writing mode.
