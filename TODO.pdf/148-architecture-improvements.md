# TODO PDF 148: Codebase architecture improvements

## Status: COMPLETE — implemented 2026-08-29

## Problem

Architecture audit findings:

1. `TextFrameRenderer` was a 1520-line god class owning four
   unrelated concerns: the horizontal shaping engine, the vertical
   writing path, the no-metrics fallback, and everything else
   (chains, endnotes, footnotes, wrap, keep options).
2. Twelve render specs each declared their own near-identical
   `*_FONT_CANDIDATES` list (~7 lines each), with two variants
   drifting apart (some lists lacked the CJK-capable fonts —
   CJK-dependent specs silently skipped on platforms that had
   them).

## Solution

- **VerticalEmit** (`renderers/vertical_emit.rb`, ~230 lines): the
  whole vertical-writing family (vertical_render through
  ruby_vertical_x), extracted as a class-methods module
  `extend`ed into TextFrameRenderer — it shares the host's
  constants, `layout_frame`, and `font_for_run` (MECE: the module
  owns everything vertical; the host owns the horizontal engine).
  Zero behavior change; all vertical/ruby specs pass untouched.
- **SimpleText** (`renderers/simple_text.rb`, ~90 lines): the
  no-metrics fallback (simple_render, footnote stacking,
  collect/build rich runs), same extend pattern.
- **Spec font candidates DRY'd**: `SPEC_FONT_CANDIDATES` +
  `spec_font_path` in spec_helper; the twelve per-spec constants
  deleted. Unifying on the CJK-capable superset un-skipped 20
  previously-skipped examples on CJK-font platforms.

`TextFrameRenderer` is now 1235 lines of cohesive horizontal
engine + orchestration.

## Files

- `lib/idml/render/renderers/vertical_emit.rb` (new)
- `lib/idml/render/renderers/simple_text.rb` (new)
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/render.rb`
- `spec/spec_helper.rb` + 12 render specs
