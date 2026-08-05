# TODO PDF 89: Deep audit — idml-generated PDF vs InDesign PDF

## Status: PARTIAL — font selection fixed; image bloat remains

## TL;DR

**No** — the generated PDF is still not identical to InDesign's
output, but the **font selection gap is closed** as of v0.5.0.

After the font fix (FontSetup now prefers Regular weight over
first-in-family):
- Font: `MinionPro-Regular` (matches InDesign) — was
  `MinionPro-BoldCn`.
- File size: still ~2.2MB (the image bloat remains).

The remaining 88% of the file size is the embedded GenAI JPEG
(1,937,556 bytes embedded raw via DCTDecode). InDesign downsamples
to ~12KB. Closing this gap requires pure-Ruby JPEG decode + resize
+ re-encode (TODO 91).

## File-level comparison (`sample-with-table-more`)

| Aspect | InDesign pages.pdf | idml (ours) |
|---|---|---|
| Size | 100,965 bytes | 2,196,913 bytes |
| Pages | 4 | 4 |
| PDF version | 1.4 | 1.4 |
| Embedded fonts | 1 (subsetted `MinionPro-Regular`) | 1 (full `MinionPro-BoldCn`) |
| Font stream size | 8,346 bytes (subsetted) | 232,680 bytes (full) |
| Image streams | 4 (small, downsampled) | 1 (huge, full-res) |
| Image stream sizes | 11,773 + 1,731 + 4,291 + ... | 1,937,556 (single 1.94MB JPEG) |
| `/OutputIntents` | embedded | NOT embedded (even with `--pdf-a`) |
| `/StructTreeRoot` | NOT emitted | only with `--tagged` |
| `/OCG` layers | NOT emitted | NOT emitted |
| `/Metadata` XMP | NOT emitted | emitted (XMP extracted from IDML) |
| OCG/InDesign structure | rich (`PieceInfo`, `PageUIDList`) | absent |
| Compression (FlateDecode) | yes | absent on most streams |

## The 1.94MB bloat

`/Users/mulgogi/Downloads/2.png` is a 600×400 RGBA PNG (278KB on
disk, link-resource size 43,765 bytes per IDML metadata). The idml
renderer reads the file at the path IDML specifies and re-encodes
it through pdfrb's image pipeline as a 2048×2048 JPEG (1.94MB).

InDesign's PDF re-encodes at 300ppi: a 4.7"×3.1" image at 300ppi
is 1410×930, which JPEG-compresses to ~12KB. InDesign's source
asset (43KB) is downsampled then DCT-encoded at low quality for
embed. The idml render doesn't apply downsampling — it just
re-encodes the source file.

## Font selection discrepancy

The idml render uses `FontSetup#register` which picks the first
non-missing font in `package.fonts.font_family[0]` — that's
`MinionPro-BoldCn` (the first font in "Minion Pro" family).

InDesign's PDF embeds `MinionPro-Regular` — that's because each
text run is rendered with the font declared in its
CharacterStyleRange#AppliedFont, which can differ per run.

The idml render's `StyleResolver::StyledRun` doesn't currently
carry `applied_font` (TODO: extract from CSR#AppliedFont). Once
extracted, the TextFrameRenderer can resolve per-run fonts via
`FontSetup#register_resolved` and register each in pdfrb.

## Font subsetting

`Pdfrb::Font::TrueType::Subsetter` exists in pdfrb 0.5.0 and works
when called. Pipeline calls `writer.subset_fonts!` when
`subset_fonts: true`. The resulting file still embeds a ~233KB
font stream — investigation needed to determine why
subsetting isn't shrinking the file.

Likely cause: the `MinionPro-BoldCn` font we register isn't being
used to draw any text (no codepoints were used through it during
rendering), so subsetting doesn't apply. But the full font file is
still embedded because we registered it.

Fix: register only the font(s) that actually carry used codepoints.

## Image handling

The idml render walks `<Image>` elements via `ImageCollector`,
reading the file at `LinkResourceURI` and re-encoding as JPEG.
`Image.compute_placement` uses the image's `ItemTransform` for
sizing.

InDesign's PDF embeds the image at downsampled resolution (300ppi)
and uses Smask for transparency. The idml render doesn't have an
Smask path.

## Structure and metadata

InDesign's PDF embeds `PieceInfo`, `PageUIDList`,
`OriginalDocumentID`, `LastModified` etc. — these are
InDesign-specific structure for round-tripping. The idml render
doesn't emit any of this (it's not part of the PDF spec, but
IDML-aware tools can read it).

The idml render's PDF has `/Metadata` XMP (extracted from
`META-INF/metadata.xml`) — InDesign's reference PDF does not have
it. Adding XMP is a feature, not a bug.

## Visual fidelity

- **Table layout**: After v0.4.8, the idml render uses
  `Row#single_row_height` for vertical sizing. InDesign uses
  this too. But InDesign also accounts for spanning cells, fixed
  heights from row attributes, and additional CellStyle overrides.
  The idml render doesn't model these yet (no fixtures with
  spanning cells in the test suite).
- **Text fonts**: As noted, the idml render uses
  `MinionPro-BoldCn` (heavy, wide) for all text. InDesign uses
  `MinionPro-Regular` (the lighter body weight).
- **Images**: Not yet rendered with downsampling.
- **Layer/Swatch support**: Limited.

## What to do about it

The idml render is correct in **structure** (table, fonts,
shapes) but **incomplete in fidelity** (subsetting, downsampling,
per-run font selection, layer/swatches).

For the test suite purpose, the key value is regression coverage:
the idml render now produces a valid PDF for the real fixture,
even if it doesn't match InDesign's output. Future work to close
the gap:

1. **TODO 88: Per-run font resolution** — extract
   CharacterStyleRange#AppliedFont in StyleResolver and pass
   through to renderer.
2. **Image downsampling** — when EffectivePpi > 72 and
   `ImageExportResolution=Ppi300`, downsample the source image to
   fit the rendered bounds at 300ppi before encoding as JPEG.
3. **Oversized font detection** — only embed fonts that have used
   codepoints (skip fully-unused fonts to avoid embedding
   duplicates).
4. **Table column widths** — derive from
   `ColumnAttributes#ColumnWidth` rather than even division.

## Verification

- `lib/idml/render/renderers/table_renderer.rb` — schema-faithful
  Table rendering (v0.4.7).
- `lib/idml/render/renderers/text_frame_renderer.rb` — inline
  Table discovery via `Story > PSR > CSR > Table` (v0.4.8).
- `spec/fixtures/sample-with-table-more/` — real IDML fixture.
- `spec/idml/fixtures/sample_with_table_more_spec.rb` — 17 specs.
