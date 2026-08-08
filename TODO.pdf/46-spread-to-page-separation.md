# TODO PDF 46: Spread-to-page separation

## Status: DONE — `Pipeline#render_spread` iterates each Page in the
Spread separately, calls `writer.add_page` with per-page dimensions,
and tracks the global `page_index` for hyperlink/destination wiring.
See `lib/idml/render/pipeline.rb` and TODO 19.

## Goal

Render each IDML Page as a separate PDF page (currently one PDF page
per spread). Multi-page spreads produce multiple PDF pages.

## Acceptance criteria

- [ ] Pipeline iterates Pages within each Spread.
- [ ] Each Page gets its own `writer.add_page` with correct dimensions.
- [ ] Page items clipped/translated to page-local coordinates.
- [ ] Master spread items rendered per-page (respecting AppliedMaster).
- [ ] Spec: 2-page spread produces 2 PDF pages.

## Dependencies

- TODO 19 (page dimensions).
- TODO 32 (master spread rendering).
