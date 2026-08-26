# TODO PDF 138: Side-aware text wrap (TextWrapSide)

## Status: COMPLETE — implemented 2026-08-26

## Problem

TextWrapSide was parsed but ignored: every wrap mode narrowed the run
width by the contour overlap, which smears text over objects that sit
at a frame edge (text starts at the frame's left edge regardless of
where the object is).

## Solution

`TextWrapResolver#wrap_adjustment` returns
`[width_reduction, x_shift]` per line band:

- `LeftSide` — text stays left of the contour: reduce so the line
  ends at the contour's left edge, no shift.
- `RightSide` — text flows right of the contour: shift lines past the
  contour's right edge (`Line#x_offset += shift` after justification)
  and reduce by the same amount.
- `LargestArea` — pick the roomier side of the two.
- `BothSides` (default) and the spine variants — narrow by the full
  overlap; true two-segment lines and binding-side context remain
  approximations.
- Inverse contours keep their flip-to-inside semantics.

Multiple contours combine by max (per-run approximation, as before).
Shape contours (Contour mode) narrow by polygon overlap without side
awareness.

## Files

- `lib/idml/render/text_wrap_resolver.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `spec/idml/render/text_wrap_resolver_spec.rb`
