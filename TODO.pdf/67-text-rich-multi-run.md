# TODO PDF 67: Multi-run text batching via Canvas#text_rich

## Status: BLOCKED (pdfrb measure_text is a stub)

## Goal

Replace the per-run `Canvas#text` calls in `TextFrameRenderer#simple_render`
with a single `Canvas#text_rich` call per text frame. `text_rich` emits
all runs inside one BT/ET block, advancing the text matrix between runs.

## Motivation

`text_rich` is the right primitive for multi-run text — one begin/end
text block per frame instead of N. But its run-advance relies on
`Pdfrb::Document::Fonts#measure_text`, which in pdfrb 0.4.0 returns a
stub `length * 0.5 * size`. Without accurate advance, runs overwrite
each other on the line.

## Blocker

`/Users/mulgogi/src/claricle/pdfrb/lib/pdfrb/document/fonts.rb:65`:

```ruby
def measure_text(text, font:, size:)
  return 0 unless text
  # TODO: use font metrics for per-glyph width lookup
  text.to_s.length * (size || 0).to_f * 0.5
end
```

`glyph_width` (line 79) is also a stub returning 500, and `metrics_for`
(line 87) returns nil. These need real Fontisan-backed implementations
before text_rich produces correct output.

## Plan (after pdfrb unblocks)

1. Build `runs` array of `{ text:, font:, size:, color: }` per line.
2. Replace `simple_render` body with `canvas.text_lines(..., rich: true)`
   or `canvas.text_rich(runs, at: [x, y])`.
3. Verify rendered PDF: runs no longer overwrite, multi-color lines work.

## Acceptance criteria

- [ ] `TextFrameRenderer#simple_render` uses `canvas.text_rich`.
- [ ] Render spec verifies a multi-run line has correct horizontal advance.
- [ ] Single BT/ET block per frame (assertion on PDF content stream).

## Dependencies

- pdfrb 0.4.0 `Fonts#measure_text` returns real per-glyph widths.
- pdfrb 0.4.0 `Fonts#glyph_width` not returning stub 500.
