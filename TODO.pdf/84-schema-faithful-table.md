# TODO PDF 84: Schema-faithful Table/Cell/Row structure

## Status: DONE — schema-faithful model validated against real fixture

## What was done

Schema-faithful element classes match the real IDML structure
(validated against `spec/fixtures/sample-with-table-more/`):

- **`Elements::Cell`** — matches `Cell_Object` RNC. Captures Self,
  Name (col:row encoding like "0:0"), RowSpan, ColumnSpan,
  ColumnType, CellType, TextTopInset/TextLeftInset/etc.,
  FillColor, FillTint, VerticalJustification, AppliedCellStyle,
  and inline `ParagraphStyleRange` children. `text_content` walks
  inline PSRs. `col_row` decodes the `"col:row"` Name format.
- **`Elements::Row`** — matches `Row_Object` RNC. Captures Self,
  Name (row index), TextTopInset/TextLeftInset/etc., FillColor,
  SingleRowHeight, MinimumHeight, MaximumHeight.
- **`Elements::Table`** declares `cell` and `row` collections
  alongside the legacy `table_row`. Both parse correctly from XML.
- **`Elements::CharacterStyleRange`** now has a `table` collection
  so CSR > Table > {Cell, Row} parses end-to-end (per RNC, Tables
  appear inside CSRs in Stories, not in Spreads).

## Real-fixture validation

`spec/fixtures/sample-with-table-more/sample-with-table-more.idml`
is a 3-spread IDML with a single Table in `Story_u1b7`:

- Table Self=`u1b7i1cc`, 9 Row children, 83 Cell children.
- First cell Name=`"0:0"`, content=`"H1"` (header).
- Cell Name increments col within a row (`"0:0"`, `"1:0"`, `"2:0"`).

`spec/idml/fixtures/sample_with_table_more_spec.rb` covers:
- Package structure (3 spreads, 10 stories).
- Table discovery via story → PSR → CSR > Table.
- Table Self, row count, cell count.
- Row Self pattern (Table Self + `Row<N>`).
- Cell Name format and col_row decoding.
- Cell text_content from inline PSR > CSR > Content.
- Cell column_type (HeaderColumn).
- End-to-end PDF render.

## Legacy preserved

The existing `Elements::Table`/`TableRow`/`TableCell` classes
(synthetic, non-schema-faithful) remain for the existing synthetic
`table_renderer_spec.rb` test. They are not removed because no
real IDML uses them and removing them would break the existing test.

## What was completed in this round

- `TableRenderer` migrated to auto-detect schema-faithful
  (`cell`/`row` siblings) vs legacy (`table_row`/`table_cell`
  nested) layout. New `SchemaLayout` Struct computes per-cell rects
  from `Row#single_row_height` and `Cell#col_row` max col + 1.
- `TextFrameRenderer` discovers inline Tables via
  `Story > PSR > CSR > Table` and renders each within the frame's
  bounds via `TableRenderer.render_in_box`. This is the path that
  real IDML fixtures use (Tables live in Stories, not Spreads).
- New `TableRenderer.render_in_box(canvas, table, box, context)`
  API accepts caller-supplied bounds (real Tables have no own
  geometry).
- The sample-with-table-more fixture's Table now renders 83 cell
  rectangles end-to-end (verified by spec).

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
