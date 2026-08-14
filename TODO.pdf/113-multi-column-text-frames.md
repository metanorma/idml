# TODO PDF 113: Multi-column text frames (TextColumnCount, TextColumnGutter)

## Status: DONE — engine_render detects TextColumnCount > 1 and
splits the frame into N column-specific Frame structs. Text flows
column 1 → column 2 → ... → chain to next frame via StoryChainController.
Each column acts as a mini-frame with the same height/insets but a
narrower width. TextColumnGutter honored as the gap between columns.

## Problem

`Elements::TextFramePreference` declares:
- `TextColumnCount` — number of text columns in the frame (1-40)
- `TextColumnGutter` — gap between columns (in points)
- `TextColumnFixedWidth` — width of each column when uniform
- `UseFixedColumnWidth` — boolean
- `UseFlexibleColumnWidth` — boolean
- `TextColumnMaxWidth` — max column width when flexible

Real-world documents frequently use multi-column layouts
(magazines, newspapers, technical reports, brochures). Today the
renderer treats every text frame as a single column, ignoring
TextColumnCount > 1.

Effect: multi-column stories render as one wide column that over-
laps adjacent content. The PDF is unreadable for multi-column docs.

## What needs to happen

1. `TextFrameRenderer` reads `text_frame_preference.text_column_count`.
2. When > 1: split the frame's text area into N columns separated
   by `text_column_gutter`.
3. Render text column-by-column: column 1 fills top-to-bottom,
   overflow continues at top of column 2, etc.
4. StoryThreader chain state threads across columns WITHIN a frame
   before crossing to the next frame.
5. Optional: support TextColumnFixedWidth vs flexible-width
   distribution.

Architecture: this combines TODO 108 (chain flow) with column
awareness. Each column acts like a mini-frame in the chain.

## Acceptance criteria

- [ ] TextFrame with TextColumnCount=2 renders two side-by-side columns.
- [ ] Text overflows from column 1 → column 2 → next frame.
- [ ] TextColumnGutter honored as the gap between columns.
- [ ] Single-column frames render as today.

## Dependencies

- TODO 108 (multi-frame story flow) — column-to-column flow uses
  the same chain state mechanism.
