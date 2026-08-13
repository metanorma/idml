# TODO PDF 103: Drop caps (DropCapLines, DropCapCharacters)

## Status: DONE — `Render::DropCap` helper computes drop-cap geometry.
TextFrameRenderer.emit_drop_cap emits the enlarged glyph, strips the
drop cap characters from the first run (no double render), and
applies reduced wrap width for the first `drop_cap_lines` runs so
text wraps around the drop cap. Approximation: treats each run as
one line (real per-line tracking would require line-count-aware
wrapping).
enlarged glyph; subsequent paragraph text flows normally and may
overlap the drop cap. Real wrap-around (indent lines 1..M to the
right of the drop cap) requires per-line wrap-width control in
VerticalLayout, which is a bigger refactor. Tracked as follow-up.

## Problem

`ParagraphStyleRange` carries:

- `DropCapLines` (integer) — number of lines the drop cap spans
- `DropCapCharacters` (integer) — number of characters in the drop cap
- `DropcapDetail` (integer) — bitmap of effects

The renderer ignores these. Documents that use drop caps (very
common in magazine/book layouts) currently render with no drop cap.

## What needs to happen

1. When `DropCapCharacters > 0` and `DropCapLines > 1`, treat the
   first `DropCapCharacters` characters as a drop cap:
   - Increase their font size to `DropCapLines × line_height`.
   - Wrap subsequent lines around the drop cap's width.
2. This requires the layout to track the drop-cap region and
   indent lines 1..DropCapLines on the left.

## Acceptance criteria

- [ ] PSR with DropCapLines=3, DropCapCharacters=1 renders the first
      character at 3× line height.
- [ ] Lines 2 and 3 are indented right by the drop cap's width.

## Dependencies

- TODO 94 (VerticalLayout needs to support drop-cap regions).
