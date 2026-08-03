# TODO PDF 53: Tagged PDF for accessibility

## Status: DONE

## What was implemented

Pipeline accepts `tagged: true` option. When enabled:
- `PdfrbWriter#enable_tagged` calls `document.structure.enable!`
- `PdfrbWriter#add_structure_element` delegates to `document.structure.add_element`
- `PdfrbWriter#build_structure` calls `document.structure.build!` before writing
- `Render.render(tagged: false)` keyword passes through to Pipeline

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
