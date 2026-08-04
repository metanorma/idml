# TODO PDF 65: pdfrb feature integration

## Status: PARTIALLY DONE (remainder blocked)

## What was implemented

1. **Canvas#text_lines**: `TextFrameRenderer` uses `canvas.text_lines`
   for batched single-font multi-line text (TODO 27).
2. **Real PDF gradient shadings**: `RectangleRenderer` uses pdfrb's
   `Shadings#add_axial` and `Shadings#add_radial` (TODOs 49, 66, 68).
3. **Canvas#with_transparency**: `Blending.wrap` applies IDML
   `BlendingSetting` opacity + blend modes (TODO 69).
4. **Stroke-style setters**: `StrokeStyle.apply` calls
   `line_cap=`/`line_join=`/`miter_limit=`/`dash_pattern=` from
   IDML `EndCap`/`EndJoin`/`MiterLimit`/`StrokeDashAndGap` (TODO 70/72).
5. **Font subsetting**: `Pipeline` calls `Fonts#subset_fonts!` before
   write (TODO 52).
6. **Placement module**: shared `Render::Placement.box` (TODO 71).

## What remains

Blocked by pdfrb 0.4.0's TTF measurement still being AFM-only:

7. **`text_rich` for multi-run text** (TODO 67): multi-run batching
   depends on accurate per-run advance, which `Fonts#measure_text`
   cannot provide for TTF.
8. **Replace FontMetrics with pdfrb measurement** (TODO 63): same
   blocker.

## Acceptance criteria

- [x] TextFrameRenderer uses `canvas.text_lines`
- [x] Real PDF gradient shadings via pdfrb
- [x] Transparency and blend modes
- [x] Stroke styling
- [x] Font subsetting
- [x] Shared Placement module
- [ ] FontMetrics replaced with pdfrb `glyph_width` (blocked — TODO 63)
- [ ] `text_rich` used for multi-run frames (blocked — TODO 67)
