# TODO PDF 103: Drop caps (DropCapLines, DropCapCharacters)

## Status: OPEN — gap identified in 2026-08-08 audit

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
