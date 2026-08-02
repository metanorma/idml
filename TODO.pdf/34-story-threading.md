# TODO PDF 34: Story threading

## Goal

Follow the PreviousTextFrame/NextTextFrame chain to thread stories
across multiple text frames. A single story can flow through several
frames; the renderer must lay out text sequentially across the chain.

## Why

Currently each TextFrame is rendered independently using its full story
text. In reality, a story's text overflows from one frame to the next.
Frame A gets the first N lines, frame B gets the remainder.

## Acceptance criteria

- [ ] Pipeline identifies text frame chains (head frame = PreviousTextFrame=="n").
- [ ] Story text distributed across the chain: frame A gets lines that
      fit, overflow goes to frame B.
- [ ] Each frame renders only its portion of the story.
- [ ] Handles circular references gracefully (no infinite loop).
- [ ] Spec: two linked TextFrames, verify text splits across them.

## Files

- `lib/idml/render/story_threader.rb`
- `lib/idml/render/pipeline.rb` (identify chains)
- `spec/idml/render/story_threader_spec.rb`

## Dependencies

- TODO 27 (text engine integration).
