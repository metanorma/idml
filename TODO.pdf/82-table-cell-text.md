# TODO PDF 82: Table cell text rendering

## Status: DONE (basic; full schema-faithful Cell model deferred)

## What was implemented

`TableRenderer` now renders inline text inside each `<TableCell>`
in addition to the cell grid rectangles.

1. `Idml::Elements::TableCell` gains a `character_style_range`
   collection (typed `Idml::Elements::CharacterStyleRange`).
2. `TableCell#text_content` concatenates the text content of all
   inline CSRs.
3. `TableRenderer#render_cell_text` reads `cell.text_content`,
   builds a single-run `{ text:, font:, size: }` array, and emits
   `canvas.text_rich(runs, at: [cell_x + INSET, baseline])` per cell
   that has text.
4. Default font size 10pt, 4pt inset — sensible defaults that match
   typical IDML table styling.

## Schema divergence (deferred)

The IDML RNC names this element `<Cell>` (not `<TableCell>`) and
declares many more attributes (RowSpan, ColumnSpan, insets per edge,
stroke per edge, FillColor, etc.). The current model captures only
the renderer-immediate subset. Faithful Cell modeling per RNC is a
separate refactor:

- Rename `TableCell` → `Cell` (or add a `Cell` alias).
- Add the full attribute set per `Cell_Object` in
  `reference-docs/schemas/package/Stories/Story.rnc`.
- Update `Table` model: schema says `<Cell>` and `<Row>` are
  siblings (not nested `<TableRow><TableCell>`). Restructuring
  breaks existing fixtures.

These schema corrections are tracked separately.

## Verification

- `lib/idml/elements/table_cell.rb` — character_style_range added,
  `text_content` method.
- `lib/idml/render/renderers/table_renderer.rb:42` —
  `render_cell_text` via `canvas.text_rich`.
- Existing `table_renderer_spec.rb` still passes (cells without
  text render as before).

## Acceptance criteria

- [x] Cells with inline CSR children render the text.
- [x] Empty cells render as empty rectangles (previous behavior).
- [x] Text uses the frame's registered font (via context.font_ps_name).
- [ ] Per-cell font, color, alignment from CSR attributes (deferred).
- [ ] Schema-faithful `<Cell>` element with full attribute set
      (deferred — separate refactor).
