# TODO 25: CLAUDE.md — "lutaml-model only" rule

## Goal

Broaden the "No Nokogiri" rule in CLAUDE.md to "lutaml-model only"
(no Nokogiri, no REXML, no direct adapter access). Document the
architectural intent.

## Acceptance criteria

- [ ] `CLAUDE.md` Conventions section replaces the "No Nokogiri" bullet
      with a broader "lutaml-model only" rule covering Nokogiri, REXML,
      and direct adapter access.
- [ ] The rule references the anti-pattern enforcement (TODO 24).
- [ ] The rule documents the alternative: define a typed model class
      for any XML element you need to query.

## Files

- `CLAUDE.md`

## Design notes

- One bullet, one paragraph of rationale. The full reasoning lives in
  `TODO.complete/23-lutaml-only-no-rexml.md`.

## Dependencies

- TODOs 23, 24 (rule enforced when documented).
