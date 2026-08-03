# TODO PDF 62: Migrate to pdfrb 0.15.0 native APIs

## Goal

Remove all workarounds and dead code now that pdfrb 0.15.0 implements
all six proposals (clip, page-mediabox-setter, font-embedding, draw-image-matrix,
struct-tree-root, text-measurement).

## Status: DONE

## What was removed

- `lib/idml/render/pdfrb_ext/` — PdfrbExt::InvokeXObject, Clip, EndPath
  (all now native in pdfrb 0.15.0)
- `lib/idml/render/pdf_writer.rb` — old hand-rolled PDF assembly (350+ lines)
- `lib/idml/render/font_embedder.rb` — old WinAnsiEncoding Widths builder
- `lib/idml/render/color.rb` — old PDF color operator strings
- `lib/idml/render/path.rb` — old PDF path operator strings
- `lib/idml/render/text.rb` — old PDF text operator strings
- `spec/idml/render/font_embedder_spec.rb`
- `spec/idml/render/pdf_writer_validation_spec.rb`
- `spec/idml/render/render_spec.rb` (old Color/Path/Text/PdfWriter tests)

## What was refactored

- `SpreadRenderer#render_images`: uses `canvas.draw_image_matrix` and
  `canvas.clip` instead of `PdfrbExt::InvokeXObject` and `PdfrbExt::Clip`
- `PdfrbWriter#add_page`: uses `page.media_box=` setter instead of
  `page[:MediaBox] =`
- `render.rb`: cleaned autoloads — only active modules remain
- `GradientResolver`: uses raw operators instead of old Path/Color modules
- `Image#draw_image`: marked DEPRECATED (returns "DEPRECATED" string)
- `render_pdfrb_writer_spec.rb`: tests native pdfrb Canvas methods instead
  of PdfrbExt operators

## Acceptance criteria

- [x] All PdfrbExt code removed
- [x] All old hand-rolled modules removed
- [x] SpreadRenderer uses canvas.draw_image_matrix + canvas.clip
- [x] PdfrbWriter uses page.media_box= setter
- [x] All tests pass (2287 examples)
- [x] 0 Rubocop offenses
- [x] Anti-pattern spec passes
