# TODO PDF 27: Text engine integration

## Goal

Wire the text engine (Shaper → LineBreaker → Justifier → VerticalLayout)
into TextFrame rendering. Currently text is dumped as a single run at a
hardcoded position. The text engine should lay out text within the
frame's geometry, respecting insets and applying word-wrap.

## Why

The text engine was built in TODOs 01–05 but never used. Text rendering
produces a single `Tj` with the first 200 characters at position (72,
page_height-72). Real layout requires shaping glyphs, breaking lines at
the frame width, and positioning each line at the correct baseline.

## Acceptance criteria

- [ ] TextFrameRenderer extracts text content from the linked Story.
- [ ] Text is shaped via `TextEngine::Shaper` using the resolved font.
- [ ] Lines broken via `TextEngine::LineBreaker` at frame width minus
      insets.
- [ ] Lines justified via `TextEngine::Justifier`.
- [ ] Glyphs positioned via `TextEngine::VerticalLayout`.
- [ ] PDF text operators emitted for each positioned glyph run.
- [ ] Falls back to simple text dump when no font metrics available.
- [ ] Spec: render a TextFrame with known text, verify multiple `Tj`
      operators (one per line) in the PDF.

## Files

- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/render/style_resolver.rb` (extract font/size from CSR)
- `spec/idml/render/text_frame_renderer_spec.rb`

## Dependencies

- TODO 26 (renderer registry).
- TODO 28 (path geometry for frame bounds).
- TODO 29 (character style extraction).
- TODOs 01–05 (text engine).
