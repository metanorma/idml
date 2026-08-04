# TODO PDF 86: Caching and performance

## Status: PARTIAL — most hot paths cached; one risk noted

## What is cached today

- `ColorResolver#resolve` — per-color-name cache (`@cache`).
- `PdfrbFontMetrics#metrics_data` — read-through to pdfrb's
  `Fonts#metrics_for` which has its own cache.
- `Pipeline#font_resolver` — lazily memoised via `||=`.
- `MetadataBuilder#xmp_packet` — memoised via `@xmp_packet ||=`.
- `PdfrbWriter#@image_cache` — URI → name cache for images.
- `Pdfrb::Document` internals — fonts, pages, structure all have
  their own caches.

## What is not cached

### `geometric_bounds` on element instances

Each call to `Placement.box(item, page_height)` calls
`item.geometric_bounds`, which walks `Properties → PathGeometry →
bounding_box`. For each rendered item, this is called:

- 1× in the renderer (via `Placement.box`).
- 1× in `ImageCollector#clip_box_for` (for items that have images).
- 1× in `HyperlinkEmitter#emit_for_frame` (for text frames).

So 2–3 walks per item. Memoising at the element level would save
the duplicate walks.

### Risk: Lutaml model instance variables

Lutaml::Model::Serializable instances are populated via the
framework's own `instance_variable_set` during deserialization.
Adding `@geometric_bounds ||= ...` could conflict if Lutaml ever
adds an attribute of the same name, or if the framework resets
instance state during round-trip.

The safer pattern is to memoise at the helper layer (Placement)
using `Object#object_id` as the cache key, but that introduces
memory pressure (unbounded hash growth).

### Decision

Defer until profiling shows it matters. Current render of the
sample-with-image fixture (~60KB PDF, multiple shapes/text frames)
completes in ~250ms, which is fast enough for typical use.

## Other performance notes

- **SpreadRenderer iterates spread items 3×**: once for
  `ImageCollector`, once for rendering, once for `HyperlinkEmitter`.
  Could be combined but couples concerns.
- **No lazy part loading**: opening a Package reads all parts
  eagerly. For large IDML files this could be slow; not yet a
  measured problem.

## Plan (if profiling shows it matters)

1. Memoise `geometric_bounds` on `Elements::Rectangle`, `Polygon`,
   `GraphicLine`, `TextFrame`, `Table` via `||=` with a
   non-conflicting ivar name (e.g., `@_bounds_cache`).
2. Add a spec that asserts the cache is populated after first
   access.
3. Re-run render benchmarks.

## Acceptance criteria

- [ ] Profile render of a large fixture and identify hot paths.
- [ ] If `geometric_bounds` shows up, memoise safely.
- [ ] Spec asserts memoisation doesn't break round-trip.
