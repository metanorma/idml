# TODO PDF 82: Table cell text rendering

## Status: PLANNED (design only)

## Goal

Render text inside IDML `<Table>` cells. Today `TableRenderer` draws
cell rectangles but emits no text — tables appear as empty grids.

## Background

IDML tables carry text in stories referenced by each `<TableCell>`:

```xml
<Table Self="t1">
  <TableRow Self="r1">
    <TableCell Self="c1" Name="A1">
      <CellCoordinates .../>
    </TableCell>
  </TableRow>
</Table>
```

The cell's text content lives in a separate Story part referenced
by the cell's `Name` or an `AppliedCellStyle` text-frame binding.
The exact binding mechanism varies by IDML version — sometimes a
cell wraps a `<CharacterStyleRange>` directly, sometimes it
references a story.

pdfrb's `Canvas#text_rich` (TODO 67) is the right primitive: one
call per cell, with per-run advance from pdfrb's measurement API.

## Plan

1. **Discover cell text source**: inspect a fixture that has a
   table with text. Determine whether cells carry inline CSR
   children or reference a story Self.
2. **Extend `TableRenderer#render_row`**: after drawing the cell
   rectangle, look up the cell's text. If inline, parse CSR
   directly. If story-referenced, resolve via
   `package.story_by_id(cell_name)`.
3. **StyleResolver reuse**: extract runs from the cell's content
   the same way `TextFrameRenderer` does.
4. **Placement**: cell rect from the existing geometry math +
   cell-level insets (typically 4pt).
5. **Emit**: `canvas.text_rich(runs, at: [cell_x + inset, cell_y_baseline])`.

## Acceptance criteria

- [ ] Table with text cells renders text inside each cell.
- [ ] Text wraps within the cell width.
- [ ] Empty cells render as empty rectangles (current behavior).
- [ ] Spec covers a fixture with a simple text table.

## Dependencies

- pdfrb `Canvas#text_rich` and per-glyph measurement (DONE).
- Cell text source investigation (TODO).
