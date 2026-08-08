# TODO PDF 100: Character-level styling (underline, strikethrough, caps, color)

## Status: OPEN — gap identified in 2026-08-08 audit

## Problem

`Elements::CharacterStyleRange` carries 284 character-level
attributes from the RNC. `StyleResolver::StyledRun` extracts only:
`text`, `font_style`, `point_size`, `fill_color`, `fill_tint`,
`applied_font`, `alignment`.

Untyped into the renderer (but modeled on CSR):

| Attribute         | Visual effect                                  |
|-------------------|------------------------------------------------|
| `Underline`       | underline rule under glyphs                    |
| `UnderlineOffset`, `UnderlineWeight`, `UnderlineTint`, `UnderlineColor` | fine underline control |
| `StrikeThru`      | strike-through rule through glyphs             |
| `StrikeThruOffset`, `StrikeThruWeight`, etc. | fine strike control |
| `Capitalization`  | AllCaps / SmallCaps / Title                    |
| `Position`        | Superscript / Subscript                        |
| `HorizontalScale`, `VerticalScale` | glyph scaling                   |
| `BaselineShift`   | vertical offset from baseline                  |
| `Skew`            | synthetic italic (glyph shear)                 |
| `Tracking`        | inter-letter spacing offset                    |
| `FillColor` / `FillTint` | text color (currently extracted but unused) |
| `StrokeColor` / `StrokeWeight` | text outline                       |
| `Ligatures`       | enable OpenType ligatures                      |
| `KerningMethod`   | metrics vs optical kerning                     |

Today the renderer emits a single `canvas.text` per line with a
single font + size — no underline, no strike, no color, no scaling.

## What needs to happen

1. Extend `StyledRun` to carry these character-level attributes.
2. After emitting each line's text, optionally:
   - Draw underline rule (`canvas.line` from start-x to start-x+width
     at baseline - underline_offset, with underline_weight).
   - Draw strike-through rule (similar, at baseline + offset).
3. Apply capitalization by uppercasing the text (or using SmallCaps
   OpenType feature when supported by the font).
4. Apply Position (super/subscript) by scaling the font size and
   shifting baseline.
5. Apply HorizontalScale / VerticalScale via canvas text matrix
   (`canvas.text` may need to be augmented, or emit raw cm + Tm).
6. Apply text fill color via `canvas.fill_color` before `canvas.text`.
7. Apply Tracking by inserting extra width per glyph (Shaper level).

## Acceptance criteria

- [ ] CSR with Underline=true draws a rule under each glyph in the run.
- [ ] CSR with Capitalization="AllCaps" uppercases the text.
- [ ] CSR with Position="Superscript" raises the baseline and shrinks size.
- [ ] CSR with FillColor="Color/Red" renders red text.
- [ ] CSR with HorizontalScale=150 widens glyphs by 50%.

## Dependencies

- TODO 94 (VerticalLayout delegation positions glyphs).
- pdfrb may need text-matrix helpers for skew/scale.
