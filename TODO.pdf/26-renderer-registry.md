# TODO PDF 26: Page-item renderer registry (OCP)

## Status: DONE — `PageItemRenderer::RENDERER_MAP` is a class-level
Hash mapping element class → renderer class. Adding a new page-item
type = appending to RENDERER_MAP, not editing a switch statement.
See `lib/idml/render/page_item_renderer.rb`, `lib/idml/render/renderers/`.

## Goal

Replace the `case/when` dispatch in `SpreadRenderer` with a registration-
based renderer registry. Each page-item type gets its own renderer class
that self-registers. Adding a new type = creating a new class, not
editing a switch statement.

## Why

The current `SpreadRenderer#render_page_item` uses `case item when
Idml::Elements::Rectangle ...`. This violates OCP — every new page-item
type requires modifying SpreadRenderer. A registry decouples dispatch
from the SpreadRenderer, making the system open for extension.

## Acceptance criteria

- [ ] `Idml::Render::PageItemRenderer` module with `register(type,
      renderer)` and `for(item)` class methods.
- [ ] `Idml::Render::RenderContext` struct carrying shared state
      (package, font_resolver, color_resolver, page dimensions).
- [ ] `RectangleRenderer`, `TextFrameRenderer`, `PolygonRenderer`,
      `GraphicLineRenderer` classes — each returns a string of PDF
      operators.
- [ ] Each renderer registers itself: `PageItemRenderer.register(
      Idml::Elements::Rectangle, RectangleRenderer)`.
- [ ] `SpreadRenderer` delegates to `PageItemRenderer.for(item)`.
- [ ] No `case/when` or `is_a?` dispatch in SpreadRenderer.
- [ ] Specs for each renderer and the registry.

## Files

- `lib/idml/render/page_item_renderer.rb`
- `lib/idml/render/render_context.rb`
- `lib/idml/render/renderers/rectangle_renderer.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/render/renderers/polygon_renderer.rb`
- `lib/idml/render/renderers/graphic_line_renderer.rb`
- `lib/idml/render/spread_renderer.rb` (simplify to delegate)
- `lib/idml/render.rb` (add autoloads)

## Dependencies

- TODOs 14–18 (existing element models and rendering).
