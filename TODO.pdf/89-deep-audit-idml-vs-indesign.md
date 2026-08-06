# TODO PDF 89: Deep audit — idml-generated PDF vs InDesign PDF

## Status: PARTIAL — font + lossless compression fixed; no downsampling

## TL;DR

**No** — the generated PDF is still not byte-identical to InDesign's
output. Two of three substantive gaps closed without data loss:

1. **Font selection (closed, v0.5.0)** — FontSetup now prefers the
   family's Regular/Normal/Book/Roman variant over first-in-family.
   Sample-with-table-more now embeds `MinionPro-Regular` (matching
   InDesign).
2. **Lossless FlateDecode compression (closed, v0.5.1)** — pdfrb
   writes FlateDecode-compressed content streams, XRef streams, and
   object streams when `compress: true`. Saves ~96KB (4%) on the
   sample-with-table-more fixture without any data loss.
3. **Image downsampling** — **not pursued**. The user requirement is
   **no data loss**. InDesign's 100KB output downsamples the 1.94MB
   source image (DCTDecode) to ~12KB at 300ppi; we keep the original
   resolution. The 1.94MB stream dominates file size and cannot be
   reduced without losing image data.

## File-level comparison (`sample-with-table-more`)

| Aspect | InDesign pages.pdf | idml (default) | idml (`compress: true`) |
|---|---|---|---|
| Size | 100,965 bytes | 2,195,575 bytes | **2,099,493 bytes** |
| Pages | 4 | 4 ✓ | 4 ✓ |
| PDF version | 1.4 | 1.4 ✓ | 1.4 ✓ |
| Embedded font | `MinionPro-Regular` | `MinionPro-Regular` ✓ | `MinionPro-Regular` ✓ |
| Font stream size | ~8KB (subsetted) | ~232KB (full) | ~231KB (full) |
| FlateDecode streams | 24 | 0 | 8 |
| Image streams | 4 (downsampled ~12KB each) | 1 (raw 1.94MB) | 1 (raw 1.94MB) |

## Why we can't match InDesign's 100KB

The 1.94MB JPEG image (`GenAIImage_53e34e93-…jpeg` referenced via
`LinkResourceURI` in Spread_ud1) is the dominant file-size cost. It
is embedded raw via DCTDecode because:

- The user requirement is **no data loss**.
- InDesign's 12KB version downsamples to 300ppi at the placement
  bounds — that IS data loss.
- Keeping the image at full resolution = 1.94MB minimum.

Without downsampling, the file size floor is the source image size
plus the font stream plus small overhead:
1,937,556 (image) + 231,312 (full font) + ~20KB (other) = ~2.2MB.
With `compress: true` we shave ~96KB through FlateDecode on the
non-image streams.

## What we DO loselessly (besides image embedding)

- **FlateDecode** on content streams, ObjStms, and metadata streams.
- **XRef stream** (`use_xref_stream: true`) — compact xref table.
- **Object stream packing** (`pack_object_streams: true`) — packs
  small indirect objects into a compressed ObjStm.

## What we don't do (lossy — not enabled)

- **Image downsampling** at 300ppi (TODO 91 was re-classified as
  REJECTED — user explicitly forbids data loss).
- **JPEG quality reduction** for embedded images.
- **Font subsetting to fewer glyphs than used** (lossless subsetting
  IS done by pdfrb — removes only unused glyphs).

## Future audit work

- **Stream-by-stream comparison** with `qpdf --qdf` to decompose both
  PDFs into canonical form and diff.
- **Font subsetting investigation** — pdfrb's `subset_fonts!` is
  called but the font stream is still 232KB. The likely cause is
  that no codepoints are recorded as "used" for the registered font
  (the renderer uses a default font that doesn't get text drawn
  through it). Future fix: register the font actually used to draw
  text, so `used_codepoints` populates correctly.

## Verification

- `lib/idml/render/pdfrb_writer.rb:25` — `LOSSLESS_WRITER_OPTIONS`
  constant; opt-in via `compress: true`.
- `lib/idml/render/pipeline.rb` — `compress:` keyword threaded
  through `PdfrbWriter.new(compress: ...)`.
- `lib/idml/render.rb` — `Render.render(compress: false)` default.
- `lib/idml/cli.rb` — `--compress` CLI flag.
- `spec/idml/fixtures/sample_with_table_more_spec.rb:197` — spec
  verifies compressed output is smaller and contains FlateDecode.

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
