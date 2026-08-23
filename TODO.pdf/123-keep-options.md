# TODO PDF 123: Keep options (widow/orphan control)

## Status: COMPLETE — implemented 2026-08-20

## What was done

- `StyleResolver::Paragraph` carries `keep_all_lines_together`
  from the PSR.
- `TextFrameRenderer.consume_paragraphs` pre-measures the paragraph
  (TextEngine::Measurement) and, when KeepAllLinesTogether is set,
  the paragraph cannot fully fit the remaining frame space, and at
  least one paragraph was already placed, pushes the whole
  paragraph to the next frame via the chain state — no widowed
  first lines. The first paragraph in a frame never pushes, so
  progress is always made.

## Known limitations

- KeepLinesTogether with per-side KeepFirstLines / KeepLastLines
  counts (partial keep windows) is not modeled — only the
  whole-paragraph KeepAllLinesTogether form.
- KeepWithNext (binding a paragraph to the next) is not modeled.
- Vertical writing mode does not apply keep options (column model
  differs).
