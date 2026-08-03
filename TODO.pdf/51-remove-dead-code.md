# TODO PDF 51: Remove dead code from pdfrb migration

## Status: DONE

## What was removed (in v0.2.0)

All old hand-rolled modules deleted in the pdfrb 0.15.0 migration:
- `pdf_writer.rb`, `font_embedder.rb`, `color.rb`, `path.rb`, `text.rb`
- `pdfrb_ext.rb`, `pdfrb_ext/clip.rb`, `pdfrb_ext/invoke_xobject.rb`
- 3 old test files

Net: -1358 lines of dead code.
These modules are dead code — not referenced by any active code path.

## Status: READY FOR CLEANUP

## What to remove

- `lib/idml/render/pdf_writer.rb` — old hand-rolled PDF assembly (350+ lines)
- `lib/idml/render/font_embedder.rb` — old WinAnsiEncoding Widths builder
- `lib/idml/render/color.rb` — old PDF color operator string generators
- `lib/idml/render/path.rb` — old PDF path operator string generators
- `lib/idml/render/text.rb` — old PDF text operator string generators
- Dead methods in `image.rb`: `draw_image`, `extract_from_spread`,
  `enclosing_transform` (regex-based extraction replaced by typed models)

## What to keep

- `lib/idml/render/image.rb` utility functions: `resolve_path`,
  `detect_format`, `jpeg_dimensions/colorspace`, `png_dimensions/colorspace`,
  `png_idat_data`, `parse_transform`, `compute_placement`, `combine`,
  `Transform`, `identity` — all still used by Pipeline
- `lib/idml/render/color_helper.rb` — converts ColorResolver hashes to
  pdfrb Canvas color arrays
- All pdfrb-based code: `pdfrb_writer.rb`, `pdfrb_ext/`, renderers

## Test cleanup

- Remove `spec/idml/render/render_spec.rb` describe blocks for Color,
  Path, Text, PdfWriter (keep Pipeline describe block)
- Remove `spec/idml/render/font_embedder_spec.rb` entirely
- Remove dead-method tests from `spec/idml/render/image_spec.rb`
  (`extract_from_spread`, `draw_image` tests)
- Update `render.rb` autoloads to remove old modules

## Dependencies

- pdfrb migration must be complete (DONE).
