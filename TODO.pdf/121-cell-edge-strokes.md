# TODO PDF 121: Per-side cell edge strokes

## Status: COMPLETE — implemented 2026-08-19

## Problem

`TableRenderer` stroked every cell as a uniform rectangle with the
canvas default line width. IDML cells declare per-side edge stroke
weights (TopEdgeStrokeWeight, LeftEdgeStrokeWeight,
BottomEdgeStrokeWeight, RightEdgeStrokeWeight — with the matching
stroke colors/tints), and the table declares fallback defaults
(DefaultRowStrokeWeight / DefaultColumnStrokeWeight).

## What was done

- Cell_Object schema completion: `Elements::Cell` declares all 95
  schema attributes (77 added — per-side edge strokes + diagonal
  lines + cell style overrides), generated in schema order like the
  Table completion (TODO 104).
- `TableRenderer.render_cell_border` draws each side separately
  with the cell's edge stroke weight, falling back to the table's
  default row/column stroke weight, and resolves stroke colors via
  the color resolver (black fallback). Sides with zero weight are
  skipped, so weightless cells no longer draw hairlines.

## Known limitations

- Diagonal cell strokes (DiagonalLine*) are modeled but not drawn.
- Edge stroke types (dashes) fall back to solid.
