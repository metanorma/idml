# TODO PDF 32: Master spread rendering

## Goal

Render master spread page items as background on each page. Master
spreads contain repeating elements (headers, footers, page numbers,
backgrounds) that appear on every page referencing the master.

## Why

Currently master spread items are ignored. Documents with master
content (page numbers, running headers) lose this content in the PDF
output. The Spread's `ShowMasterItems` attribute and Page's
`AppliedMaster` attribute control master item visibility.

## Acceptance criteria

- [ ] Pipeline resolves each Page's `AppliedMaster` to a
      `Parts::MasterSpread`.
- [ ] Master spread page items rendered before spread's own items
      (background layer).
- [ ] `ShowMasterItems="false"` on Spread suppresses master items.
- [ ] Master items positioned relative to the page (MasterPageTransform
      applied).
- [ ] Spec: render a fixture with master items, verify background
      content appears in the PDF.

## Files

- `lib/idml/render/pipeline.rb` (resolve master spreads)
- `lib/idml/render/spread_renderer.rb` (render master items first)
- `spec/idml/render/master_spread_spec.rb`

## Dependencies

- TODOs 14–16 (element models + typed pipeline).
