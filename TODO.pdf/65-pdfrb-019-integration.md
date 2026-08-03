# TODO PDF 65: pdfrb 0.19.0 feature integration

## Status: PARTIALLY DONE (remainder blocked)

## What was implemented

1. **Canvas#text_lines**: `TextFrameRenderer` uses `canvas.text_lines`
   instead of N separate `canvas.text` calls per line. Single batch
   call for all lines within a run.

## What remains

Blocked by pdfrb 0.4.0 stubs in `Fonts#measure_text` (returns
`length * 0.5 * size`) and `#glyph_width` (returns 500). Until real
per-glyph widths land:

2. **`text_rich` for multi-run text**: tracked in TODO 67. Cannot
   advance between runs without real measurement.
3. **Replace FontMetrics with pdfrb measurement**: tracked in TODO 63.
4. **Font subsetting**: tracked in TODO 52. `Fonts#add` accepts `**opts`
   but `subset:` has no effect.

## Acceptance criteria

- [x] TextFrameRenderer uses `canvas.text_lines`
- [ ] FontMetrics replaced with pdfrb `glyph_width` (blocked — TODO 63)
- [ ] FontResolver replaced with `Pdfrb::FontResolver` (blocked — TODO 63)
- [ ] Font subsetting verified (blocked — TODO 52)
- [ ] `text_rich` used for multi-run frames (blocked — TODO 67)
