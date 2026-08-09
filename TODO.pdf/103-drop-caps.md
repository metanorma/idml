# TODO PDF 103: Drop caps (DropCapLines, DropCapCharacters)

## Status: PARTIAL — `Render::DropCap` helper computes drop-cap
geometry (font_size = base × lines, width via font_metrics.measure_text,
height = leading × lines). TextFrameRenderer.emit_drop_cap emits the
drop cap as an enlarged glyph at the paragraph's top-left when the
paragraph declares DropCapLines/DropCapCharacters > 0 and is the
chain's first paragraph.

Wrap-around text is NOT yet implemented — the drop cap renders as an
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
