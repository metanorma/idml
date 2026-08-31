# TODO PDF 153: Keep options in vertical writing

## Status: COMPLETE (approximation) — implemented 2026-08-31

## Problem

Keep options (TODOs 123/127/133) applied only to the horizontal
engine; vertical paragraphs split across frames regardless of
KeepAllLinesTogether / KeepWithNext.

## Solution

`VerticalEmit.vertical_render` consults a keep check BEFORE
placing each paragraph (deferral after placement cannot un-emit):

- **KeepAllLinesTogether** defers the paragraph wholly to the
  next frame when its column need exceeds the remaining columns.
- **KeepWithNext** also defers when the follower's forced break
  or column need would strand it.
- Never defers the frame's first paragraph — the same progress
  guarantee as KeepPolicy (shared: `KeepPolicy.paragraph_break?`).

Approximation: column need = runs count (one column per run),
which under-estimates runs spanning several columns — deferral
errs toward placing. KeepFirstLines/KeepLastLines windows remain
horizontal-only (they are line-window concepts).

## Files

- `lib/idml/render/renderers/vertical_emit.rb`
- `spec/idml/render/vertical_render_spec.rb`
