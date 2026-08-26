# TODO PDF 135: MinimumGlyphScaling justification compression

## Status: COMPLETE — implemented 2026-08-26

## Problem

InDesign's justification dialog exposes MinimumGlyphScaling: overlong
justified lines may squeeze glyphs uniformly down to that percent.
The gem applied only MaximumGlyphScaling (stretching, TODO 129) —
overlong lines overflowed the frame instead of compressing.

## Solution

`TextEngine::Justifier#justify_line` now handles negative slack:
`compress_glyphs` scales every glyph uniformly, capped at
`min_glyph_scaling` percent (default 100 disables it, matching
InDesign). The limit threads through `SpacingLimits#min_glyph_scaling`,
resolved from the PSR's `MinimumGlyphScaling` via `StyleResolver`
(`Paragraph#minimum_glyph_scaling`) and applied at both call sites
(frame renderer and footnote layout).

## Files

- `lib/idml/text_engine/justifier.rb`
- `lib/idml/render/style_resolver.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/render/footnote.rb`
- `spec/idml/text_engine/text_engine_spec.rb`
