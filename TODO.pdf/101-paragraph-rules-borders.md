# TODO PDF 101: Paragraph borders and rules (RuleAbove, RuleBelow, ParagraphBorder)

## Status: PARTIAL — RuleAbove and RuleBelow implemented via new
`Render::ParagraphRules` helper; TextFrameRenderer emits them at
paragraph top/bottom. Rule color comes from PSR#stroke_color (IDML's
PSR doesn't have a dedicated RuleAboveColor attribute). RuleAboveWidth
"Text" vs "Column" honored. Tint scaling + line weight + offset honored.

ParagraphBorder and ParagraphShading remain open — they need the
paragraph's bounding rect, which the renderer doesn't currently
expose to ParagraphRules. Will add when a real document fixture
exercises them.

## Problem

`ParagraphStyleRange` carries:

- `RuleAbove`, `RuleAboveLineWeight`, `RuleAboveTint`, `RuleAboveOffset`,
  `RuleAboveLeftIndent`, `RuleAboveRightIndent`, `RuleAboveWidth`
- `RuleBelow`, `RuleBelowLineWeight`, `RuleBelowTint`, `RuleBelowOffset`,
  `RuleBelowLeftIndent`, `RuleBelowRightIndent`, `RuleBelowWidth`
- `ParagraphBorderOn`, `ParagraphBorderTopLineWeight`,
  `ParagraphBorderLeftLineWeight`, etc.
- `ParagraphShadingOn`, `ParagraphShadingTint`, `ParagraphShadingColor`

None of these are rendered today. Real-world documents use RuleAbove
heavily for headings ("section divider line"), and ParagraphShading
for callouts.

## What needs to happen

1. After laying out a paragraph, emit RuleAbove as a horizontal line
   above the first line, with the rule's weight/tint/color/offset/indent.
2. Emit RuleBelow similarly below the last line.
3. Optionally emit ParagraphBorder as a rectangle around the paragraph.
4. Optionally emit ParagraphShading as a fill behind the paragraph.

## Acceptance criteria

- [ ] PSR with RuleAbove=true and RuleAboveLineWeight=2 draws a 2pt
      horizontal line above the paragraph.
- [ ] PSR with RuleAboveOffset=4 leaves 4pt gap between rule and text.
- [ ] PSR with ParagraphShadingOn=true and tint fills the paragraph rect.

## Dependencies

- TODO 94 (VerticalLayout knows the paragraph's rect).
