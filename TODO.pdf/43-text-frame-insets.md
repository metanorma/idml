# TODO PDF 43: Text frame insets

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
