# TODO PDF 119: Justification word/letter spacing limits

## Status: COMPLETE — implemented 2026-08-19

## Problem

`TextEngine::Justifier` stretched inter-word spaces without limit
under full justification — a line with one space could widen that
gap across the whole column. IDML paragraphs declare
MaximumWordSpacing / MaximumLetterSpacing (percentages,
InDesign defaults 133% word, 0% letter) that cap how justification
slack is distributed.

## What was done

- `Justifier::SpacingLimits` (max_word_spacing, max_letter_spacing
  percentages). `Justifier.justify` takes `limits:`.
- Distribution: spaces stretch up to the word-spacing cap
  (capacity = Σ natural_space_width × (max−100)/100); any residual
  slack goes to letter spacing — an even per-glyph addition capped
  at max_letter_spacing% of the natural space width. With
  InDesign's default letter cap of 0%, residual slack stays
  unfilled and the line ends short, matching InDesign's behavior
  when limits bind.
- `StyleResolver::Paragraph` carries maximum_word_spacing /
  maximum_letter_spacing from the PSR; the frame renderer and the
  footnote layout both pass the limits.

## Known limitations

- Glyph scaling (Minimum/Maximum/DesiredGlyphScaling) is not
  applied as a last resort.
- Minimum word/letter spacing (line compression) is unused — this
  justifier only ever stretches (slack ≥ 0).
