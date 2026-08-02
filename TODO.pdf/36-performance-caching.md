# TODO PDF 36: Performance caching

## Goal

Cache expensive operations: FontMetrics file parsing, FontResolver
search results, and ColorResolver lookups. Currently every
`FontMetrics.open` re-reads and re-parses the font binary.

## Why

The Pipeline opens the same font file multiple times (once for text
metrics, once for embedding). FontResolver scans all .ttf/.otf files
on every resolve. These are O(n) operations repeated per spread/item.

## Acceptance criteria

- [ ] `FontMetrics.open` caches by file path (class-level Hash).
- [ ] `FontResolver#resolve` caches by [family, style] key (already
      per-instance; add class-level for cross-instance reuse).
- [ ] `ColorResolver#resolve` caches by color name (already per-instance).
- [ ] `Package#part` caches typed part instances (already per-instance).
- [ ] Benchmark: rendering a 10-spread package shows < 2x slowdown vs
      single-spread.
- [ ] Spec: verify FontMetrics.open returns same instance for same path.

## Files

- `lib/idml/text_engine/font_metrics.rb` (class cache)
- `lib/idml/text_engine/font_resolver.rb` (class cache)

## Dependencies

- None.
