# TODO 16: Cross-version tolerance

## Goal

Make the gem usable with IDML files from older InDesign versions
without forcing strict DOMVersion matches. Document the policy
clearly in code and README.

## Acceptance criteria

- [ ] Document the strict-validation-is-version-scoped rule in the
      README and in `Idml::Validation::Validator` docs.
- [ ] Add `Validator#loose_validate_part` that runs Jing with a
      permissive flag (or strips the DOMVersion attribute before
      validation) so older files can be checked against the
      current schema for everything except version drift.
- [ ] Add a `Package#dom_version` convenience that reads the
      version from designmap.
- [ ] Specs cover: a known-good current fixture validates strict;
      the older `helloworld-1.idml` (2017, DOMVersion 13.x) passes
      loose validation but fails strict.

## Files

- `lib/idml/validation/validator.rb` — add `loose_validate_part`.
- `lib/idml/package.rb` — add `dom_version` accessor.
- `spec/idml/validation/cross_version_spec.rb`
- `README.adoc` — section on version compatibility.

## Design notes

- "Loose" means: tolerate DOMVersion mismatches; report every
  other schema violation. Implementation: pre-process the XML to
  blank out the DOMVersion attribute before passing to Jing.
- The helloworld fixture from idmltools samples is the canonical
  "older version" test case.

## Dependencies

- TODOs 02, 03, 09.
