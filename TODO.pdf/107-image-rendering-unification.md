# TODO PDF 107: Image rendering unification via PageItemRenderer

## Status: OPEN — gap identified in 2026-08-08 audit

## Problem

Today images flow through a separate code path:

1. `Pipeline#render_spread` calls `ImageCollector.new(...).collect(spread)`
   to gather all image refs *before* rendering.
2. `SpreadRenderer#render_images` emits each image as a flat layer at
   the start of the page (before any shapes/text).
3. `Rectangle` (etc.) renderers don't know about images embedded in
   them — they just render the shape, and the image falls through
   separately.

The IDML model has `Image_Object` as a first-class page item that
can appear:
- Directly in Spread children
- As a child of Rectangle (graphic content placed in a frame)
- As a child of Polygon (graphic content in a non-rectangular frame)
- As a child of Group

## What needs to happen

1. Register `ImageRenderer` in `PageItemRenderer::RENDERER_MAP`.
2. Move image rendering from `SpreadRenderer#render_images` to the
   standard dispatch — images render in z-order with other page items.
3. When a Rectangle/Polygon/Group has an Image child, render the image
   *clipped to the parent's PathGeometry* — that's the InDesign behavior.
4. Deprecate `ImageCollector` once the model-driven path is complete.

## Acceptance criteria

- [ ] Image as a direct Spread child renders via RENDERER_MAP dispatch.
- [ ] Image inside a Rectangle renders clipped to the Rectangle's bounds.
- [ ] Z-order preserved — later items render on top of earlier items.
- [ ] Existing image specs pass via the new code path.

## Dependencies

- TODO 106 (page-item type coverage).
