# TODO 20: Full round-trip suite across every fixture

## Goal

For every `.idml` file under `spec/fixtures/`, verify that opening,
extracting every part, and writing a new package yields byte-equivalent
parts (per entry, ignoring ZIP metadata like timestamps).

## Acceptance criteria

- [ ] `spec/idml/round_trip_all_fixtures_spec.rb` parameterized over
      every `.idml` in `spec/fixtures/**/*.idml`.
- [ ] For each fixture: open, extract parts, write to temp, reopen,
      assert each entry's content is byte-equivalent to the original.
- [ ] Skip entries that are inherently non-deterministic (none expected
      for IDML — all parts are static XML or fixed mimetype).
- [ ] Aggregate failures clearly: one RSpec example per fixture, named
      with the relative path.
- [ ] Document any fixture that fails round-trip in
      `spec/fixtures/ROUND_TRIP_NOTES.md` with the specific reason.

## Files

- `spec/idml/round_trip_all_fixtures_spec.rb`
- `spec/fixtures/ROUND_TRIP_NOTES.md` (only if any fixture fails)

## Design notes

- The round-trip test goes through `Package#each_part` + `Package.write`
  — the raw XML passthrough. Typed models aren't involved; this test
  validates the ZIP layer's byte fidelity.
- For each fixture, the test creates a tempdir, writes the repackaged
  ZIP there, reopens, and compares per-entry.
- The existing `spec/idml/round_trip_spec.rb` (single fixture) can be
  replaced by the parameterized version.

## Dependencies

- TODO 19 (fixtures vendored).
