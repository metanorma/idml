# TODO 03: Parts registry + Designmap model

## Goal

Stand up the part-class registry and ship the first typed part: `Designmap`.
This TODO establishes the pattern all subsequent part TODOs follow.

## Acceptance criteria

- [ ] `lib/idml/part.rb` defines the `Idml::Part` mixin module with one class
      method: `part_file(pattern)` — registers the class against a `Regexp`
      matching its filename inside the package.
- [ ] `lib/idml/parts.rb` defines `Idml::Parts` with:
      - autoloads for every part class (this TODO adds only `Designmap`;
        subsequent TODOs append).
      - `Parts.class_for(file_name)` returns the registered class or raises
        `Parts::UnknownPartError`.
      - `Parts.register(pattern, klass)` — used by the `Part.part_file` macro.
      - `Parts.all` — returns every registered class, for tooling.
      - Registry is eager-populated on first lookup (autoload triggering).
- [ ] `lib/idml/parts/designmap.rb` defines `Idml::Parts::Designmap
      < Lutaml::Model::Serializable`. Calls `part_file "designmap.xml"`.
      Attribute list derived from `reference-docs/schemas/package/designmap.rnc`
      (root element `Document`).
- [ ] `Package.part(name)` returns a typed model instance when a registered
      class exists for `name`; falls back to `read_part(name)` (raw XML)
      otherwise.
- [ ] Spec: `Designmap.attributes.keys` matches the RNG-derived expected set.
- [ ] Spec: `Designmap.from_xml(fixture_designmap)` returns an instance with
      `dom_version: "21.5"`.
- [ ] Spec: round-trip — `Designmap.to_xml(Designmap.from_xml(xml))` produces
      XML-equivalent output (canonicalized comparison via Nokogiri).
- [ ] Spec: `Package.part("designmap.xml")` returns a `Designmap` instance.

## Files

- `lib/idml/part.rb`
- `lib/idml/parts.rb`
- `lib/idml/parts/designmap.rb`
- `lib/idml/parts.rb` — updated with `Designmap` autoload.
- `lib/idml.rb` — autoload `Part`, `Parts`.
- `spec/idml/part_spec.rb`
- `spec/idml/parts/designmap_spec.rb`
- `spec/idml/parts_spec.rb` — registry behavior.

## Design notes

- The pattern set by this TODO: one file per part class, one entry in the
  `Parts` autoload list, the part class self-registers via `part_file`.
- `Designmap` is the simplest part (single root `<Document>` with attributes
  and several child element collections). Good first model.
- Use `ordered` in the `xml do` block — IDML child order is semantically
  meaningful throughout the spec.
- The IDML namespace on the root (`xmlns:idPkg="..."`) is per-schema; preserve
  it via `namespace` directive in lutaml-model.
- For attributes whose Ruby name differs from XML name (e.g. `Self` →
  `:self_attr`), use `map_attribute "Self", to: :self_attr`. Avoid shadowing
  Ruby's `self` keyword.
- For the registry: use a hash of `Regexp => Class`. `class_for` does
  linear find — the registry is small (~12 entries), no perf concern.

## Dependencies

- TODO 01, TODO 02.
