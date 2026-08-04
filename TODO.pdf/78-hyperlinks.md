# TODO PDF 78: Hyperlink annotations

## Status: DONE (frame-level precision; per-range precision future work)

## What was implemented

IDML hyperlinks render as PDF `/Subtype /Link` annotations. The flow:

1. `<Hyperlink>` and `<HyperlinkURLDestination>` elements are parsed
   from designmap (`Parts::Designmap#hyperlink`,
   `#hyperlink_url_destination`).
2. `Render::HyperlinkResolver` connects a source Self → hyperlink →
   destination Self → URL.
3. `Render::HyperlinkEmitter` runs after each spread renders. It
   walks every `TextFrame` on the spread, looks up its story's
   hyperlink sources via StyleResolver, and emits one Link
   annotation per resolved URL via `PdfrbWriter#add_uri_link_annotation`.
4. `PdfrbWriter#add_uri_link_annotation(page_index:, rect:, url:)`
   builds a PDF URI action (`/A << /S /URI /URI (url) >>`) and
   attaches it to a Link annotation registered on the page.

## Element models added

- `Idml::Elements::Hyperlink` — `<Hyperlink>` element.
- `Idml::Elements::HyperlinkURLDestination` — `<HyperlinkURLDestination>` element.
- `Idml::Elements::HyperlinkPageDestination` (already existed) reused
  for bookmark destinations (TODO 79).

## Limitation

The emitter is frame-level, not text-range-level. Each text frame
with a hyperlink source gets a single Link annotation covering the
entire frame box, regardless of which characters the source actually
covers. Per-range precision requires deep text-engine integration —
tracking each character's (x, y) after layout and emitting one
annotation per source's TextRange.

Future enhancement: have `TextFrameRenderer` record glyph positions
during layout, then `HyperlinkEmitter` can compute precise rects.

## Verification

- `lib/idml/elements/hyperlink.rb` — element model.
- `lib/idml/elements/hyperlink_url_destination.rb` — element model.
- `lib/idml/render/hyperlink_resolver.rb` — source → URL resolution.
- `lib/idml/render/hyperlink_emitter.rb` — annotation emission per spread.
- `lib/idml/render/pdfrb_writer.rb` — `add_uri_link_annotation`.
- `lib/idml/render/pipeline.rb:97` — emitter call after each spread.
- `spec/idml/render/hyperlink_resolver_spec.rb` — 5 specs covering
  resolution, hidden skipping, missing-destination handling.

## Acceptance criteria

- [x] URL hyperlinks in IDML render as clickable Link annotations.
- [x] Hidden hyperlinks (`Visible="false"` or `Hidden="true"`) skipped.
- [x] Hyperlinks with unresolvable destinations skipped silently.
- [x] Spec covers visible, hidden, and missing-destination cases.
- [ ] Per-TextRange rect precision (deferred — current behavior is
      frame-level).
