# TODO PDF 126: Package#part memoization

## Status: COMPLETE — implemented 2026-08-20

## Problem

`Package#part(name)` re-read and re-parsed the zip entry on every
call. Rendering resolves `story_by_id` per frame plus preferences
(Footnote.option), styles, and graphics repeatedly — each lookup
decompressed and re-parsed the same XML.

## What was done

Parsed parts are memoized in a per-`Package` hash
(`parse_part` remains the single read+parse path; `each_part` /
`read_part` stay uncached raw reads for round-trip byte fidelity).

## Acceptance criteria

- [x] Repeated `part(name)` calls return the same object.
- [x] Different parts do not share objects.
- [x] Whole-package round-trip specs unchanged (raw reads).
