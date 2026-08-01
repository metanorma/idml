# TODO 24: Anti-pattern hard-bans REXML

## Goal

Encode the "no REXML" rule in the anti-pattern spec. The check fires
on any `require "rexml/..."` or `REXML::` reference in `lib/`.

## Acceptance criteria

- [ ] `spec/anti_patterns_spec.rb` extends the FORBIDDEN_REQUIRES list
      to include `rexml`.
- [ ] The "no Nokogiri" check is generalized to a "no forbidden XML
      libraries" check that covers both `nokogiri` and `rexml`.
- [ ] `rexml` removed from the external-require allowlist.

## Files

- `spec/anti_patterns_spec.rb`

## Design notes

- The forbidden check looks for `require "rexml/..."` (any sub-path)
      and `REXML::` constant references.
- Document the rule's rationale in the spec comment: lutaml-model is
  the only XML authority; everything else must be typed.

## Dependencies

- TODO 23 (REXML removed so the spec passes).
