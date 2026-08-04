# TODO PDF 85: Per-TextRange hyperlink precision

## Status: PARTIAL — PositionTracker wired; per-source ranges need fixture

## What was implemented

`Render::PositionTracker` is wired through the render path:

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
4. **`HyperlinkEmitter`** consumes the tracker: when a tracker is
   supplied, computes a per-source rect via
   `tracker.rect_for_range(frame_self, from:, to:)`. Falls back to
   the frame's bounding box when no tracker is supplied (e.g.,
   when the renderer took the simple_render path).

## What remains

The current `HyperlinkEmitter#emit_precise_rects` uses
`from: 0, to: 1_000_000` — a heuristic that intersects every
recorded range on the frame, giving the bounding rect of all
rendered text. This is more precise than the full frame box (text
only, excluding frame padding) but less precise than per-source
range.

The reason for the heuristic: `HyperlinkTextSource` doesn't carry
an explicit `StartIndex`/`EndIndex` — it wraps its content as a
sibling of `<Content>` inside `<CharacterStyleRange>`. Determining
the exact character range requires walking the story markup and
attributing each character to either `<Content>` or
`<HyperlinkTextSource>` children.

Once that attribution logic exists in `StyleResolver`, the emitter
can call `tracker.rect_for_range(frame_self, from: source_start,
to: source_end)` for per-source precision.

## Verification

- `lib/idml/render/position_tracker.rb` — tracker.
- `lib/idml/render/render_context.rb:12` — `position_tracker` field.
- `lib/idml/render/renderers/text_frame_renderer.rb:101` —
  `record_position` call.
- `lib/idml/render/hyperlink_emitter.rb:54` — `emit_precise_rects`.
- `spec/idml/render/position_tracker_spec.rb` — 8 specs covering
  add, ranges_for, rect_for_range, clear.

## Acceptance criteria

- [x] PositionTracker accumulates per-frame positioned ranges.
- [x] TextFrameRenderer records line positions during layout.
- [x] HyperlinkEmitter queries tracker when supplied.
- [x] Spec covers add/query/clear paths.
- [ ] Per-source range attribution in StyleResolver (future work).
- [ ] Spec with a multi-source story (requires IDML fixture).
