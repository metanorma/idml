# TODO PDF 124: Tate-chu-yoko and vertical multi-run columns

## Status: COMPLETE — implemented 2026-08-20

## What was done

- Multi-run column continuity (bug fix): every run in a vertical
  frame used to restart at column 0, overlapping earlier runs.
  `VerticalTextLayout.layout` takes `start_column`; the frame
  renderer threads the next-unused column across runs and
  paragraphs, and persists it in the chain state (`column_offset`)
  so vertical text continues correctly into the next frame of a
  chain.
- Tate-chu-yoko (`Tatechuyoko="true"` on the CSR — note the
  schema's lowercase c): the run's glyphs render HORIZONTALLY,
  sharing one baseline at the top of their column slot and centered
  in it, consuming one column. Groups wider than the column height
  fall back to stacked layout. StyledRun carries `tatechuyoko`.

## Remaining from TODO 13

Mojikumi (punctuation spacing classes) is the last documented
stretch goal.
