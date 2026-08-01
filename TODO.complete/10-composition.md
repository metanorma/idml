# TODO 10: Composition layer (stubs + design)

## Goal

Lay down the API surface for composition operations. Implement only the
trivial ones; defer the rest with documented `NotImplementedError` so the
gem's API shape is clear and stable.

## Acceptance criteria

- [ ] `Idml::Composition` module autoloaded from `lib/idml.rb`.
- [ ] Command-pattern classes for each operation:
      - `Composition::InsertIdml` — `#call(source:, into:, at:, only:)`
      - `Composition::AddPageFromIdml` — `#call(source:, page_number:, at:, only:)`
      - `Composition::Prefix` — `#call(prefix:)` — renames Self IDs to avoid
        collisions when composing two packages.
      - `Composition::ImportXml` — `#call(xml_string:, at:)`
      - `Composition::ExportXml` — `#call` — returns the logical XML tree
        as a string.
- [ ] Each command class takes a `Package` in its constructor and implements
      `#call` returning a new `Package` (no mutation).
- [ ] All commands raise `NotImplementedError` with a message pointing to
      this TODO file as the design source. Only `Prefix` and the framework
      are implemented in this TODO (the rest are future work).
- [ ] `Prefix#call(prefix:)` is fully implemented: rewrites every `Self`
      attribute value in every part to be prefixed with the given string.
      Tested against the fixture.
- [ ] Spec: each command class has its own spec file. Stub commands have
      specs asserting they raise `NotImplementedError` with the right
      message.

## Files

- `lib/idml/composition.rb` — module + autoloads.
- `lib/idml/composition/insert_idml.rb`
- `lib/idml/composition/add_page_from_idml.rb`
- `lib/idml/composition/prefix.rb`
- `lib/idml/composition/import_xml.rb`
- `lib/idml/composition/export_xml.rb`
- `lib/idml/geometry.rb` — coordinate-transform helpers for insertion
  (port from SimpleIDML's `doc/IDML_insert_idml_coordinate_transformation.*`).
  Stubbed in this TODO; full implementation deferred.
- `spec/idml/composition/{insert_idml,add_page_from_idml,prefix,import_xml,export_xml}_spec.rb`

## Design notes

- Command pattern (not methods on Package) is the OCP move: adding a new
  composition operation = adding a new class, not editing `Package`.
- Each command is a callable (`#call`). They compose: `InsertIdml.new(pkg1).
  call(source: pkg2, ...)` returns a new package that can be passed to the
  next command.
- `Prefix` is the only fully implemented command because it's the simplest
  (just rewrite Self attributes) and is a prerequisite for every other
  composition op (you always prefix before inserting to avoid ID
  collisions).
- Future composition work (post-this-TODO) will port the algorithms from
  SimpleIDML's `simple_idml/idml.py` directly — the algorithms are well-
  tested there.

## Dependencies

- TODO 02–07 (Package + all parts).
