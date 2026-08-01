# TODO 21: Anti-pattern spec forbids Nokogiri

## Goal

Encode the "no Nokogiri" rule in the anti-pattern spec so it can never
accidentally come back. The check fires on any `require "nokogiri"` or
`Nokogiri::` reference in `lib/`.

## Acceptance criteria

- [ ] `spec/anti_patterns_spec.rb` adds a new check per lib file: no
      `nokogiri` in require statements, no `Nokogiri` constant
      references.
- [ ] Remove `nokogiri` from the existing external-require allowlist.
- [ ] Spec documents WHY (model-driven; lutaml-model is the XML
      authority; Nokogiri is a stopgap we're eliminating).

## Files

- `spec/anti_patterns_spec.rb`

## Design notes

- The check is simple: scan each lib file's source for
  `require%s+"nokogiri"` and `Nokogiri::`. Fail if found.
- This is a project-specific rule, distinct from the global "no
  internal require" check. Document both.

## Dependencies

- TODO 18 (Nokogiri removed so the spec passes from the start).
