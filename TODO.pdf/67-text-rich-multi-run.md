# TODO PDF 67: Multi-run text batching via Canvas#text_rich

## Status: BLOCKED (pdfrb measure_text is stub for TTF)

## Goal

Replace the per-run `Canvas#text` calls in `TextFrameRenderer#simple_render`
with a single `Canvas#text_rich` call per text frame. `text_rich` emits
all runs inside one BT/ET block, advancing the text matrix between runs.

## Motivation

`text_rich` is the right primitive for multi-run text — one begin/end
text block per frame instead of N. But its run-advance relies on
`Pdfrb::Document::Fonts#measure_text`, which in pdfrb 0.4.0 still
returns the stub `length * 0.5 * size` for TTF/OTF fonts (only
Standard 14 AFM fonts get real measurement). Without accurate advance,
runs overwrite each other on the line.

## Blocker

`/Users/mulgogi/src/claricle/pdfrb/lib/pdfrb/document/fonts.rb`:

```ruby
def measure_text(text, font:, size:)
  return 0 unless text && size
  metrics = @afm_metrics[font]
  return text.to_s.length * size.to_f * 0.5 unless metrics  # STUB
  ...
end
```

`@afm_metrics` is only populated for Standard 14 fonts. pdfrb has
the TTF parsing infrastructure (`Pdfrb::Font::TrueType::File` with
Cmap, Hmtx) but the integration with `Fonts#glyph_width` /
`measure_text` is pending.

## Plan (after pdfrb unblocks)

1. Build `runs` array of `{ text:, font:, size:, color: }` per line.
2. Replace `simple_render` body with `canvas.text_rich(runs, at: [x, y])`.
3. Verify rendered PDF: runs no longer overwrite, multi-color lines work.
4. Combine with TODO 63 to drop Fontisan for measurement.

## Acceptance criteria

- [ ] `TextFrameRenderer#simple_render` uses `canvas.text_rich`.
- [ ] Render spec verifies a multi-run line has correct horizontal advance.
- [ ] Single BT/ET block per frame (assertion on PDF content stream).

## Dependencies

- pdfrb `Fonts#measure_text` returns real per-glyph widths for TTF
  fonts (currently stub — see TODO 63).
