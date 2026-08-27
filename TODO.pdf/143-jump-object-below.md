# TODO PDF 143: JumpObject wrap — text below the object

## Status: COMPLETE — implemented 2026-08-27

## Problem

JumpObjectTextWrap approximated as the bounding box: text narrowed
beside the object. InDesign's JumpObject means text NEVER flows
beside the object — it continues below it.

## Solution

- `TextWrapResolver::Contour` gains a `jump` flag, set from
  `TextWrapMode="JumpObjectTextWrap"`.
- A jump contour blocks the FULL frame width in
  `wrap_adjustment`.
- `TextFrameRenderer#skip_below_jump_object`: when the run's band
  is fully blocked (wrap width below the point size), the cursor
  skips to `jump_contour_bottom` — the blocking object's bottom
  edge — and the wrap re-measures there once. Text resumes below
  the object, never beside it.

NextColumn still approximates as the box (it needs column-jump
chaining, documented in TODO.pdf/61).

## Files

- `lib/idml/render/text_wrap_resolver.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `spec/idml/render/text_wrap_resolver_spec.rb`
- `spec/idml/render/jump_object_render_spec.rb` (end-to-end)
