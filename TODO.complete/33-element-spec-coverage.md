# TODO 33: Per-element spec coverage

## Goal

Add a parameterized spec that exercises every typed element class —
guarantees the codegen output parses a minimal valid XML fragment.

## Acceptance criteria

- [ ] `spec/idml/elements_spec.rb` enumerates every class in
      `Idml::Elements` (via `Idml::Elements.constants`).
- [ ] For each class: instantiate via `<Foo Self="x"/>` (or similar
      minimal valid XML for that element's root name).
- [ ] Asserts the returned object's class.
- [ ] For classes with a `Self` attribute on the root: asserts the
      attribute round-trips.

## Files

- `spec/idml/elements_spec.rb`

## Design notes

- Catches codegen bugs that produce syntactically valid but
  semantically broken Ruby (wrong root name, missing namespace).
- Cheap to run; high coverage value.

## Dependencies

- TODOs 23-26 (the codegen output this spec verifies).
