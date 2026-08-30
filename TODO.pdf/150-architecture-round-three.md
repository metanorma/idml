# TODO PDF 150: Architecture review round three — seam repairs

## Status: COMPLETE — implemented 2026-08-30

## Problem

Round-three review findings (after TODOs 148-149):

1. **Page-dimensions seam leak (bug)**: `ImageCollector` and
   `HyperlinkEmitter` received a hardcoded `DEFAULT_HEIGHT = 792`
   while pages rendered at per-page dimensions — both use the
   height for the IDML→PDF y-flip, so images and link rectangles
   misplaced on any non-letter page.
2. **Dead interface kept alive by its tests**:
   `TextWrapResolver#overlap_width` (+ `line_overlap`) had zero
   lib callers since TODO 138 — only its own spec — and encoded
   sum-semantics for multiple contours where the real interface
   (`wrap_adjustment`) uses max. The spec suite asserted behavior
   the renderer no longer had.
3. **Thirteen copies of the synthetic-package triplet**: every
   engine-path spec repeated `Dir.mktmpdir → Package.write →
   Package.new`, with drifting names and inconsistent part sets.

## Solution

- Pipeline threads per-page `dims[:height]` into both consumers;
  the constants stay only as `page_dimensions_for` fallbacks.
- `overlap_width` / `line_overlap` deleted; all 15 spec call
  sites migrated to `wrap_adjustment` (the "sums contours" spec
  now documents max-combination honestly). The polygon variant
  `WrapContour.overlap_width` stays — it is load-bearing.
- `build_package(parts, name)` helper in spec_helper; thirteen
  triplet copies replaced; three local helpers that shadowed the
  global renamed (`anchored_fixture`, `decorated_fixture`,
  `footnote_fixture`, `endnote_fixture`, `footnote_package`).

## Files

- `lib/idml/render/pipeline.rb`
- `lib/idml/render/text_wrap_resolver.rb`
- `spec/spec_helper.rb` + 13 spec files
