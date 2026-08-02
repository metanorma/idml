# TODO PDF 48: Table rendering

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
