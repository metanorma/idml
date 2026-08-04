# TODO PDF 52: Font subsetting via pdfrb

## Status: DONE

## What was implemented

Pipeline now subsets embedded TrueType fonts via pdfrb 0.4.0's
`Fonts#subset_fonts!`. The flow:

1. Every `canvas.text` / `canvas.text_lines` call auto-populates
   `document.fonts.used_codepoints(resource)` per font.
2. `Pipeline#call` invokes `writer.subset_fonts!` after rendering all
   spreads and before `writer.write`.
3. `PdfrbWriter#subset_fonts!` delegates to
   `document.fonts.subset_fonts!`, which rewrites each registered
   font's FontFile2 with a subset containing only the used glyphs
   (plus glyph 0 / notdef).
4. Subsetting uses `Pdfrb::Font::TrueType::Subsetter`, which rebuilds
   glyf/loca/cmap/hmtx/hhea/maxp/head tables and resolves composite
   glyph references.

## Opting out

`Idml::Render.render(..., subset_fonts: false)` skips the call.
The CLI exposes `--no-subset` for the same effect. Useful when a
downstream consumer needs the full font table (e.g. searchable PDFs
with a specific glyph set).

## Verification

- `lib/idml/render/pdfrb_writer.rb:48` — `subset_fonts!` delegation.
- `lib/idml/render/pipeline.rb:38` — `subset_fonts!` call site.
- `spec/idml/render/render_pdfrb_writer_spec.rb:120` — subsetting
  produces a sub-15KB PDF for "Hello" in Arial.

## Acceptance criteria

- [x] Pipeline collects used codepoints automatically via pdfrb's
      `encode_text` hook.
- [x] Each embedded font's FontFile2 is rewritten with a subset
      containing only used glyphs.
- [x] PDF file size significantly reduced vs full-font embedding.
- [x] Spec renders text with known characters and verifies the
      output PDF is small.
- [x] `subset_fonts: false` skips subsetting.
