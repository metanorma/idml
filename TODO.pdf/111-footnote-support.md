# TODO PDF 111: Footnote support

## Status: OPEN — gap identified in 2026-08-09 audit

## Problem

IDML has full footnote support:
- `<Footnote>` elements in Stories (inline footnote markers + text)
- `<FootnoteOption>` on PSR (numbering rules, layout)
- `TextFramePreference.FootnotesEnableOverrides`,
  `FootnotesSpanAcrossColumns`, `FootnotesMinimumSpacing`,
  `FootnotesSpaceBetween` — frame-level footnote layout
- `<TextFrameFootnoteOptionsObject>` — per-frame footnote config

The renderer doesn't model footnote content or lay it out.
Documents with footnotes (academic, legal, technical) currently
lose footnote text in the PDF.

## What needs to happen

1. Model `<Footnote>` element (story-embedded footnote text +
   reference marker).
2. Story parsing extracts footnotes alongside main text.
3. Footnote text renders at the bottom of the page that contains
   the reference marker.
4. Footnote numbering rules from FootnoteOption honored.
5. Continuous footnotes flow across pages.

This is a large feature — defer until needed by a real fixture.

## Acceptance criteria

- [ ] Footnote text rendered at bottom of containing page.
- [ ] Footnote marker in body text links to footnote text.
- [ ] Numbering restarts per document section per FootnoteOption.

## Dependencies

- TODO 108 (multi-frame story flow) — footnotes need to know which
  page a reference appears on.
