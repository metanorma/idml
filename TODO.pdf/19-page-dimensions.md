# TODO PDF 19: Page dimensions from IDML

## Goal

Derive PDF page width and height from the IDML document's Page element
GeometricBounds, rather than using the hardcoded US Letter (612×792)
constant.

## Why

IDML documents can be any size (A4, business card, poster, etc.).
Hardcoding 612×792 produces incorrect layouts for non-Letter documents.

## Acceptance criteria

- [ ] `Parts::Spread#page_dimensions` returns `[{ width:, height: }]`
      for each Page in the spread.
- [ ] Dimensions derived from `Page#geometric_bounds` (y1 x1 y2 x2 format).
- [ ] Pipeline passes per-page dimensions to `PdfWriter#add_page`.
- [ ] Spec: load the sample fixture, verify page dimensions match
      the fixture's actual page size (612×792 for US Letter).

## Files

- `lib/idml/parts/spread.rb` (add `page_dimensions`)
- `lib/idml/render/pipeline.rb` (use per-page dimensions)
- `spec/idml/parts/spread_spec.rb`

## Design notes

- `GeometricBounds="0 0 792 612"` means y1=0, x1=0, y2=792, x2=612.
  Width = x2 - x1 = 612, Height = y2 - y1 = 792.
- A spread can contain multiple pages (two-page spread). Each Page
  element has its own GeometricBounds.
- The PDF has one page per IDML spread (current behavior). Multi-page
  spreads render as a single PDF page encompassing all spread pages.

## Dependencies

- TODOs 14–15 (Page element model + SpreadObject wiring).
