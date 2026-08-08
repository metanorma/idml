# TODO PDF 95: Paragraph spacing and indents (SpaceBefore, SpaceAfter, FirstLineIndent)

## Status: DONE — Paragraph struct carries these from PSR; renderer
passes them to VerticalLayout.layout_block.

## Problem

`ParagraphStyleRange` carries 284 attributes from the RNC schema.
Today the renderer honors exactly one of them: `Justification`
(via `StyleResolver::ALIGNMENT_MAP`).

The following paragraph-level layout attributes are typed on the
model but never read by the renderer:

| Attribute               | Effect on layout                                  |
|-------------------------|---------------------------------------------------|
| `SpaceBefore`           | vertical gap above the paragraph                  |
| `SpaceAfter`            | vertical gap below the paragraph                  |
| `FirstLineIndent`       | left offset for the first line only               |
| `LeftIndent`            | left offset for all lines                         |
| `RightIndent`           | right offset (shrinks frame width)                |
| `AutoLeading`           | multiplier (1.2 default) for line height          |
| `DropCapLines`          | drop-cap height in lines                          |
| `DropCapCharacters`     | drop-cap width in characters                      |
| `LastLineIndent`        | right offset for the last line                    |
| `MinimumWordSpacing`    | justification clamp                               |
| `MaximumWordSpacing`    | justification clamp                               |
| `DesiredWordSpacing`    | justification target                              |

## What needs to happen

1. Extend `StyledRun` (or wrap it in a `Paragraph` struct per TODO 94)
   to carry these attributes from PSR.
2. Wire `Justifier` to honor `Minimum/Maximum/DesiredWordSpacing`
   when distributing slack in justified text.
3. Wire `VerticalLayout` to honor `SpaceBefore` / `SpaceAfter` /
   `AutoLeading` (already accepts them, but the renderer doesn't pass them).
4. Wire `FirstLineIndent` / `LeftIndent` / `RightIndent` in VerticalLayout.

## Acceptance criteria

- [ ] `psr.space_before = 12` produces 12pt gap before the paragraph.
- [ ] `psr.first_line_indent = 24` indents only the first line by 24pt.
- [ ] `psr.left_indent = 18` indents all lines by 18pt.
- [ ] `psr.right_indent = 18` shrinks the line-wrap width by 18pt.
- [ ] `psr.auto_leading = 1.5` produces 1.5× line height.
- [ ] Word-spacing clamps apply in justified mode.

## Dependencies

- TODO 94 (VerticalLayout delegation).
