# TODO PDF 24: Anti-pattern coverage for render modules

## Status: DONE — `spec/anti_patterns_spec.rb` auto-discovers every
`.rb` file under `lib/` and asserts no `nokogiri`, `rexml`,
`require_relative`, `instance_variable_set`, `.send(`, `respond_to?`,
`double()`, hand-rolled serializers, etc. Currently 279 files, 0 offenses.

## Goal

Ensure all new render and text-engine modules pass the anti-pattern
spec. Add any missing modules to the spec's file enumeration.

## Why

The anti-pattern spec (`spec/anti_patterns_spec.rb`) checks every `lib/`
file for forbidden patterns (Nokogiri, REXML, method_missing, send,
instance_variable_set, require_relative, etc.). New modules added in
TODOs 09–23 must be covered.

## Acceptance criteria

- [ ] `bundle exec rspec spec/anti_patterns_spec.rb` passes with 0
      violations across all `lib/idml/render/` and `lib/idml/text_engine/`
      files.
- [ ] No `require_relative` in any new file.
- [ ] No `double()` in any new spec file.
- [ ] All new modules use `autoload` (defined in parent namespace file).

## Files

- `spec/anti_patterns_spec.rb` (verify coverage)

## Design notes

- The spec auto-discovers all `.rb` files under `lib/`, so new files
  are automatically checked. But verify no new violations are introduced.

## Dependencies

- All TODOs that add new lib/ files.
