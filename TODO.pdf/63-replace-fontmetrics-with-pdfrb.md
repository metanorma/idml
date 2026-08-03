# TODO PDF 63: Replace FontMetrics with pdfrb measurement API

## Status: BLOCKED (pdfrb measurement APIs are stubs)

## Goal

Replace `Idml::TextEngine::FontMetrics` (200+ lines of TTF binary parsing
via Fontisan) with pdfrb's native `Fonts#measure_text`, `#glyph_width`,
and `#metrics_for`. Eliminates the Fontisan dependency for text layout.

## Blocker

pdfrb 0.4.0 ships the API surface but the implementations are stubs
that return constant values, not real per-glyph widths:

`/Users/mulgogi/src/claricle/pdfrb/lib/pdfrb/document/fonts.rb`:

```ruby
def measure_text(text, font:, size:)
  return 0 unless text
  # TODO: use font metrics for per-glyph width lookup
  text.to_s.length * (size || 0).to_f * 0.5
end

def glyph_width(_char, _resource)
  500
end

def metrics_for(_resource)
  nil
end
```

The Shaper and LineBreaker depend on accurate per-glyph widths for
correct word-wrap. With stub data, line breaks land at the wrong
positions and run advance (needed for TODO 67's `text_rich`) is wrong.

Fontisan correctly parses head/hhea/hmtx/cmap tables for any TTF/OTF
and exposes per-glyph advance widths. Until pdfrb either grows real
TTF parsing or accepts externally-provided metrics (see
`/Users/mulgogi/src/claricle/pdfrb/PROPOSAL.external-font-metrics.md`),
Fontisan stays.

## Path forward

Proposal at `~/src/claricle/pdfrb/PROPOSAL.external-font-metrics.md`
suggests letting `Fonts#add` accept `widths:`/`metrics:`/`encoding:`
hashes from the caller, so pdfrb does not need to parse TTF tables
itself. The idml gem would then build those hashes from FontMetrics
and pass them in — keeping Fontisan as the parser while pdfrb handles
only PDF assembly. This is the Unix-philosophy split.

Once that proposal lands:

1. `PdfrbWriter#register_font_with_metrics(path, widths:, metrics:, ...)`.
2. Pipeline resolves fonts via FontResolver (Fontisan) and passes the
   resulting metrics to pdfrb.
3. Internal `FontMetrics` may still exist as the Fontisan adapter, but
   Shaper/LineBreaker no longer need to read it — they go through
   `pdfrb.measure_text`.

## Acceptance criteria (after pdfrb unblocks)

- [ ] Pipeline registers fonts with externally-provided metrics.
- [ ] Shaper/LineBreaker call pdfrb's measurement API, not FontMetrics.
- [ ] `fontisan` remains a dependency for parsing, but no longer feeds
      Shaper/LineBreaker directly.

## Dependencies

- pdfrb 0.4.0's `Fonts#measure_text`/`#glyph_width`/`#metrics_for`
  with real implementations OR
- pdfrb accepts the external-metrics proposal linked above.
