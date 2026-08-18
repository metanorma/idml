# TODO PDF 118: Table alternating row/column band fills

## Status: COMPLETE — implemented 2026-08-18

## Problem

IDML tables declare table-level alternating fills —
StartRowFillColor/Count + EndRowFillColor/Count (row banding),
StartColumnFillColor/Count + EndColumnFillColor/Count (column
banding), ColumnFillsPriority (true = column banding wins),
SkipFirst/LastAlternatingFillRows/Columns (edge suppression), and
per-band tints. All attributes are modeled (TODO 104) but the
renderer only honored per-Cell FillColor, so banded tables (zebra
stripes, ledger shading) rendered without their backgrounds.

## What was done

- `SchemaLayout#band_fill(col, row)` computes the effective band
  color + tint for a cell position: row banding by default; column
  banding when ColumnFillsPriority is true or row banding is
  unconfigured; SkipFirst/Last offsets suppress banding at the
  table edges; "Color/None" band colors render nothing.
- `TableRenderer` paints the band rect behind each cell BEFORE the
  cell's own background — an explicit Cell FillColor overrides the
  band, matching InDesign.
- `each_cell` now also yields the cell's column/row indices.

## Acceptance criteria

- [x] Rows alternate Start/End colors in the declared counts.
- [x] Cell-level fill overrides the band.
- [x] Column banding wins when ColumnFillsPriority is true.
- [x] SkipFirstAlternatingFillRows suppresses leading bands.
