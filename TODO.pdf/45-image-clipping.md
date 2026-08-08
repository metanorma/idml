# TODO PDF 45: Image clipping

## Status: DONE — `SpreadRenderer#apply_image_clip` emits a pdfrb
clip rectangle from the parent frame's `PathGeometry` before
`draw_image_matrix`. See `lib/idml/render/spread_renderer.rb`.

## Goal

Clip placed images to their parent Rectangle's bounds. Currently
images can overflow the containing frame.

## Acceptance criteria

- [ ] PdfWriter supports clip paths (W/W* operators in content stream).
- [ ] ImageRenderer emits clip path before drawing image.
- [ ] Clip path derived from parent Rectangle's PathGeometry.
- [ ] Spec: image inside a small Rectangle, verify clip operators present.

## Dependencies

- TODO 28 (PathGeometry).
