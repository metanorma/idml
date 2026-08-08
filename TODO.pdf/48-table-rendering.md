# TODO PDF 48: Table rendering

## Status: DONE — `Render::TableRenderer` handles both the
schema-faithful layout (Table > {Cell, Row} siblings, real IDML) and
the legacy nested model. SchemaLayout computes per-cell rects from
`Row#single_row_height` and `Cell#col_row`. Inline Tables discovered
via `CSR#table`. See `lib/idml/render/renderers/table_renderer.rb`,
`lib/idml/elements/{table,cell,row}.rb`, and TODOs 82, 84.

## Goal

Render IDML tables (TableRow, TableCell elements within Stories) as
PDF table structures with cell borders, backgrounds, and inline text.

## Acceptance criteria

- [ ] Table, TableRow, TableCell element models from RNC.
- [ ] TableRenderer computes cell positions from column/row definitions.
- [ ] Cell borders rendered as stroked rectangles.
- [ ] Cell backgrounds rendered as filled rectangles.
- [ ] Cell text rendered via TextFrameRenderer logic.
- [ ] Spec: render a 2x2 table, verify 4 cells with borders.

## Dependencies

- TODO 18 (text rendering).
- TODO 30 (shape geometry).
