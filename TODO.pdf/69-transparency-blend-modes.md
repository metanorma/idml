# TODO PDF 69: Transparency and blend modes via pdfrb 0.4.0

## Status: DONE — `Render::Blending.wrap(canvas, setting, &block)`
maps IDML `BlendingSetting` (BlendMode + Opacity) to pdfrb's
`canvas.with_transparency(opacity:, blend_mode:)`. Used by every
shape renderer. See `lib/idml/render/blending.rb`,
`lib/idml/elements/blending_setting.rb`.

## Goal

Honor IDML `<BlendingSetting BlendMode="..." Opacity="..."/>` on page
items by routing through pdfrb's `Canvas#with_transparency` and
`Canvas#blend_mode=`. Applies to Rectangle, Polygon, GraphicLine, and
TextFrame fill+stroke paths.

## Background

IDML models transparency as nested elements under each page item:

```xml
<Rectangle ...>
  <TransparencySetting>
    <BlendingSetting BlendMode="Multiply" Opacity="0.5"
                     KnockoutGroup="true" IsolateBlending="false"/>
    <DropShadowSetting .../>   <!-- not handled here -->
  </TransparencySetting>
</Rectangle>
```

`TransparencySetting` lives as a child of the page item (sibling of
`Properties`). Its first `BlendingSetting` child carries the blend mode
and opacity that apply to the item's entire drawing.

pdfrb 0.4.0 exposes the matching primitives:

- `Canvas#opacity=` — sets alpha for both fill and stroke (ExtGState `ca`/`CA`).
- `Canvas#blend_mode=` — sets BM name.
- `Canvas#with_transparency(opacity:, blend_mode:) { ... }` — saves graphics state, applies both, restores on exit.

## IDML → PDF blend-mode mapping

IDML's `BlendMode` enumeration maps to PDF's `BM` names where they line
up; PDF does not have equivalents for every IDML mode. Initial mapping:

| IDML               | PDF           |
|--------------------|---------------|
| `Normal`           | `Normal`      |
| `Multiply`         | `Multiply`    |
| `Screen`           | `Screen`      |
| `Overlay`          | `Overlay`     |
| `SoftLight`        | `SoftLight`   |
| `HardLight`        | `HardLight`   |
| `Darken`           | `Darken`      |
| `Lighten`          | `Lighten`     |
| `ColorDodge`       | `ColorDodge`  |
| `ColorBurn`        | `ColorBurn`   |
| `Difference`       | `Difference`  |
| `Exclusion`        | `Exclusion`   |
| `Hue`              | `Hue`         |
| `Saturation`       | `Saturation`  |
| `Color`            | `Color`       |
| `Luminosity`       | `Luminosity`  |

Unknown modes fall back to `Normal`.

## Implementation

1. Add `transparency_setting` attribute to `Rectangle`, `Polygon`,
   `GraphicLine`, `TextFrame`, `Group` (RNC lists it on every page item).
2. Model `TransparencySetting` with a `blending_setting` child.
3. New helper `Render::Blending` that maps an `Elements::BlendingSetting`
   to a `{ opacity:, blend_mode: }` hash.
4. In each renderer, wrap the existing fill/stroke block in
   `canvas.with_transparency(**blending_args) { ... }` when a setting is
   present.
5. Reuse the existing `save_graphics_state` block — `with_transparency`
   already saves/restores, so renderers call it in place of the plain
   save block when blending applies.

## Acceptance criteria

- [ ] IDML `<BlendingSetting Opacity="0.5"/>` halves the item's alpha in the output PDF.
- [ ] IDML `<BlendingSetting BlendMode="Multiply"/>` sets `/BM /Multiply` in ExtGState.
- [ ] Items without BlendingSetting render exactly as before (no ExtGState emitted).
- [ ] Spec covers opacity, blend_mode, and pass-through cases.

## Dependencies

- pdfrb 0.4.0 `Canvas#with_transparency` (DONE — confirmed in pdfrb 0.4.0).
- pdfrb 0.4.0 `Canvas#blend_mode=` (DONE).
