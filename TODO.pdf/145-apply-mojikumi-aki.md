# TODO PDF 145: Apply mojikumi aki to layout

## Status: COMPLETE — implemented 2026-08-28

## Problem

Two gaps: (a) `apply_script_spacing` (TODO 125) was implemented
but never wired into the render pipeline — CJK/Latin auto spacing
never actually applied; (b) the named mojikumi sets modeled in
TODO 144 were parsed but unused.

## Solution

- `CjkLayout.apply_script_spacing` now takes the document's aki
  overrides: when the designmap declares a `MojikumiTable`, each
  adjacent glyph pair whose classes match an
  `OverrideMojikumiAki` entry (Target/Side class ×
  SideIsAfterTarget) gets that entry's Desired spacing (em ×
  point size). Unlisted pairs keep the default eighth-em at
  CJK/Latin script boundaries.
- New `CjkLayout.mojikumi_class` classifies the seven InDesign
  mojikumi classes (ideograph, opening bracket, closing bracket,
  comma/period, middle dot, digit — incl. fullwidth, Latin —
  incl. fullwidth).
- `TextFrameRenderer#layout_run` applies the spacing between
  shaping and line breaking, using
  `mojikumi_aki_overrides(context)` (first named set from the
  designmap; empty when absent).

The result: documents declaring custom mojikumi now render their
declared inter-class spacing.

## Files

- `lib/idml/text_engine/cjk_layout.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `spec/idml/text_engine/cjk_layout_spec.rb`
