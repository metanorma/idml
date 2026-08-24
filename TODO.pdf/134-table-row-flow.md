# TODO PDF 134: Table row flow across chained frames (design)

## Status: COMPLETE — implemented 2026-08-24

## Problem

Tables render within a single frame box (TableRenderer#
render_in_box). A table taller than its frame overflows invisibly;
continuation frames do not receive the remaining rows, and header
rows never repeat (HeaderRowCount).

## Design

1. `TableRenderer.render_schema_faithful` gains `start_row:` and a
   frame-bottom clip: rows render while the row's bottom edge
   stays above the limit; the first row crossing it stops the walk
   and the renderer returns `next_start_row` (nil when the table
   completed).
2. Header repeat: for continuation calls (start_row > 0) with
   HeaderRowCount > 0, re-emit header rows at the top of the
   continuation area and reduce its available height accordingly.
3. State threading: `StoryChainController::State` gains
   `tables_remaining` — an array of [table, start_row] pairs.
   `render_inline_tables` consumes the chain head's story tables
   plus any carried-over remainders, appending unfinished pairs
   back for the next frame.
4. Footer rows (FooterRowCount) stay with the table's final chunk.

## Implementation notes (2026-08-24)

Delivered per the design above: `render_in_box` takes `start_row:`
and `bottom_limit:`, renders whole rows while their bottom edge
stays above the limit, re-emits HeaderRowCount header rows on
continuations, and returns the next unrendered row (nil when
complete). `StoryChainController::State` carries `tables_remaining`
([table, start_row] pairs); `render_inline_tables` renders fresh
story tables on chain heads plus carried remainders, storing
unfinished tables back for the next frame. `fresh_state` now keeps
table-only stories alive (previously a story with no paragraphs
produced a nil state and its tables never rendered).

Known limitations: row-spanning cells break at frame boundaries
(a span cell crossing the limit renders at its start frame only);
footer rows render with their chunk (no forced keep-with-end);
multi-column frames flow tables across the full box width.
