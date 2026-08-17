# TODO PDF 104: Schema-faithful Table model completion

## Status: COMPLETE — implemented 2026-08-18

All 171 Table_Object attributes from
`reference-docs/schemas/package/Stories/Story.rnc` are declared on
`Elements::Table` (the prior rendering-relevant subset plus the 155
remaining: border tints/gaps/overprints, default row/column strokes,
alternating fills, cell insets, diagonal lines, caption settings,
…), generated with `scripts/rnc_to_lutaml.rb` in schema order.

Drift defense: `spec/idml/elements/table_spec.rb` reads the RNC at
spec time and asserts a Table built with every schema attribute
round-trips every attribute — any attribute dropped from the model
fails the spec.

The renderer still consults only the rendering-relevant subset; the
rest are carried for round-trip and downstream-tool fidelity.

## Problem

`Elements::Table` was added (TODO 84) as a schema-faithful model,
but the audit shows several Table-level attributes from
`Table_Object` in the RNC are missing from the model:

- `TableDirection` (LTR / RTL)
- `TableDrawingOrder`
- `TableFlavor`
- `Spacing` (cell spacing)
- `StrokeOrder` (row-then-col vs col-then-row)
- `TopBorderWeight`, `LeftBorderWeight`, etc. (table outer border)
- `ColumnCount`, `BodyRowCount`, `HeaderRowCount`, `FooterRowCount`
- `TableStride` (column stride for spanning)
- `SkipHeader` / `SkipFooter` (alternating-page behavior)
- `TableLocked` / `TableResizePreference`
- `AppliedTableStyle`

The renderer can't emit correct outer borders or honor table-level
direction without these attributes being modeled.

## What needs to happen

1. Generate the missing attributes from `Table_Object` in
   `reference-docs/schemas/package/Stories/Story.rnc` via
   `scripts/rnc_to_lutaml.rb`.
2. Add `column_attributes` child collection.
3. Add specs asserting the full attribute set against the RNC.

## Acceptance criteria

- [ ] Every attribute listed in `Table_Object` in Story.rnc is
      declared on `Elements::Table`.
- [ ] Round-trip: parse fixture Spread, re-serialize, equivalent.
- [ ] Renderer can read `column_count`, `body_row_count`,
      `header_row_count`, etc. for layout.

## Dependencies

- TODOs 97, 98, 99 (cell fidelity / spans / column widths).
