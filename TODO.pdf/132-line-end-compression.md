# TODO PDF 132: Line-end punctuation compression (mojikumi subset 2)

## Status: COMPLETE — implemented 2026-08-23

## What was done

`CjkLayout.apply_line_end_compression`: a CJK line whose final
glyph is full-width closing punctuation (。、」』）］｝ー etc.) renders
that glyph at half advance (行末約物半角詰め), tightening the line
as InDesign's default mojikumi does. Applied in LineBreaker's CJK
post-pass after kinsoku shori, so horizontal and vertical layout
both benefit.

Also fixed a latent bug the specs caught: kinsoku's return value
(new dup'd line array) was discarded when composing the post-pass
chain — kinsoku adjustments silently vanished once a second
post-pass followed it.

## Remaining from TODO 13

Per-pair punctuation compression tables (full class-based
mojikumi).
