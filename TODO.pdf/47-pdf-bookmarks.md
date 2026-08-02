# TODO PDF 47: PDF bookmarks/outlines

## Goal

Generate PDF outline (bookmark) entries from the document's XML
structure or heading paragraph styles.

## Acceptance criteria

- [ ] PdfWriter builds an Outlines tree referenced from Catalog.
- [ ] Outline entries link to page destinations.
- [ ] Pipeline extracts headings from ParagraphStyleRange with heading styles.
- [ ] Spec: PDF with 3 chapters, verify 3 outline entries.

## Dependencies

- TODO 35 (PDF metadata).
