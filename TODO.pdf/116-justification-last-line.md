# TODO PDF 116: Justified-text last-line handling

## Status: COMPLETE — implemented 2026-08-18

## Problem

`TextEngine::Justifier` spread slack across inter-word spaces for
`:justified` paragraphs on EVERY line, including each paragraph's
final line — InDesign (and standard typography) leaves the last line
of a justified paragraph ragged. Every fully-justified paragraph
rendered with its final line stretched across the full column width.

## What was done

- `Justifier.justify` takes `last_line:`; when true, a `:justified`
  line falls back to left alignment (no space stretching). All other
  alignments unchanged.
- `TextFrameRenderer.layout_run` passes `last_line:` true for the
  final line of the paragraph's FINAL run (`paragraph_last:` flag
  threaded from `render_runs_for_paragraph`, which knows the run
  list). Mid-paragraph run breaks still justify — only the true
  paragraph-final line goes ragged.
- Footnote layout (`Render::Footnote.layout_paragraph`) applies the
  same rule for the final line of the final run.

## Known limitations

- Justification adjusts inter-word spaces only; letter spacing and
  glyph scaling (Minimum/Maximum/DesiredGlyphScaling, tracking) are
  not applied. ToBinding / RTL binding alignment remains mapped to
  left.
