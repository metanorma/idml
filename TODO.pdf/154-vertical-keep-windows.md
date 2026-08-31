# TODO PDF 154: Vertical keep windows

## Status: COMPLETE (approximation) — implemented 2026-09-01

## Problem

KeepFirstLines / KeepLastLines windows (TODO 133) applied only to
the horizontal engine; vertical paragraphs ignored them.

## Solution

`VerticalEmit`'s pre-placement keep check (TODO 153) also honors
the windows on the same column-count approximation: a splitting
paragraph (needed columns > available) defers when fewer than
KeepFirstLines columns fit, or when the stranded tail would hold
fewer than KeepLastLines columns.

## Files

- `lib/idml/render/renderers/vertical_emit.rb`
- `spec/idml/render/vertical_render_spec.rb`
