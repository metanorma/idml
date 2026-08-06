# TODO PDF 91: Image downsampling for embed

## Status: REJECTED — violates "no data loss" requirement

The original proposal was to downsample source images to 300ppi at
the placement bounds before encoding as JPEG. This **loses image
data**: the output pixels are not the same as the source pixels.

The user has explicitly forbidden any data loss: "we don't want
downsampling, we cannot lose data."

Instead, the idml render keeps source images at full resolution
(embedded raw via DCTDecode for JPEG, FlateDecode for PNG). The
file size is dominated by the source image size, which is
unavoidable without data loss.

For users who want smaller PDFs and accept image data loss, the
recommended workflow is:

1. Pre-process the source images before importing into InDesign
   (resize in Photoshop, etc.).
2. Export the IDML with the already-small images.
3. Render via `idml render --compress` for lossless FlateDecode on
   non-image streams.

## What is preserved

- **Image fidelity**: source pixels are embedded bit-for-bit.
- **Font data**: only unused glyphs are dropped (lossless subsetting
  via pdfrb's `TrueType::Subsetter`).
- **Structure**: tagged PDF, XMP, ICC output intent — all lossless.

## Acceptance criteria

- [x] No image downsampling code introduced.
- [x] Source image bytes are preserved verbatim in the PDF stream.
- [x] Lossless FlateDecode compression available via `compress: true`.

## Problem

The idml render reads the image at the path IDML specifies
(`LinkResourceURI="file:..."`) and re-encodes it through pdfrb's
image pipeline as a JPEG. The current code does not downsample —
for `sample-with-table-more` the embedded 2.png (600×400 RGBA,
278KB) is rendered into a 2048×2048 JPEG (1.94MB).

InDesign's reference PDF downsamples to the rendered bounds at the
export resolution (300ppi for the test fixture). The same image
becomes 1410×930 → ~12KB JPEG.

## Plan

1. **Compute render bounds** — `Image.compute_placement` already
   returns the placement rect. The bounds define the output
   dimensions in PDF points.
2. **Compute target pixel dimensions** — convert placement width /
   height in points to pixels at 300ppi (or the
   `ImageExportResolution` attribute if present):
   `target_w = (width / 72) * 300`, similarly for height.
3. **Downsample before encoding** — if source dimensions exceed
   target, resize using a simple bilinear algorithm. Otherwise
   encode at source resolution.
4. **Strip alpha if not needed** — for the test fixture the source
   PNG has alpha but the rendered use is opaque. Strip alpha
   before JPEG-encoding to save additional bytes.

## Acceptance criteria

- [ ] Image stream size for sample-with-table-more <50KB (vs 1.94MB).
- [ ] Visual fidelity: rendered image is downsampled to 300ppi at
      the placement bounds.
- [ ] Spec compares image stream sizes before/after downsampling.
- [ ] Test fixture with high-resolution image (1MB+) verifies
      downsampling kicks in.

## Implementation note

Pure-Ruby bilinear resize is simple but slow. A 2048×2048 → 600×400
resize would take ~200ms. For larger images, a C extension or
subprocess would be faster. For now, pure Ruby is acceptable.
