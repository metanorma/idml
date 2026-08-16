# TODO PDF 114: Text wrap around shapes (TextWrapPreference)

## Status: DONE for BoundingBox mode — `Render::TextWrapResolver` computes
wrap contours from page items declaring TextWrapPreference with
TextWrapMode != "None". SpreadRenderer builds the resolver and passes
it via RenderContext. TextFrameRenderer's `text_wrap_overlap` queries
overlap at each run's y position and reduces the wrap width — text
flows around the shape instead of running over it.

Shape page items (Rectangle, Oval, Polygon, GraphicLine, Path) all
carry the TextWrapPreference child element. Non-shape items (Page,
Link) are filtered by WRAPPABLE_TYPES to avoid NoMethodError.

Per-run approximation: all lines in a run get the same reduced width.
True per-line adjustment (when a run spans the contour boundary)
requires line-count-aware layout. Shape mode (contour following) and
Inverse mode remain unsupported.

## Problem

IDML page items (Rectangle, Polygon, GraphicLine, Group, Image, EPS)
can declare a `<TextWrapPreference>` child that controls how text
in neighboring TextFrames wraps around the item. Settings include:

- WrapMode: None / Jump / Next / Bounding Box / Shape / Drop Cap
- Contour: the wrap boundary (could differ from the visual shape)
- Inverse: text wraps INSIDE the contour (rare)
- OffsetTop/Left/Bottom/Right: additional margin around the contour

Real documents wrap text around images and callout boxes constantly.
Without text wrap support, overlapping items produce unreadable
output — text from one frame runs over a graphic in another.

Today TextFrameRenderer knows nothing about TextWrapPreference on
other page items. It renders into the frame's full geometric
rectangle regardless of overlapping wrap contours.

## What needs to happen

1. `Render::TextWrapResolver` reads TextWrapPreference from all
   page items in the spread and indexes their contours by Self.
2. Per TextFrame: compute the intersection of the frame's text area
   with all wrap contours in the spread.
3. TextFrameRenderer queries the resolver per text line; each line's
   wrap width is reduced by the overlap on the left and right.
4. Lines that fall entirely inside a wrap region are skipped.

This is a substantial feature — wrap computation is non-trivial
(geometry intersection, contour following). Most documents use a
simple Bounding Box mode (rectangle subtract), which is tractable.

## Acceptance criteria

- [ ] TextWrapMode="BoundingBox" with an image inside the frame's
      bounds reduces wrap width on affected lines.
- [ ] TextWrapMode="None" (default) renders as today.
- [ ] OffsetTop/Left/Bottom/Right honored (expands the contour by
      the offsets).

## Dependencies

- TODO 108 (multi-frame story flow) — wrap-aware wrap width needs
  to combine with chain-threaded line layout.
- TODO 113 (multi-column) — wrap interacts with column boundaries.
