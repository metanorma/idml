# TODO 22: Encode "No Nokogiri" rule in CLAUDE.md

## Goal

Make the project-level ban on Nokogiri explicit in `CLAUDE.md` so
future Claude instances don't re-introduce it. Add it to the
conventions section.

## Acceptance criteria

- [ ] `CLAUDE.md` "Conventions" section adds a "No Nokogiri" rule
      with rationale.
- [ ] The rule references the anti-pattern check (TODO 21) as the
      automated enforcement.
- [ ] The rule documents the alternative: use `lutaml-model` typed
      methods where possible; use REXML for ad-hoc XML manipulation.

## Files

- `CLAUDE.md`

## Design notes

- Keep the rule short — one bullet with one sentence of rationale.
- The full reasoning lives in `TODO.complete/18-remove-nokogiri.md`.

## Dependencies

- TODOs 18, 21 (so the rule is enforced when it's documented).
