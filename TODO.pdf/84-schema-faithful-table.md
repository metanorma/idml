# TODO PDF 84: Schema-faithful Table/Cell/Row structure

## Status: PARTIAL — Cell and Row elements added; full restructure deferred

## What was added

Schema-faithful element classes alongside the legacy non-standard
ones, so existing fixtures continue to work:

- **`Elements::Cell`** — matches `Cell_Object` RNC. Captures Self,
  Name, RowSpan, ColumnSpan, insets, FillColor, FillTint,
  VerticalJustification, and inline `CharacterStyleRange` children.
  `text_content` walks inline CSRs. `col_row` decodes the
  `"col_row"` Name format.
- **`Elements::Row`** — matches `Row_Object` RNC. Captures Self,
  Name, insets, FillColor, height constraints.
- **`Elements::Table`** now declares `cell` and `row` collections
  alongside the legacy `table_row`. Both parse correctly from XML.

## What remains deferred

The full schema-faithful refactor — moving Table out of SpreadObject
(per RNC, Tables live in Stories, not Spreads) and removing the
legacy `Elements::TableRow`/`TableCell` classes — requires a real
IDML fixture with tables to validate.

Until then:
- The legacy `Table > TableRow > TableCell` path handles the
  existing synthetic test fixture.
- The schema-faithful `Table > {Cell, Row}` path is available for
  future fixtures.
- `TableRenderer` still uses the legacy path.

## Current state vs schema

The existing `Idml::Elements::Table`, `TableRow`, `TableCell` classes
do not match the IDML RNC schema. Three structural divergences:

### 1. Table lives in Stories, not Spreads

Per `reference-docs/schemas/package/Stories/Story.rnc`, `Table_Object`
appears inside `Story_Object` (as a child of `ParagraphStyleRange` or
`CharacterStyleRange`). The current `Idml::Elements::SpreadObject`
incorrectly declares `attribute :table, ... collection: true`, and
`PageItemRenderer` dispatches spread-level Tables to `TableRenderer`.

In real IDML, Tables appear inside Stories. A TextFrame's story
contains the table; the renderer should walk the story to find
tables, not the spread.

### 2. Element names: `Cell` and `Row`, not `TableCell` and `TableRow`

Per RNC, the element names are:
- `element Cell` (`Cell_Object`)
- `element Row` (`Row_Object`)

The current model uses `TableCell` and `TableRow` as both class names
and XML element roots — neither matches the schema.

### 3. Cell and Row are siblings under Table, not nested

Per RNC, `Table_Object` contains `Cell_Object* & Row_Object*` as
**siblings**, not nested `<Row><Cell>` structure:

```
Table_Object = element Table {
  ...
  Cell_Object*,
  Row_Object*
}
```

The current model uses `Table > TableRow > TableCell` nesting, which
won't parse real IDML.

## Plan

1. Add new `Elements::Cell` (matching `Cell_Object` RNC, ~80 attrs).
2. Add new `Elements::Row` (matching `Row_Object` RNC).
3. Restructure `Elements::Table` to declare both `cell` and `row`
   sibling collections.
4. Remove `Elements::TableCell` and `Elements::TableRow` (broken).
5. Remove `:table` from `Elements::SpreadObject`; Tables come via
   Stories only.
6. Update `TableRenderer` to:
   - Dispatch from `TextFrameRenderer` when a story contains a Table.
   - Render via `cell` and `row` siblings, using cell `Name` attr
     (e.g., `"0_0"`) to determine column/row position.
7. Update `PageItemRenderer::RENDERER_MAP` to remove Table (no
   longer a page item).
8. Update specs.

## Why deferred

- No fixture in `spec/fixtures/` contains a Table, so the current
  broken model has never been validated against real IDML.
- The correction touches multiple subsystems (elements, parts,
  renderers, dispatch) and is best done as a focused refactor with
  real-fixture regression tests.
- Adding fixtures requires either Adobe InDesign (commercial) or a
  hand-crafted IDML ZIP matching the schema.

## Acceptance criteria

- [ ] `Elements::Cell` matches `Cell_Object` RNC.
- [ ] `Elements::Row` matches `Row_Object` RNC.
- [ ] `Elements::Table` has sibling `cell` and `row` collections.
- [ ] Tables dispatch from `TextFrameRenderer`, not spread iteration.
- [ ] Real-fixture regression test with a known Table IDML.
