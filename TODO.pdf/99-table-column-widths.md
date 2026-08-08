# TODO PDF 99: Table column widths from ColumnAttributes

## Status: DONE — Table now models `column_count` and
`single_column_width`; SchemaLayout uses SingleColumnWidth when
declared, else falls back to even division. (IDML has no separate
ColumnAttributes element — column widths live on Table directly
when uniform.)

## Problem

`TableRenderer::SchemaLayout#cell_w` divides the table width evenly
across all columns:

```ruby
def cell_w
  box[:width] / [col_count, 1].max
end
```

Real IDML documents declare per-column widths via the
`ColumnAttributes` child of `Table` (with `SingleColumnWidth`
attributes). The renderer ignores these, producing visually wrong
tables whenever columns aren't equal-width.

## What needs to happen

1. Verify `Elements::Table` exposes the `column_attributes`
   collection (add it if missing).
2. `SchemaLayout` reads each `ColumnAttributes#single_column_width`
   and computes a cumulative column-x table.
3. `cell_x(col)` looks up the cumulative position; `cell_w(col)`
   uses the actual width for that column.
4. Falls back to even division when `ColumnAttributes` is absent.

## Acceptance criteria

- [ ] Table with two columns, widths 100pt and 200pt, renders cells
      at the correct x positions and widths.
- [ ] Table without ColumnAttributes renders as today (even division).
- [ ] Spanning cells (ColumnSpan) cover the correct cumulative width.

## Dependencies

- TODO 98 (spans interact with column widths).
