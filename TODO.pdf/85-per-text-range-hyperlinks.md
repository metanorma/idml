# TODO PDF 85: Per-TextRange hyperlink precision

## Status: DEFERRED (requires text-engine position tracking)

## Current state

`HyperlinkEmitter` (TODO 78) emits one Link annotation per text
frame whose story contains a hyperlink source. The annotation
covers the entire frame's bounding box, not just the linked
characters.

## What per-TextRange precision requires

For each hyperlink source, compute the rect that covers exactly
the source's characters on the page.

### Position tracking

The text engine (`Shaper`, `LineBreaker`, `Justifier`) already
produces positioned lines via `VerticalLayout`, but
`TextFrameRenderer` does not surface per-character positions
outside its own scope. To compute per-source rects we need:

1. **Absolute character index per CSR** — track cumulative char
   position as CSRs are processed within a story.
2. **Per-glyph (x, y) after layout** — Shaper gives widths,
   LineBreaker gives line assignments, Justifier gives x_offset,
   but no structured "positioned glyph" output is exposed today.
3. **Source range lookup** — map `HyperlinkTextSource#Self` to a
   `[start_char, end_char]` range. Today HyperlinkTextSource is
   modelled as a sibling element of `Content` inside CSR; the
   range is implicit (the source wraps its own content).

### Emitter change

`HyperlinkEmitter` currently does:
```ruby
box = Placement.box(frame, @page_height)
@writer.add_uri_link_annotation(page_index:, rect: rect_for(box), url:)
```

Per-range version needs the positioned glyph data:
```ruby
positions = context.positioned_glyphs_for_frame(frame.self_attr)
range = source_range_for(hyperlink_source)
rect = bounding_rect_for_range(positions, range)
@writer.add_uri_link_annotation(page_index:, rect:, url:)
```

### Threading

Positioned glyph data must travel from `TextFrameRenderer` (which
runs the layout engine) to `HyperlinkEmitter` (which runs after
the page renders). Options:

- **A. Side channel via RenderContext**: add `positioned_glyphs`
  hash to RenderContext, keyed by frame Self. Renderers populate
  it; emitter reads it.
- **B. Two-pass render**: re-run layout in the emitter to compute
  positions. Wasteful but keeps emitter self-contained.
- **C. Position tracker object**: similar to StructureTracker —
  Pipeline constructs it, threads through RenderContext, queries
  after rendering.

Option C is the cleanest (matches StructureTracker pattern from
TODO 76).

## Plan

1. Add `Render::PositionTracker` — accumulates per-frame positioned
   ranges: `[{ frame_self:, start_char:, end_char:, x:, y:, width:,
   height: }, ...]`.
2. Add `position_tracker` to `RenderContext`.
3. In `TextFrameRenderer#render_run_lines`, after layout, push each
   line's positioned range to the tracker.
4. In `HyperlinkEmitter#emit_for_frame`, query the tracker for
   ranges that overlap each hyperlink source's `[start_char,
   end_char]`. Compute the bounding rect from those ranges.
5. Emit one Link annotation per source.

## Why deferred

- No fixture has hyperlinks → can't validate per-range precision.
- Position tracker adds another stateful object to the render path.
- Frame-level precision is "good enough" for visible link presence;
  per-range is a polish improvement.

## Acceptance criteria

- [ ] PositionTracker accumulates per-frame positioned ranges.
- [ ] HyperlinkEmitter queries tracker for source ranges.
- [ ] Each hyperlink source gets its own Link annotation rect.
- [ ] Spec covers multi-source story with overlapping ranges.
