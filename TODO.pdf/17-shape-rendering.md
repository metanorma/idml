# TODO PDF 17: Shape rendering

## Status: DONE — `RectangleRenderer`, `PolygonRenderer`,
`GraphicLineRenderer` register in `PageItemRenderer::RENDERER_MAP`
and call pdfrb Canvas path operators. Colors via `ColorResolver`.
See `lib/idml/render/renderers/` and TODOs 26, 30.

## Goal

Render IDML page-item shapes (Rectangle, Polygon, GraphicLine, Ellipse)
as PDF path operators with fill and stroke colors.

## Why

Currently only images are rendered — page-item geometry (colored
rectangles, borders, backgrounds) is invisible in the output PDF.

## Acceptance criteria

- [ ] `SpreadRenderer` iterates all page items and dispatches to
      type-specific renderers.
- [ ] Rectangle: emits `re` (rectangle) operator with fill (`f`) and/or
      stroke (`S`) based on FillColor/StrokeColor presence.
- [ ] Polygon: emits `m`/`l` path operators from PathPointArray.
- [ ] GraphicLine: emits open path with stroke only.
- [ ] Colors resolved from Resources/Graphic.xml (Color/Swatch names → RGB/CMYK).
- [ ] ItemTransform applied via `cm` operator.
- [ ] Spec: render a Rectangle with known fill color, verify PDF
      contains the `rg` (fill RGB) and `re` operators.

## Files

- `lib/idml/render/shape_renderer.rb` (new)
- `lib/idml/render/spread_renderer.rb` (dispatch to ShapeRenderer)
- `lib/idml/render/color_resolver.rb` (new — resolves color names to values)
- `spec/idml/render/shape_renderer_spec.rb`

## Design notes

- Renderer dispatch should use a registry (OCP): adding a new page-item
  type = registering a renderer, not editing a switch statement.
- Color resolution: IDML color names like "Color/Red" reference entries
  in Resources/Graphic.xml. The resolver looks up the Color element by
  Self attribute and returns RGB or CMYK values.
- GeometricBounds for Rectangle: `y1 x1 y2 x2` → PDF rectangle at
  `(x1, page_height - y2)` with width `x2 - x1`, height `y2 - y1`.

## Dependencies

- TODOs 14–16 (element models + typed pipeline).
- TODO 22 (color resolution).
