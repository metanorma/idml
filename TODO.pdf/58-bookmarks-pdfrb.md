# TODO PDF 58: PDF bookmarks via pdfrb outline API

## Goal

Generate PDF bookmark (outline) entries using pdfrb's outline API.
Each bookmark links to a page destination.

## Status: DONE

## What was implemented

- `PdfrbWriter#add_bookmark(title, page_index)` delegates to
  `Pdfrb::Document#outline.add(title, dest: page)`.
- Available for Pipeline consumers to add bookmarks for headings or
  sections.
- `PdfrbExt::Clip` and `PdfrbExt::EndPath` also added for image clipping
  (TODO 57).

## Acceptance criteria

- [x] PdfrbWriter#add_bookmark delegates to pdfrb outline API.
- [x] Anti-pattern spec passes (no new violations).
- [x] All tests pass.
