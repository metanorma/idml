# TODO PDF 71: Shared Placement module (MECE refactor)

## Status: DONE

## What was implemented

Extracted the per-item placement computation (geometric_bounds +
item_transform + page_height → PDF `{x:, y:, width:, height:}` rect)
into a single shared module `Idml::Render::Placement`.

Before this refactor:

- `RectangleRenderer.placement_box` was the canonical helper.
- `PolygonRenderer` and `GraphicLineRenderer` reached across to
  `RectangleRenderer.placement_box` — a MECE violation (polygon and
  graphic line depend on rectangle for non-rectangle concerns).
- `TableRenderer` also reached across to `RectangleRenderer`.
- `TextFrameRenderer.frame_box` re-implemented the bounds→transform
  →rect pipeline by hand with a different fallback shape.

After:

- `Idml::Render::Placement.box(item, page_height, fallback: false)`
  is the single source of truth.
- All four shape renderers call `Placement.box`.
- `TextFrameRenderer.frame_box` is now a one-liner that calls
  `Placement.box(frame, page_height, fallback: true)`.

## Why

Placement is a geometry concern, not a rectangle concern. Hoisting it
out of `RectangleRenderer` removes the cross-renderer coupling and
keeps each renderer focused on its own shape's path construction.

## Acceptance criteria

- [x] No renderer references `RectangleRenderer.placement_box`.
- [x] `Placement.box` returns nil for items without bounds (default)
      or the fallback rect when `fallback: true`.
- [x] All render specs pass.
- [x] `bundle exec rake` green (2350+ examples).
