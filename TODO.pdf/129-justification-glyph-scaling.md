# TODO PDF 129: Justification glyph scaling

## Status: COMPLETE — implemented 2026-08-23

## What was done

`Justifier` distributes any residual slack remaining after the
word-spacing and letter-spacing caps as uniform glyph scaling,
capped at `MaximumGlyphScaling` (PSR → Paragraph → SpacingLimits).
InDesign's default cap (100%) disables scaling — only documents
that relax the cap get stretched glyphs, matching TODO 119's
layered distribution: words first, then letters, then glyphs.

## Known limitations

- MinimumGlyphScaling (compression of overlong lines) is not
  applied — the breaker never produces overlong justified lines
  except forced unbreakable runs.
