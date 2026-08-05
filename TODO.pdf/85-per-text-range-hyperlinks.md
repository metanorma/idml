# TODO PDF 85: Per-TextRange hyperlink precision

## Status: DONE (architecture); fixture validation deferred

## What was implemented

`Render::PositionTracker` is wired through the render path AND
per-source character ranges are computed via CSR's
`attributed_text` method.

### Position tracker (Pipeline-level)

1. **`Render::PositionTracker`** — accumulates positioned line
   ranges per frame (`PositionedRange` Struct with start_char,
   end_char, x, y, width, height).
2. **`Pipeline`** constructs one tracker per render, threads it
   through `SpreadRenderer` → `RenderContext` → `GroupRenderer`'s
   child contexts.
3. **`TextFrameRenderer#render_run_lines`** tracks an absolute
   char cursor through the story. After each line is laid out and
   drawn, `record_position` pushes a `PositionedRange` to the
   tracker keyed by `frame.self_attr`.

### Per-source attribution (CSR-level)

4. **`Elements::CharacterStyleRange#attributed_text`** returns an
   array of `{char:, source_self:}` tuples. Plain chars have no
   `source_self`; chars inside a `HyperlinkTextSource` carry the
   source's Self attribute. The method walks Content,
   HyperlinkTextSource, and nested CSR children.
5. **`Elements::HyperlinkTextSource`** now captures inline content
   (`content`, `character_style_range`, `hyperlink_text_source`
   collections) and exposes `text_content` that walks them all.
6. **`HyperlinkEmitter#source_char_ranges_for_frame`** walks the
   story's CSRs via `attributed_text`, building a
   `source_self → [start_char, end_char]` map.
7. **`HyperlinkEmitter#emit_precise_rects`** queries
   `PositionTracker#rect_for_range(frame_self, from:, to:)` for
   each source's range, emitting one Link annotation per source.

### Fallback

When no tracker is supplied (e.g., the renderer took the
simple_render path), HyperlinkEmitter falls back to the frame's
bounding box (the original TODO 78 behavior).

## Verification

- `lib/idml/render/position_tracker.rb` — tracker.
- `lib/idml/render/render_context.rb:12` — `position_tracker` field.
- `lib/idml/render/renderers/text_frame_renderer.rb:101` —
  `record_position` call.
- `lib/idml/render/hyperlink_emitter.rb:79` — `source_char_ranges_for_frame`.
- `lib/idml/elements/character_style_range.rb:669` — `attributed_text`.
- `lib/idml/elements/hyperlink_text_source.rb` — content collections.
- `spec/idml/render/position_tracker_spec.rb` — 8 specs.
- `spec/idml/elements/character_style_range_spec.rb` — 4 specs
  covering text_content (Content join, HyperlinkTextSource wrap)
  and attributed_text (plain vs linked char tagging).

## Acceptance criteria

- [x] PositionTracker accumulates per-frame positioned ranges.
- [x] TextFrameRenderer records line positions during layout.
- [x] CSR#attributed_text tags characters per source Self.
- [x] HyperlinkEmitter computes per-source link rects via
      tracker queries against per-source character ranges.
- [x] Falls back to frame-level rect when no tracker is supplied.
- [x] Spec coverage: PositionTracker (8) + CSR attribution (4).
- [ ] Real-fixture end-to-end test (requires IDML with hyperlinks).
