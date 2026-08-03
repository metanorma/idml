# TODO PDF 57: Image clipping via pdfrb Canvas

## Goal

Clip placed images to their parent Rectangle's bounds using PDF clip
paths. Prevents image overflow beyond the containing frame.

## Status: DONE

## What was implemented

- `PdfrbExt::Clip` (PDF `W` operator) and `PdfrbExt::EndPath` (PDF `n`
  operator) registered as pdfrb Content::Operator subclasses.
- `SpreadRenderer#apply_image_clip` emits a clip path from the parent
  Rectangle's geometric_bounds before drawing the image.
- `Pipeline#parent_clip_box` computes the clip rectangle from the
  parent page item's bounds via Geometry helpers.
- Image refs now carry a `clip_box` field; when present, the SpreadRenderer
  clips before drawing.

## Acceptance criteria

- [x] PdfrbExt::Clip and EndPath operators registered.
- [x] SpreadRenderer applies clip path when clip_box is present.
- [x] Pipeline computes clip_box from parent geometric_bounds.
- [x] All tests pass.
