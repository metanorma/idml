# TODO PDF 13: CJK text layout

## Status: PARTIAL — horizontal-mode CJK complete (2026-08-17):
CJK glyph measurement, kinsoku shori, and ruby annotations render.
Vertical writing mode, tate-chu-yoko, and mojikumi remain OPEN
stretch goals — they need a vertical (rotated) layout engine and
real vertical-mode fixtures to build against. See
`lib/idml/text_engine/cjk_layout.rb`.

## Progress 2026-08-17

- Kinsoku shori is now LIVE in the pipeline: LineBreaker.break
  post-processes any run containing CJK glyphs through
  CjkLayout.apply_kinsoku, so no rendered line starts with
  、。，」etc. or ends with 「 etc. (previously the logic existed
  but was never called).
- Ruby (phonetic annotations) render: CSR RubyString /
  RubyFontSize / RubyPosition extract onto the run; the renderer
  emits the annotation centered above the run's first line (half
  the base size by default; Below* positions place it under).
  Approximation: IDML attaches ruby to a character range; we
  annotate the whole first line.

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
