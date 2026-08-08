# TODO PDF 06: PDF color operators

## Status: DONE — Colors route through pdfrb's Canvas (`fill_color`,
`stroke_color`) via `Render::ColorResolver`, which converts IDML RGB /
CMYK / Tint values to pdfrb's color tuples. See
`lib/idml/render/color_resolver.rb`.

## Goal

Map IDML color definitions (from Graphic.xml) to PDF color space
operators for content streams.

## Acceptance criteria

- [ ] `Idml::Render::Color` converts IDML Color objects (RGB, CMYK,
      LAB) to PDF operator strings.
- [ ] RGB: `r g b rg` (fill), `r g b RG` (stroke). Values 0.0–1.0.
- [ ] CMYK: `c m y k k` (fill), `c m y k K` (stroke).
- [ ] Tint: scaled color value (IDML TintValue applies).
- [ ] Named colors resolved from Graphic.xml's Color collection.
- [ ] Spec: convert a known RGB color to operator string.

## Files

- `lib/idml/render/color.rb`
- `spec/idml/render/color_spec.rb`

## Dependencies

- Typed Graphic/Color element classes (done).
