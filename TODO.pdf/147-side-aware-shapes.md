# TODO PDF 147: Side-aware Contour shapes

## Status: COMPLETE — implemented 2026-08-28

## Problem

TextWrapSide applied only to BoundingBoxTextWrap contours;
Contour-mode shapes narrowed by polygon overlap regardless of
side — text smeared over shapes at frame edges instead of
flowing around the chosen side.

## Solution

`WrapContour::Shape` carries `side`; `wrap_adjustment`'s shape
branch dispatches through the shared interval-based side logic
using the polygon's bounding box: LeftSide keeps text left of the
shape, RightSide shifts lines past its right edge, LargestArea
picks the roomier side; BothSides (and spine variants) keep the
exact polygon-overlap narrowing. Inverse shapes keep their
flip-to-inside semantics. The side dispatch is now one shared
`interval_side_adjustment` for boxes and shapes alike.

## Files

- `lib/idml/render/wrap_contour.rb`
- `lib/idml/render/text_wrap_resolver.rb`
- `spec/idml/render/text_wrap_resolver_spec.rb`
