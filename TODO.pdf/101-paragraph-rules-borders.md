# TODO PDF 101: Paragraph borders and rules (RuleAbove, RuleBelow, ParagraphBorder)

## Status: OPEN — gap identified in 2026-08-08 audit

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
