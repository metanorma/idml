# TODO PDF 16: Typed-model rendering pipeline

## Goal

Replace the regex-based image extraction and hardcoded page dimensions
in the rendering pipeline with typed-model iteration. The Pipeline should
read typed `Parts::Spread` instances and iterate over `SpreadObject`'s
child page items.

## Why

The current `Pipeline#collect_images` calls `Render::Image.extract_from_spread`
with raw XML and regex. This violates the "lutaml-model only" rule and
is fragile (regex can't handle nested elements, attribute ordering, or
namespace prefixes robustly).

## Acceptance criteria

- [ ] `Pipeline#call` iterates over `package.spreads` (typed `Parts::Spread`).
- [ ] Image extraction uses `spread.spread.first` (SpreadObject) →
      iterate child elements → find `Image` → access `link.first.link_resource_uri`.
- [ ] No raw XML reading in the Pipeline for modeled parts.
- [ ] Page dimensions come from the `Page` element's `GeometricBounds`,
      not a hardcoded constant.
- [ ] `Render::Image.extract_from_spread` is removed or deprecated;
      the typed path replaces it.
- [ ] Spec: Pipeline produces the same PDF structure as before (images
      embedded, valid PDF header/trailer).

## Files

- `lib/idml/render/pipeline.rb` (rewrite iteration)
- `lib/idml/render/image.rb` (remove `extract_from_spread` or mark deprecated)
- `lib/idml/render/spread_renderer.rb` (accept typed SpreadObject)
- `spec/idml/render/pipeline_spec.rb`

## Design notes

- The `Page` element's `GeometricBounds` is `y1 x1 y2 x2` (top-left,
  bottom-right in spread coordinates). Page width = x2 - x1,
  height = y2 - y1.
- The Page's `ItemTransform` translates page-local coords to spread coords.
- For images inside Rectangles: iterate Rectangle → check ContentType ==
  "GraphicType" → find child Image → get Link.

## Dependencies

- TODOs 14, 15 (element models + SpreadObject wiring).
