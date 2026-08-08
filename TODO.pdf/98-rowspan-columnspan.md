# TODO PDF 98: RowSpan / ColumnSpan (merged cells) in TableRenderer

## Status: DONE — SchemaLayout reads cell.column_span and cell.row_span,
multiplies width/height by the span, tracks a coverage set, and skips
positions covered by a spanning cell. Spanning cell renders once at
its top-left corner.

## Problem

`Elements::Cell` already carries `row_span` and `column_span`
attributes (mapped from the RNC). The renderer's `SchemaLayout`
iterates `col_count × row_count` cells and looks up each cell by
`[col, row]` — it doesn't merge across spans.

For a 2×2 table where cell `0:0` has `ColumnSpan=2`, the layout
today emits a single cell-width rectangle at column 0 and an empty
cell at column 1, instead of one rectangle spanning both columns.

## What needs to happen

1. `SchemaLayout#each_cell` reads `cell.column_span` and `cell.row_span`
   and computes the rect width = `cell_w * column_span`, height =
   `cell_h * row_span`.
2. Skip cells that are "covered" by a spanning cell (i.e. when
   `[col, row]` falls within another cell's span). Track a
   coverage set per iteration.
3. Spanning cell's text is rendered once, centered on the merged rect.

## Acceptance criteria

- [ ] Cell with ColumnSpan=2 renders a rect of width = 2 × column width.
- [ ] Cell with RowSpan=3 renders a rect of height = 3 × row height.
- [ ] Covered cells (within a span) don't render borders.
- [ ] Spec: 2x2 grid with cell 0:0 spanning both columns.

## Dependencies

- TODO 97 (cell rendering fidelity).
