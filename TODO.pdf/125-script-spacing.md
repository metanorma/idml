# TODO PDF 125: CJK/Latin automatic script spacing (mojikumi subset)

## Status: COMPLETE — implemented 2026-08-20

## What was done

- `TextEngine::CjkLayout.apply_script_spacing` widens the leading
  glyph by an eighth em at every CJK ↔ ASCII alphanumeric boundary
  — InDesign's default inter-script auto spacing (a mojikumi
  behavior).
- Wired inside `TextEngine::Shaper#shape`, so every shaping path
  (horizontal frame text, footnotes, ruby, vertical columns)
  applies it uniformly — one integration point, no per-caller
  changes.
- Punctuation neighbors are ignored (only letters/digits form
  boundaries).

## Remaining from TODO 13

Class-based mojikumi (per-pair punctuation compression tables,
line-end punctuation hanging beyond half-em) remains a documented
stretch goal.
