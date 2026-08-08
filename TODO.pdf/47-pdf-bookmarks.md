# TODO PDF 47: PDF bookmarks/outlines

## Status: DONE — `Render::BookmarkResolver` walks the designmap
bookmark entries and yields `(title, page_index)` tuples;
`PdfrbWriter#add_bookmark` builds the Outlines tree. See
`lib/idml/bookmark_resolver.rb`, `lib/idml/render/pdfrb_writer.rb`,
and TODO 79.

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
