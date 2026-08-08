# TODO PDF 68: Radial gradient shadings via pdfrb 0.4.0

## Status: DONE — RectangleRenderer dispatches on `Gradient#type`:
`"Radial"` → `Shadings#add_radial`, otherwise → `Shadings#add_axial`.
Spec covers both branches.

## Goal

RectangleRenderer routes gradient fills to either `Shadings#add_axial`
(linear) or `Shadings#add_radial` (radial) based on the IDML
`Gradient.type` attribute (`"Linear"` vs `"Radial"`).

## Background

IDML `<Gradient Type="...">` supports two gradient shapes:
- `"Linear"` (default) — colour stops along a straight axis
- `"Radial"` — colour stops along a radius from a centre point

pdfrb 0.4.0 exposes both:
- `document.shadings.add_axial(from:, to:, stops:, extend:)`
- `document.shadings.add_radial(from:, to:, stops:, extend:)`

Before this TODO, every gradient was rendered as axial regardless of the
declared type, producing incorrect output for radial swatches.

## Implementation

1. Read `Gradient#type` (already modelled on `Elements::Gradient`).
2. In `RectangleRenderer.render_gradient_fill`, dispatch:
   - `type == "Radial"` → `add_radial` with centre-to-edge coords.
   - otherwise → `add_axial` (existing behaviour).
3. Radial coordinates use the box centre as both `from` and the
   near corner of `to` so the shading fills the rectangle.

## Acceptance criteria

- [x] `Gradient.type == "Radial"` produces a pdfrb radial shading.
- [x] `Gradient.type == "Linear"` (or nil) keeps producing an axial shading.
- [x] Spec covers both branches.
- [x] All existing specs still pass.
