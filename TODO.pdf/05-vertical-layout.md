# TODO PDF 05: Vertical layout

## Goal

Position lines vertically within a text frame: leading, paragraph
spacing, drop caps, inset margins.

## Acceptance criteria

- [ ] `Idml::TextEngine::VerticalLayout.layout(lines:, frame:,`
      `paragraph_attrs:)` returns positioned glyphs with final
      (x, y) coordinates.
- [ ] Leading: each line advances by `font_size * auto_leading`
      (default 1.2) or the explicit Leading attribute.
- [ ] Paragraph spacing: SpaceBefore added before the first line
      of each paragraph; SpaceAfter after the last.
- [ ] First-line indent: FirstLineIndent offset on the first line
      of each paragraph.
- [ ] Left/right indent: LeftIndent / RightIndent shrink the
      effective frame width.
- [ ] Frame insets: InsetSpacing (top, bottom, left, right) from
      the TextFrame's TextFramePreference.
- [ ] Spec: layout a 3-paragraph text block, verify Y positions
      respect leading + spacing.

## Files

- `lib/idml/text_engine/vertical_layout.rb`
- `spec/idml/text_engine/vertical_layout_spec.rb`

## Design notes

- IDML's coordinate system: origin bottom-left, y increases
  upward. The vertical layout works top-down (first line at top
  of frame) and emits y coordinates in IDML convention.
- Drop caps (DropCapLines, DropCapCharacters) are a stretch goal
  — they require enlarging the first N characters' font size and
  wrapping text around them.

## Dependencies

- TODOs 03, 04 (Shaper, LineBreaker).
