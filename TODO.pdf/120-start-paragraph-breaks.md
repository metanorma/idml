# TODO PDF 120: StartParagraph frame/column breaks

## Status: COMPLETE — implemented 2026-08-19

## Problem

PSR `StartParagraph` (Anywhere / NextPage / NextColumn / NextFrame
/ NextOddPage / NextEvenPage) was parsed but ignored — forced-break
paragraphs (chapter headings, magazine copy) rendered mid-frame.

## What was done

- `StyleResolver::Paragraph` carries `start_paragraph` from the
  PSR.
- `TextFrameRenderer.consume_paragraphs` stops filling the current
  frame/column before a paragraph that requests a break (NextPage /
  NextColumn / NextFrame / NextOddPage / NextEvenPage) — as long as
  at least one paragraph was already placed there; the paragraph
  and everything after it flow to the next frame via the existing
  chain state. Multi-column frames break per column.

## Known limitations

- All break flavors act at frame/column granularity (NextPage and
  NextFrame are indistinguishable; odd/even page parity is not
  modeled — the renderer has no page-parity notion at this layer).
