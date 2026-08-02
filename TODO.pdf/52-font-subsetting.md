# TODO PDF 52: Font subsetting via pdfrb

## Goal

Subset embedded TrueType fonts to include only the glyphs actually used
in the document. This dramatically reduces PDF file size (from full font
~500KB to subset ~5-20KB per font).

## Acceptance criteria

- [ ] Pipeline collects all Unicode codepoints used across all stories.
- [ ] For each embedded font, only the used glyphs are included.
- [ ] FontFile2 contains a subsetted font table (not the full font).
- [ ] PDF file size significantly reduced vs full-font embedding.
- [ ] Spec: render text with known characters, verify embedded font
      contains only those glyphs.

## Dependencies

- pdfrb font embedding support (partial — font registration works,
  FontFile2 embedding may require pdfrb enhancement).
- TODO 27 (text engine for glyph collection).
