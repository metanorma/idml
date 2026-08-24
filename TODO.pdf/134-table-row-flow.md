# TODO PDF 134: Table row flow across chained frames (design)

## Status: OPEN — design 2026-08-24, implementation pending

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

## Why deferred

Row-level flow must coordinate with the text chain state and
multi-column frames; the schema-faithful SchemaLayout already
computes per-row heights, so the mechanics are clear, but the
interaction matrix (chain resume, columns, vertical mode) needs
its own focused round with dedicated fixtures.
