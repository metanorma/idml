# TODO PDF 13: CJK text layout

## Goal

Extend the text engine to handle CJK (Chinese, Japanese, Korean)
text layout: vertical writing, Tate-Chu-Yoko, Ruby annotations,
kinsoku shori (line-breaking rules), and CJK-specific punctuation
handling.

## Acceptance criteria

- [ ] CJK font metrics (square glyphs — equal advance width and
      height).
- [ ] Vertical text mode (StoryOrientation = Vertical).
- [ ] Kinsoku shori (禁止処理): no line start/end with forbidden
      characters.
- [ ] Tate-Chu-Yoko (縦中横): horizontal digits in vertical text.
- [ ] Ruby (ルビ) annotation positioning.
- [ ] Mojikumi (文字組) spacing classes.
- [ ] Spec: layout a Japanese paragraph in vertical mode.

## Files

- `lib/idml/text_engine/cjk_layout.rb`
- `spec/idml/text_engine/cjk_layout_spec.rb`

## Design notes

- CJK text layout is a significant expansion of the text engine.
  It shares the Shaper and FontMetrics layers but needs its own
  LineBreaker (kinsoku rules) and VerticalLayout (rotated glyphs).
- IDML documents the StoryOrientation attribute on StoryPreference.
  Horizontal = LeftToRightDirection, Vertical = TopToBottom.
- This TODO is a stretch goal — most IDML → PDF use cases are
  Latin-script. CJK users should use InDesign Server for
  pixel-perfect output.

## Dependencies

- TODOs 01–05 (text engine foundation).
