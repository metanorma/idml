# TODO PDF 43: Text frame insets

## Status: DONE — `Elements::TextFramePreference` carries the inset
attributes (InsetTop / InsetLeft / InsetBottom / InsetRight).
`TextFrameRenderer` subtracts them from the frame bounds before
layout. See `lib/idml/elements/text_frame_preference.rb`,
`lib/idml/render/renderers/text_frame_renderer.rb`.

## Goal

Respect `TextFramePreference` inset margins (InsetTop, InsetLeft,
InsetBottom, InsetRight) when laying out text within a TextFrame.

## Acceptance criteria

- [ ] TextFramePreference model has inset attributes (add if missing).
- [ ] TextFrame exposes `text_frame_preference` child.
- [ ] TextFrameRenderer subtracts insets from frame bounds before layout.
- [ ] Spec: TextFrame with InsetTop=20, verify text starts 20pt below frame top.

## Dependencies

- TODO 27 (text engine integration).
