# TODO PDF 07: PDF path operators

## Goal

Map IDML geometric page items (Rectangle, Polygon, GraphicLine, etc.)
to PDF path construction and painting operators.

## Acceptance criteria

- [ ] `Idml::Render::Path` converts IDML ItemTransform + Path points
      to PDF path operators.
- [ ] Rectangle → `x y w h re`.
- [ ] Polygon/Path → `x y m ... x y l ... h` (moveto, lineto, close).
- [ ] Fill → `f` (nonzero winding).
- [ ] Stroke → `S`.
- [ ] Fill + Stroke → `B`.
- [ ] ItemTransform (transformation matrix) → `a b c d e f cm`
      (current transformation matrix).
- [ ] Spec: render a known rectangle to operator string.

## Files

- `lib/idml/render/path.rb`
- `spec/idml/render/path_spec.rb`

## Dependencies

- Typed Spread/SpreadObject element classes (done).
- TODO 06 (Color for fill/stroke).
