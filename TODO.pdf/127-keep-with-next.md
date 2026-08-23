# TODO PDF 127: KeepWithNext

## Status: COMPLETE — implemented 2026-08-20

## What was done

- `StyleResolver::Paragraph` carries `keep_with_next` from the PSR.
- A paragraph with KeepWithNext defers to the next frame when the
  FOLLOWING paragraph is forced there (StartParagraph break) or
  when the follower's first line would not fit after this
  paragraph (pre-measured via TextEngine::Measurement plus the
  follower's leading). Combined with TODO 123's KeepAllLinesTogether,
  both keep flavors share one deferral predicate in
  `consume_paragraphs`.

## Known limitations

- The numeric strength of KeepWithNext (1–5, lines to keep) is
  treated as boolean.
- Not applied in vertical writing mode.
