# TODO PDF 146: NextColumn wrap behavior

## Status: COMPLETE (approximation) — implemented 2026-08-28

## Problem

NextColumnTextWrap approximated as the bounding box (text narrowed
beside the object). InDesign moves the text to the next COLUMN.

## Solution

NextColumnTextWrap now joins JumpObjectTextWrap in the jump path:
the object blocks the full frame width and the run skips below
the object's bottom edge. In a single-column frame this matches
InDesign's visible outcome (the "next column" is below).

Remaining approximation (documented in TODO.pdf/61): in a
MULTI-column frame, true NextColumn jumps to the next column in
the same frame — that needs column-jump chain integration, which
stays a future enhancement.

## Files

- `lib/idml/render/text_wrap_resolver.rb`
- `spec/idml/render/text_wrap_resolver_spec.rb`
