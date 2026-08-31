# TODO PDF 152: RTL paragraph alignment

## Status: COMPLETE — implemented 2026-08-31

## Problem

ParagraphDirection (LeftToRightDirection /
RightToLeftDirection) was parsed but unused: RTL paragraphs
aligned left/right by LTR convention, so Arabic/Hebrew text sat
on the wrong edge.

## Solution

`StyleResolver::Paragraph` carries `paragraph_direction` (PSR or
paragraph style); `TextEngine::Justifier` gains a `direction:`
argument that mirrors the visual alignment under
RightToLeftDirection — left↔right, start↔end; center and
justified unchanged. Both justify call sites (frame renderer and
footnote layout) pass the paragraph's direction.

## Files

- `lib/idml/text_engine/justifier.rb`
- `lib/idml/render/style_resolver.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/render/footnote.rb`
- `spec/idml/text_engine/text_engine_spec.rb`
