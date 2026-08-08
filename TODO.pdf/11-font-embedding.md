# TODO PDF 11: Font embedding

## Status: DONE — `FontSetup#register` loads the document font via
`PdfrbWriter#register_font` (passes `File.open(path, "rb")` as IO).
Subsetting happens via `PdfrbWriter#subset_fonts!`. See
`lib/idml/render/font_setup.rb`, `lib/idml/render/pdfrb_writer.rb`,
and TODOs 52, 62, 65.

## Goal

Embed font subsets in the output PDF so the rendered text is
portable (not dependent on the viewer having the font installed).

## Acceptance criteria

- [ ] Collect every unique font used across all rendered text.
- [ ] Subset each font to only the glyphs actually used (reduces
      file size dramatically).
- [ ] Embed as PDF Font object (Type0 for OpenType, Type1 for
      classic PostScript fonts).
- [ ] Build the font resource dictionary on each PDF page.
- [ ] Spec: render text, open the output PDF, verify the font is
      embedded (check /FontFile2 or /FontFile3 entry).

## Files

- `lib/idml/render/font_embedder.rb`
- `spec/idml/render/font_embedder_spec.rb`

## Design notes

- Font subsetting is non-trivial: parse the font's `glyf` table,
  extract only referenced glyphs, rebuild the table with new
  glyph indices. `ttfunk` has some support for this.
- Alternative: embed the full font (larger but simpler). Start
  with full embedding, add subsetting later.
- PDF/UA and PDF/A require embedded fonts. Regular PDF doesn't
  strictly require it but rendering quality degrades without.

## Dependencies

- TODO 01 (FontMetrics).
- TODO 08 (text operators — need to know which fonts are used).
- pdfrb font resource support.
