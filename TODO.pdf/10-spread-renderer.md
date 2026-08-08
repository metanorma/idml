# TODO PDF 10: Spread renderer

## Status: DONE — `Render::SpreadRenderer` walks each Page's items in
z-order, dispatching via `PageItemRenderer::RENDERER_MAP`. Master items
rendered first as background. See `lib/idml/render/spread_renderer.rb`
and TODO 32.

## Goal

Render an IDML Spread (all its page items) into a single PDF page's
content stream.

## Acceptance criteria

- [ ] `Idml::Render::SpreadRenderer.new(spread:, font_resolver:,`
      `color_index:)` renders every page item.
- [ ] Page items rendered in z-order (back to front, as they appear
      in the Spread XML).
- [ ] Rectangle/Polygon → path operators (TODO 07).
- [ ] TextFrame → text engine (TODOs 01–05) + text operators
      (TODO 08).
- [ ] Image → image XObject (TODO 09).
- [ ] Groups rendered recursively.
- [ ] Page boundaries (GeometricBounds) set the PDF page's
      MediaBox.
- [ ] Spec: render a one-page fixture, verify the output PDF opens
      and shows the expected content.

## Files

- `lib/idml/render/spread_renderer.rb`
- `lib/idml/render.rb` — module + autoloads.
- `spec/idml/render/spread_renderer_spec.rb`

## Dependencies

- TODOs 06–09.
- Typed Spread element classes (done).
