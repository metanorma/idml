# TODO PDF 18: Text rendering from stories

## Status: DONE — `TextFrameRenderer` resolves `ParentStory` via
`Package#story_by_id`, walks PSR → CSR → Content, and renders styled
runs through the text engine. See
`lib/idml/render/renderers/text_frame_renderer.rb` and TODOs 27, 67.

## Goal

Wire the text engine to actual IDML story content. Extract text from
Stories, map them to TextFrame positions, and render via the text engine
pipeline (Shaper → LineBreaker → Justifier → VerticalLayout).

## Why

The text engine exists (TODOs 01–05) but `SpreadRenderer#render_stories`
returns "". No text appears in the output PDF.

## Acceptance criteria

- [ ] For each TextFrame on a spread, resolve `ParentStory` to a
      `Parts::Story` via `package.story_by_id(story_id)`.
- [ ] Extract text content from the Story's ParagraphStyleRange →
      CharacterStyleRange → Content chain.
- [ ] Pass styled text runs through the text engine (Shaper → LineBreaker
      → Justifier → VerticalLayout).
- [ ] Emit PDF text operators (BT/Tf/Td/Tj/ET) for positioned glyphs.
- [ ] TextFrame inset margins (TextFrameOffset) respected by the layout.
- [ ] Spec: render a TextFrame with known text, verify PDF contains
      the text string in a Tj operator.

## Files

- `lib/idml/render/text_renderer.rb` (new)
- `lib/idml/render/spread_renderer.rb` (dispatch to TextRenderer)
- `lib/idml/package.rb` (add `story_by_id`)
- `spec/idml/render/text_renderer_spec.rb`

## Design notes

- Story text extraction: `CharacterStyleRange#text_content` already
  exists and recursively joins Content elements.
- Font/size from CharacterStyleRange: `applied_font`, `point_size`,
  `fill_color` attributes.
- The TextFrame's ItemTransform + GeometricBounds gives the frame
  rectangle; the text engine lays out within it (minus insets).
- For now, handle single-style runs. Multi-style (mixed fonts/sizes in
  one line) is a stretch goal.

## Dependencies

- TODOs 14–16 (element models + typed pipeline).
- TODO 02 (FontResolver).
