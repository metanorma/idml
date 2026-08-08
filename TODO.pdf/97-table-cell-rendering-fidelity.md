# TODO PDF 97: Table cell rendering — fill, stroke, insets, vertical justification

## Status: OPEN — gap identified in 2026-08-08 audit

## Problem

`TableRenderer#render_cell_text` is a stub:

```ruby
def self.render_cell_text(canvas, cell, x, y, height, context)
  text = cell.text_content
  return if text.nil? || text.empty?

  runs = [{
    text: text,
    font: context.font_ps_name,    # ignores cell CSR
    size: DEFAULT_SIZE,            # 10.0 hardcoded
  }]
  baseline = y + (height / 2)      # ignores VerticalJustification
  canvas.text_rich(runs, at: [x + INSET, baseline])  # INSET=4.0 hardcoded
end
```

The Cell model (`Elements::Cell`) has:
- `top_inset`, `left_inset`, `bottom_inset`, `right_inset` — text insets
- `fill_color`, `fill_tint` — cell background
- `vertical_justification` — Top/Center/Bottom/Justify
- `paragraph_style_range` — typed runs with their own fonts/sizes

None of these are honored today. Cells render as plain rectangles
with default font at center-baseline with 4pt fixed inset.

## What needs to happen

1. **Cell background fill**: when `cell.fill_color` is set and not
   "Color/None", resolve via ColorResolver and emit a `canvas.fill`
   before the cell border.
2. **Cell stroke**: emit `canvas.stroke` per cell using the cell's
   top/left/bottom/right stroke weights from `Cell` (currently
   Table-level TopBorderWeight only).
3. **Per-cell insets**: read Cell's TextTopInset/TextLeftInset/
   TextBottomInset/TextRightInset instead of the fixed `INSET = 4.0`.
4. **Vertical justification**: position text per
   `cell.vertical_justification` (Top/Center/Bottom/Justify).
5. **Per-cell CSR styling**: walk `cell.paragraph_style_range` →
   `character_style_range` and emit one `text_rich` call with each
   run's font + size, instead of collapsing all text into a single
   DEFAULT_SIZE run.
6. **RotationAngle**: cells can be rotated (Cell#rotation_angle);
   emit `canvas.concat_matrix` if non-zero.

## Acceptance criteria

- [ ] Cell with FillColor="Color/Blue" renders a blue background.
- [ ] Cell with TextTopInset=8 starts text 8pt below cell top.
- [ ] Cell with VerticalJustification="Top" puts text at cell top.
- [ ] Cell with bold CSR run renders bold (per-run font).
- [ ] Cell with PointSize=18 CSR uses 18pt text, not 10pt.

## Dependencies

- None — pure feature gap on existing models.
