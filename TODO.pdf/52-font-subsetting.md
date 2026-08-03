# TODO PDF 52: Font subsetting via pdfrb

## Status: BLOCKED (pdfrb has no subsetting API)

## Goal

Subset embedded TrueType fonts to include only the glyphs actually used
in the document. This dramatically reduces PDF file size (from full font
~500KB to subset ~5-20KB per font).

## Blocker

pdfrb 0.4.0 exposes no subsetting API:

- `Pdfrb::Document::Fonts#add` accepts `**opts` but ignores `subset:`.
- No `used_codepoints` collector.
- `glyph_width` returns stub 500 for TrueType — the per-glyph data
  needed to build a subset is unavailable.

Without per-glyph metrics, subsetting cannot be implemented in the
caller either. This is also the same blocker that blocks TODO 63
(replace FontMetrics with pdfrb).

## Path forward

Either:

1. pdfrb adds a subsetting API that consumes a `used_codepoints:` set
   and emits a subsetted FontFile2 at write time, OR
2. pdfrb grows real TTF table parsing (head/hmtx/cmap) so the caller
   can collect used codepoints, build the subset, and pass the bytes
   back to `Fonts#add` as pre-subsetted data.

Once pdfrb unblocks, the idml side needs to:

1. Pipeline collects all Unicode codepoints across all stories.
2. Pipeline passes `used_codepoints: set` to `Fonts#add(subset: true, ...)`.
3. Spec renders text with known characters and verifies the embedded
   font only contains those glyphs.

## Acceptance criteria (after pdfrb unblocks)

- [ ] Pipeline collects all Unicode codepoints used across all stories.
- [ ] For each embedded font, only the used glyphs are included.
- [ ] FontFile2 contains a subsetted font table (not the full font).
- [ ] PDF file size significantly reduced vs full-font embedding.
- [ ] Spec: render text with known characters, verify embedded font
      contains only those glyphs.

## Dependencies

- pdfrb subsetting API (NOT YET AVAILABLE in 0.4.0).
