# TODO PDF 39: Geometry module coordinate helpers

## Goal

Centralize all coordinate-system conversions (IDML ↔ PDF) in the
`Idml::Geometry` module. Every renderer derives placement from these
helpers instead of inline math.

## Status: DONE

## What was implemented

- `Geometry.parse_transform(str)` — parses "a b c d e f" into a Transform.
- `Geometry.apply_transform(transform, x, y)` — applies affine matrix to a point.
- `Geometry.combine_transforms(outer, inner)` — multiplies two transforms.
- `Geometry.transform_bounds(bounds, transform)` — transforms [y1,x1,y2,x2].
- `Geometry.bounds_to_pdf_rect(bounds, page_height)` — converts to PDF
  `{x:, y:, width:, height:}` with Y-axis flip.
- `Color.fill_op(color_hash)` / `Color.stroke_op(color_hash)` — dispatch
  RGB/CMYK from a resolved color hash.
- `Path.stroke_width(weight)` — PDF `w` operator.
- RectangleRenderer: applies ItemTransform + Y-flip, renders fill and stroke.
- PolygonRenderer: uses bounds + fill + stroke (bounding-box approximation).
- TextFrameRenderer: uses frame geometric_bounds for text engine layout.
- StyleResolver: extracts styled runs from Story (font_style, point_size,
  fill_color per CharacterStyleRange).
