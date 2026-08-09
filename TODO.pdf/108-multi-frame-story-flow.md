# TODO PDF 108: Multi-frame story flow (use StoryThreader)

## Status: DONE — `Render::StoryChainController` threads paragraph/run
state across linked TextFrames. TextFrameRenderer no longer treats
chain non-heads as standalone; it picks up leftover state from the
controller, renders what fits, and stores the new leftover for the
next frame. Overflow text is no longer silently dropped.

## Problem

`Render::StoryThreader` exists with specs (`spec/idml/render_layer_threader_spec.rb`).
It builds text-frame chains from PreviousTextFrame/NextTextFrame
links. The intent: a story flows across linked frames, with each
frame getting the lines that fit and overflow going to the next.

But `TextFrameRenderer` doesn't use it. The renderer treats each
frame independently:
- `chain_head?` filter skips non-head frames (correct — they'd
  double-render)
- Each chain-head frame renders its entire story from the top
- Overflow that doesn't fit is silently dropped

For real documents with multi-page stories (books, magazines,
newspapers), this loses text. The PDF shows only what fits in the
first frame.

## What needs to happen

1. TextFrameRenderer accepts the chain (list of frames) instead
   of one frame at a time.
2. For each chain:
   - Lay out story text starting at frame 1's top
   - When text overflows frame 1's bottom, continue at frame 2's top
   - Repeat until either text ends or chain ends
3. The PageItemRenderer dispatch needs to know about chains, not
   just per-item rendering.

Architecture: the chain context needs to live in RenderContext
(or a new RenderChainContext). Each frame's render call passes the
current y cursor + remaining paragraphs/runs/lines, and the next
frame's render call picks up where the previous left off.

## Acceptance criteria

- [ ] Story that overflows frame 1 continues in frame 2.
- [ ] Hyperlink rects resolve correctly across frames.
- [ ] Spec: 2 linked TextFrames, story of 50 lines, each frame fits
      20 lines → frame 1 shows lines 1-20, frame 2 shows 21-40,
      frame 3 (if present) shows 41-50.

## Dependencies

- None — independent feature work, but changes the renderer's
  per-frame abstraction significantly.
