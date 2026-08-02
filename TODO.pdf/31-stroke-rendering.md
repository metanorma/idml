# TODO PDF 31: Stroke rendering

## Goal

Render stroke attributes on page items: stroke color, weight, end cap,
join style, and dash patterns.

## Why

Currently only fill is rendered. Many IDML page items have visible
strokes (borders, lines, arrows). StrokeWeight, EndCap, EndJoin, and
StrokeType (solid/dashed/dotted) need to be emitted as PDF operators.

## Acceptance criteria

- [ ] StrokeColor resolved via ColorResolver, emitted as `RG`/`K`.
- [ ] StrokeWeight emitted as `w` operator.
- [ ] EndCap (Butt/Round/Square) emitted as `J` operator.
- [ ] EndJoin (Miter/Round/Bevel) emitted as `j` operator.
- [ ] MiterLimit emitted as `M` operator.
- [ ] DashedStrokeStyle: dash array + dash offset emitted as `d`.
- [ ] DottedStrokeStyle: dot pattern as dash array.
- [ ] Spec: render a Rectangle with stroke, verify `w`, `RG`, `S`
      operators in PDF.

## Files

- `lib/idml/render/stroke_renderer.rb`
- `lib/idml/render/renderers/rectangle_renderer.rb` (integrate)
- `spec/idml/render/stroke_renderer_spec.rb`

## Dependencies

- TODO 30 (shape geometry rendering).
- TODO 22 (ColorResolver).
