# TODO PDF 22: Color resolution from Resources

## Status: DONE — `Render::ColorResolver` resolves `Color/...` and
`Swatch/...` references from `Parts::Graphic` into RGB/CMYK tuples.
`[None]` and `[Registration]` handled specially. See
`lib/idml/render/color_resolver.rb`.

## Goal

Resolve IDML color references (e.g., "Color/Red", "Color/c0m100y100k0")
to concrete RGB or CMYK values using the Resources/Graphic.xml part.

## Why

Page items and text runs reference colors by name. To render fills,
strokes, and text colors, we need to look up the color definition in
Resources/Graphic.xml and extract its component values.

## Acceptance criteria

- [ ] `Idml::Render::ColorResolver` class.
- [ ] Initialized with a `Parts::Graphic` (typed Resources/Graphic.xml).
- [ ] `resolve(name)` returns `{ model: :rgb, r:, g:, b: }` or
      `{ model: :cmyk, c:, m:, y:, k: }` or nil if not found.
- [ ] Handles IDML color name format: `Color/<name>`, `Swatch/<name>`.
- [ ] Space-separated RGB values (0–255) and CMYK values (0–100) in
      the Color element's `ColorValue` attribute.
- [ ] Spec: resolve a known color from the fixture's Graphic.xml.

## Files

- `lib/idml/render/color_resolver.rb`
- `lib/idml/elements/color.rb` (verify ColorValue attribute exists)
- `spec/idml/render/color_resolver_spec.rb`

## Design notes

- Resources/Graphic.xml contains `<Color Self="Color/Red" Model="RGB"
  ColorValue="255 0 0" />` entries.
- Color names are case-sensitive, prefixed with `Color/` or `Swatch/`.
- The `[None]` and `[Registration]` colors are special: `[None]` = no
  fill, `[Registration]` = 100% all channels (registration mark black).

## Dependencies

- TODO 06 (PDF color operators).
