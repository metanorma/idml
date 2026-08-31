# TODO PDF 155: NextColumn column jumping in multi-column frames

## Status: COMPLETE — implemented 2026-09-01

## Problem

NextColumnTextWrap approximated as JumpObject-below (TODO 146):
in a multi-column frame, InDesign moves the text to the NEXT
COLUMN, not below the object.

## Solution

The wrap contour carries the mode: `jump` (JumpObjectTextWrap)
vs `next_column` (NextColumnTextWrap). Both block the full column
width; the renderer chooses the response —
`TextFrameRenderer#next_column_jump?` abandons the column when a
NextColumn contour blocks the run's band in a multi-column frame:
the cursor drops to the bottom limit mid-run, the unplaced runs
return to the chain state, and the next column (or frame)
resumes them. Single-column frames and JumpObject keep the
skip-below path (`jump_contour_bottom` reports the resume point
for both flavors).

## Files

- `lib/idml/render/text_wrap_resolver.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `spec/idml/render/text_wrap_resolver_spec.rb`
- `spec/idml/render/jump_object_render_spec.rb` (end-to-end)
