# TODO PDF 65: pdfrb 0.19.0 feature integration

## Status: PARTIALLY DONE

## What was implemented

1. **Canvas#text_lines**: TextFrameRenderer uses `canvas.text_lines`
   instead of N separate `canvas.text` calls per line. Single batch
   call for all lines within a run.

## What remains (pdfrb bugs)

2. **glyph_width for TTF**: pdfrb 0.19.0 has `Fonts#glyph_width` but
   returns 0 for TrueType fonts (bug: "undefined method glyph_id_for
   for String"). Standard 14 Type1 fonts work correctly. Cannot
   replace FontMetrics/Fontisan until this is fixed.

3. **Pdfrb::FontResolver**: Returns nil for common fonts (Helvetica.ttc
   on macOS). Cannot replace Fontisan-based resolver yet.

4. **Font subsetting**: `Fonts#add` accepts `**opts` but `subset: true`
   behavior unverified. Standard 14 fonts don't need FontFile embedding.

## Acceptance criteria

- [x] TextFrameRenderer uses canvas.text_lines
- [ ] FontMetrics replaced with pdfrb glyph_width (blocked by TTF bug)
- [ ] FontResolver replaced with Pdfrb::FontResolver (blocked by .ttc)
- [ ] Font subsetting verified
