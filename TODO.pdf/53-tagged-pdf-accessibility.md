# TODO PDF 53: Tagged PDF for accessibility

## Goal

Produce tagged PDF (PDF/UA) with a structure tree that maps page items
to logical structure elements (headings, paragraphs, figures, tables).
This enables screen readers and assistive technology to navigate the
document.

## Acceptance criteria

- [ ] PdfWriter (or PdfrbWriter) builds a StructTreeRoot.
- [ ] Each TextFrame maps to a paragraph or heading structure element.
- [ ] Each Image maps to a figure structure element.
- [ ] Each Table maps to a table structure element with TR/TH/TD children.
- [ ] Structure elements have Alt text (from IDML XMLElement names).
- [ ] Marked-content sequences (BMC/EMC) wrap content in the content stream.
- [ ] Catalog references /MarkInfo and /StructTreeRoot.
- [ ] Spec: produce a tagged PDF, verify StructTreeRoot exists.

## Dependencies

- pdfrb structure tree support.
- TODO 48 (table rendering).
