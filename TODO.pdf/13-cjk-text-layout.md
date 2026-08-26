# TODO PDF 13: CJK text layout

## Status: COMPLETE — final mojikumi pair compression landed
2026-08-26. Vertical writing (2026-08-19), kinsoku shori, ruby,
tate-chu-yoko, script spacing, and line-end compression were
already in.

## Vertical mode (2026-08-19)

- `StoryInner` now parses `StoryPreference` (StoryOrientation).
- `TextEngine::VerticalTextLayout` stacks glyphs UPRIGHT in
  columns flowing right-to-left (CJK ideographs render correctly;
  Latin glyphs are not rotated — documented approximation), reusing
  LineBreaker (so kinsoku applies) against the column height.
- `TextFrameRenderer` takes the vertical path when the story
  declares Vertical: paragraphs flow as glyph columns, runs start
  fresh columns, overflow chains to the next frame. Paragraph
  spacing/rules/decorations and ruby repositioning are not applied
  in vertical mode.
- LineBreaker now breaks unspaced CJK runs PER CHARACTER at the
  frame width (previously they overflowed as one long line) — this
  also fixes horizontal CJK wrapping.

2026-08-20 completions: tate-chu-yoko (TODO 124), Latin rotation
and vertical ruby (TODO 122), CJK/Latin automatic script spacing
(TODO 125, a mojikumi subset wired into Shaper). Final piece (2026-08-26): class-based pair compression — a
full-width closing/middle glyph followed by another full-width
punctuation compresses to half advance within the line (。」、
ー）… pairs), completing the three real mojikumi behaviors of
InDesign's default sets alongside script spacing (TODO 125) and
line-end compression (TODO 132). See `lib/idml/text_engine/cjk_layout.rb` and
`lib/idml/text_engine/vertical_text_layout.rb`.

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
