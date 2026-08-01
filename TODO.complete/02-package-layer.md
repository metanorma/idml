# TODO 02: Package layer (ZIP container)

## Goal

`Idml::Package` reads an `.idml` ZIP, exposes its parts by name, and writes
a new ZIP. Parts layer is not yet typed — parts round-trip as raw XML strings.

## Acceptance criteria

- [ ] `Idml::Package.open(path)` returns a `Package` instance; the underlying
      `Zip::File` is held internally and closed on GC.
- [ ] `package.part_names` returns an Array of every entry name (excluding
      directory entries), sorted.
- [ ] `package.read_part(name)` returns the raw XML string for that entry.
- [ ] `package.has_part?(name)` predicate.
- [ ] `package.each_part(&block)` yields `(name, xml)` pairs; returns
      Enumerator if no block.
- [ ] `Idml::Package.write(parts:, to:)` writes a new ZIP at `to:` with:
      - `mimetype` first, stored (not deflated) — required by IDML UCF spec.
      - All other parts deflated.
- [ ] Round-trip: extract every part of `spec/fixtures/sample-with-image.idml`,
      rezip, assert the new ZIP contains the same entries with byte-equivalent
      content. (Note: ZIP metadata like timestamps may differ — compare entries
      only, not the ZIP container bytes.)
- [ ] `Idml::Errors::PackageNotFound`, `InvalidPackageError`, `PartNotFound`
      raised at the right boundaries. No bare `RuntimeError`.

## Files

- `lib/idml/errors.rb` — error class hierarchy rooted at `Idml::Error`.
- `lib/idml/package.rb` — `Package` class.
- `spec/idml/package_spec.rb` — full coverage.

## Design notes

- Use `rubyzip` (`Zip::File`) — already widely used in the Ruby ecosystem.
- Add `rubyzip` to gemspec runtime deps.
- `mimetype` is special: must be first entry, compression method `stored`
  (zero). IDML readers refuse files that get this wrong.
- `Package` is read-only by design. Mutation goes through Composition (TODO
  10), which produces a new `Package`. Avoids working-copy state.
- `Package` does NOT parse XML. It just hands bytes to the caller. Typing
  happens at the Parts layer (TODO 03+).
- Autoload `Package` from `lib/idml.rb`; autoload `Errors` similarly.

## Dependencies

- TODO 01 (bootstrap).
