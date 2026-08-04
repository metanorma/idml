# TODO PDF 73: Drop dead GradientResolver approximation code

## Status: DONE

## What was removed

`Idml::Render::GradientResolver` previously carried a 32-rectangle
discrete-approximation renderer (`render_gradient`, `interpolate`,
`blend_between`, `blend`, and the `SEGMENTS = 32` constant). The
discrete approximation was replaced by real PDF shadings in TODO 66
(pdfrb 0.4.0 `Shadings#add_axial`) and TODO 68 (`add_radial`); the
old code became dead.

The class also had a `build(graphic)` factory that built a lookup
table no consumer reads.

## What was kept

- `GradientResolver.gradient?(name)` — pure predicate (`name` is a
  `Gradient/*` reference). Still used by `RectangleRenderer#render_fill`
  to choose between gradient and solid color paths.

The module is now a 4-line pure predicate. Every other responsibility
moved to `RectangleRenderer`'s direct `Shadings#add_axial` /
`add_radial` calls.

## Why

Dead code accumulates. Three reasons to drop it:

1. **Confusion** — readers see `SEGMENTS = 32` and assume the discrete
   approximation is still in use somewhere.
2. **Maintenance** — every time `ColorResolver` or the gradient model
   changed, the dead code needed reading to confirm it didn't need
   updating.
3. **Test surface** — the dead `render_gradient` had its own spec
   using `instance_double(Idml::Parts::Graphic)`, violating the
   no-doubles rule. Removing the method let us delete the offending
   spec.

## Acceptance criteria

- [x] `GradientResolver` exposes only `.gradient?`.
- [x] No `render_gradient`, `interpolate`, `blend_between`, `blend`,
      `SEGMENTS`, or `build` in the module.
- [x] Renderer code unchanged in behavior (still routes gradient fills
      to pdfrb Shadings).
- [x] `bundle exec rake` green.
