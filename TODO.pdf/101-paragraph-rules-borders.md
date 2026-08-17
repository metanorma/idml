# TODO PDF 101: Paragraph borders and rules (RuleAbove, RuleBelow, ParagraphBorder)

## Status: COMPLETE — implemented 2026-08-17

## What was built

- RuleAbove / RuleBelow (earlier milestone): horizontal rules at
  paragraph top/bottom with weight / tint / offset / indent /
  TextWidth-ColumnWidth modes, via `Render::ParagraphRules`.
- Rule colors now resolve from `Properties > RuleAboveColor` /
  `RuleBelowColor` (typed value elements) with StrokeColor fallback —
  modeled via `Elements::TypedValue` + Properties mapping, PSR/CSR
  now carry `properties` collections.
- ParagraphShading: fill rect behind the paragraph block. Color from
  `Properties > ParagraphShadingColor`, tint scaling, ParagraphShading
  width mode (ColumnWidth default / TextWidth), four outward offsets.
  `TextEngine::Measurement` pre-measures the paragraph's height so
  the rect is known before the lines are laid out (clamped to the
  frame's bottom limit when the paragraph splits).
- ParagraphBorder: per-side strokes around the same block rect, each
  side with its own line weight and the border offsets/tint/color
  (Properties > ParagraphBorderColor). Shading and border share one
  extent so they always agree.

## Known limitations

- Border corner radii and gap colors are parsed on the model but not
  rendered; MergeConsecutiveParaBorders (merged rects across like-
  bordered paragraphs) is not modeled.
- DisplayIfSplits: when a paragraph splits across frames, both
  shading and border are drawn around the rendered portion only.

## Acceptance criteria

- [x] PSR with RuleAbove=true and RuleAboveLineWeight=2 draws the
      rule above the paragraph.
- [x] PSR with RuleAboveOffset=4 leaves a 4pt gap.
- [x] PSR with ParagraphShadingOn=true and tint fills the paragraph
      rect.
- [x] ParagraphBorderOn draws per-side strokes.

## Dependencies

- TODO 94 (VerticalLayout knows the paragraph's rect) — satisfied.
