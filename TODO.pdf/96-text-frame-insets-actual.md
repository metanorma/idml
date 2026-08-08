# TODO PDF 96: TextFramePreference insets honored in layout

## Status: DONE — layout_frame helper reads TextFramePreference
insets and passes them to the Frame struct; VerticalLayout honors
them in positioning and wrap_width.

## Problem

`Elements::TextFramePreference` carries the four text insets:

- `InsetTop`
- `InsetLeft`
- `InsetBottom`
- `InsetRight`

`TextFrame#text_frame_preference` exposes the typed child. But
`TextFrameRenderer#frame_box` reads only `Placement.box(frame, ...)`
— it doesn't subtract insets from the box before laying out text.

Result: text starts at the frame's geometric edge, ignoring the
inset margin the document declared. Visually wrong for any frame
that uses non-zero insets (which is most real-world IDML documents).

## What needs to happen

1. `frame_box` reads `frame.text_frame_preference` and extracts
   `inset_top`, `inset_left`, `inset_bottom`, `inset_right`.
2. Subtracts left/right from `box[:width]`, adds left to `box[:x]`.
3. Subtracts top/bottom from `box[:height]`, adds bottom to `box[:y]`.
4. Passes the resulting inset-aware box to VerticalLayout.

## Acceptance criteria

- [ ] TextFrame with InsetTop=20 lays first line 20pt below frame top.
- [ ] TextFrame with InsetLeft=15 shifts first glyph 15pt right of frame left.
- [ ] TextFrame with no TextFramePreference child renders as today (zero insets).
- [ ] Spec: parse fixture TextFrame, verify insets honored.

## Dependencies

- TODO 94 (VerticalLayout delegation uses the inset-adjusted box).
