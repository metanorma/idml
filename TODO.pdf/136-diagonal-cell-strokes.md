# TODO PDF 136: Diagonal cell strokes drawn

## Status: COMPLETE — implemented 2026-08-26

## Problem

The Table schema (TODO 104) modeled `TopLeftDiagonalLine`,
`TopRightDiagonalLine`, and the `DiagonalLineStroke*` attributes, but
the renderer never drew them — struck-through table cells (common in
forms) rendered as plain boxes.

## Solution

`TableRenderer#render_cell_diagonals` draws after cell borders:
TopLeftDiagonalLine from top-left to bottom-right corner,
TopRightDiagonalLine from top-right to bottom-left. Weight defaults
to 1pt and color to black when the flags are set without explicit
stroke attributes (InDesign defaults); `DiagonalLineStrokeTint`
applies via `ColorHelper.apply_tint`.

## Files

- `lib/idml/render/renderers/table_renderer.rb`
- `spec/idml/render/table_renderer_spec.rb`
