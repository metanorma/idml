# TODO 11: Package convenience accessors

## Goal

Add typed accessors on `Package` so users don't need to know the
filename patterns: `pkg.designmap`, `pkg.spreads`, `pkg.stories`,
`pkg.backing_story`, `pkg.master_spreads`, `pkg.fonts`, etc.

## Acceptance criteria

- [ ] `Package#designmap` returns the typed `Designmap` instance.
- [ ] `Package#backing_story` returns the `BackingStory` instance.
- [ ] `Package#spreads` returns an Array of `Spread` instances (one
      per `Spreads/Spread_*.xml`).
- [ ] `Package#master_spreads`, `#stories` similarly.
- [ ] `Package#fonts`, `#graphic`, `#style`, `#style_mapping`,
      `#preferences`, `#tags`, `#mapping` — one per Resources/XML file.
      Return `nil` if the file is absent.
- [ ] Each accessor caches its result on first call (memoized) so
      repeat calls don't re-read the ZIP.
- [ ] Specs cover each accessor against the fixture, including the
      absent-file case (e.g., `pkg.mapping` is nil on the fixture
      because Mapping.xml doesn't exist).

## Files

- `lib/idml/package.rb` — accessor methods.
- `spec/idml/package_accessors_spec.rb` — full coverage.

## Design notes

- Accessors route through the existing `Parts.class_for` registry so
  they stay in sync with the part layer automatically. New part
  classes get accessors "for free" if the user adds them to Package,
  but the registry remains the source of truth.
- Memoization uses the standard `@name ||= ...` pattern. Cache is
  per-instance, so a new Package re-reads.

## Dependencies

- TODOs 03–07 (all part classes registered).
