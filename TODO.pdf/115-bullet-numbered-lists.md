# TODO PDF 115: Bullet and numbered list rendering

## Status: DONE — markers are prepended inline AND a hanging indent
(18pt) is applied so wrapped lines align with text after the marker.
The indent is approximate (fixed width) since tab-stop measurement
requires font metrics at style-resolution time; future refinement
would measure the actual marker width.

## Problem

`Elements::ParagraphStyleRange` carries a large set of bullets and
numbering attributes (BulletsAndNumberingListType, NumberingExpression,
BulletsTextAfter, NumberingLevel, NumberingContinue, NumberingStartAt,
BulletsAlignment, NumberingAlignment, BulletCharacterType,
BulletCharacterValue, RestartPolicy, LowerLevel, UpperLevel).

The renderer ignores all of these. Lists appear in the PDF as plain
paragraphs without bullet markers or numbering.

Real documents (technical specs, tutorials, procedures, contracts)
use lists extensively.

## What needs to happen

1. Read BulletsAndNumberingListType from PSR:
   - "BulletList" → emit a bullet glyph at the paragraph's start
   - "NumberedList" → emit a number/letter at the paragraph's start
2. Apply BulletsAlignment (left/center/right) within a hanging-indent
   gutter.
3. Auto-increment numbering per NumberingLevel +
   NumberingContinue + NumberingStartAt rules.
4. Honor RestartPolicy for sub-list restart behavior.
5. BulletCharacterValue picks the glyph (Unicode codepoint).

Architecture: list markers prepend the paragraph's first run; the
renderer needs an in-memory counter per numbering chain (similar
to StoryChainController).

## Acceptance criteria

- [ ] PSR with BulletsAndNumberingListType="BulletList" renders a
      bullet glyph before the paragraph's first character.
- [ ] PSR with BulletsAndNumberingListType="NumberedList" renders
      a sequential number, auto-incremented per chain.
- [ ] BulletsTextAfter (e.g., ". ", ") ") honored as the marker's
      suffix.

## Dependencies

- None — independent feature work on PSR.
