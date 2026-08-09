# TODO PDF 112: TextFrame vertical justification (TopAlign / CenterAlign / BottomAlign / JustifyAlign)

## Status: OPEN — gap identified in 2026-08-10 audit

## Problem

`Elements::TextFramePreference` carries `VerticalJustification`
(attribute VerticalJustification on TextFramePreference_Object in
Styles.rnc). Possible values: TopAlign, CenterAlign, BottomAlign,
JustifyAlign.

Today TextFrameRenderer always starts text at the top of the frame
(`cursor_y = box[:y] + box[:height] - inset_top`). For
`VerticalJustification="CenterAlign"` documents, the entire text
block should be vertically centered within the frame's text area;
for `BottomAlign`, text sits at the bottom.

This is a common layout requirement — callouts, captions, footers,
and sidebars often use bottom or center vertical justification.

## What needs to happen

1. `TextFrameRenderer#engine_render` reads
   `frame.text_frame_preference.vertical_justification`.
2. Compute the total content height (sum of all paragraph heights +
   space_before/after).
3. If VerticalJustification is CenterAlign: top-offset =
   (frame_text_area_height - content_height) / 2.
4. If BottomAlign: top-offset = (frame_text_area_height - content_height).
5. Adjust the initial `cursor_y` by top-offset before laying out
   the first paragraph.
6. JustifyAlign: distribute extra vertical space between paragraphs
   (more complex — defer).

## Acceptance criteria

- [ ] TextFrame with VerticalJustification="CenterAlign" centers
      text vertically in the frame.
- [ ] TextFrame with VerticalJustification="BottomAlign" aligns
      text to the bottom.
- [ ] TextFrame with VerticalJustification="TopAlign" (default)
      renders as today.
- [ ] Spec coverage per value.

## Dependencies

- TODO 108 (multi-frame story flow) — content_height calculation
  needs to consider all paragraphs that will render, which the
  chain state already tracks.
