# TODO PDF 105: Whole-package round-trip suite (byte-equivalent)

## Status: DONE — `spec/idml/round_trip_all_fixtures_spec.rb` already
runs byte-equivalent round-trip for every fixture .idml (28 examples,
all passing). `spec/idml/package_spec.rb:140` verifies the mimetype
entry is stored and first.

## Problem

CLAUDE.md states:

> The gold standard is whole-package round-trip: unzip a fixture
> `.idml`, rebuild every part, rezipping, and assert byte-equivalence
> part-by-part (the `mimetype` member must remain stored/uncompressed
> and first in the archive).

Today there are round-trip specs for individual element classes
and per-part parse/serialize, but no spec that takes a complete
`.idml` fixture, rebuilds every part, rezips, and asserts
byte-equivalence.

The `sample-with-image` fixture is the canonical DOMVersion 21.5
fixture (validated clean against all 14 part schemas), so it's the
right target for this spec.

## What needs to happen

1. New spec `spec/idml/package/round_trip_spec.rb`:
   - Open `spec/fixtures/sample-with-image/sample-with-image.idml`.
   - For each part in the package, parse via the typed Parts class
     and re-serialize.
   - Assert each re-serialized part is XML-equivalent to the original
     (canonicalize attribute order, whitespace).
2. Re-zip the package into a temporary file.
3. Assert: `mimetype` is the first entry and stored uncompressed
   (`Zip::Entry::STORED`).
4. Assert: every other entry matches the original byte-for-byte
   after normalization.

## Acceptance criteria

- [ ] All 14 parts of `sample-with-image.idml` round-trip XML-equivalent.
- [ ] Re-zipped package has `mimetype` first and stored.
- [ ] Spec covers both `sample-with-image` and `sample-with-table-more`.

## Dependencies

- None — exercises existing typed parts.
