# TODO PDF 20: PNG image support

## Goal

Extend image embedding to support PNG files in addition to JPEG.
PNG images are embedded as PDF XObjects with the FlateDecode filter.

## Why

IDML documents commonly reference PNG images (screenshots, graphics
with transparency). Currently only JPEG is supported.

## Acceptance criteria

- [ ] `Render::Image.detect_format(data)` returns `:jpeg` or `:png`
      based on magic bytes.
- [ ] `Render::Image.png_dimensions(data)` reads IHDR chunk for
      width/height.
- [ ] `PdfWriter#add_png_image(data:, width:, height:, colorspace:)`
      creates an XObject with `/Filter /FlateDecode`.
- [ ] Pipeline detects format and calls the appropriate writer method.
- [ ] Spec: embed a known PNG, verify `/Subtype /Image` and
      `/Filter /FlateDecode` in output.

## Files

- `lib/idml/render/image.rb` (add PNG parsing)
- `lib/idml/render/pdf_writer.rb` (add `add_png_image`)
- `lib/idml/render/pipeline.rb` (format detection)
- `spec/idml/render/image_spec.rb`

## Design notes

- PNG magic bytes: `\x89PNG\r\n\x1a\n` (8 bytes).
- IHDR chunk: starts at byte offset 8, length=13, width (4 bytes BE),
  height (4 bytes BE), bit depth, color type.
- Color type mapping: 0 → DeviceGray, 2 → DeviceRGB, 3 → Indexed,
  4 → DeviceGray (alpha), 6 → DeviceRGB (alpha).
- PNG with alpha needs SMask (soft mask) XObject — stretch goal.

## Dependencies

- TODO 09 (image embedding foundation).
