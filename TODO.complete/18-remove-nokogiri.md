# TODO 18: Remove Nokogiri dependency entirely

## Goal

Strip Nokogiri from the gem. Nokogiri is a heavy C-extension XML
library; the gem should be fully model-driven through `lutaml-model`,
falling back to REXML (stdlib) for ad-hoc XML manipulation the typed
models don't yet cover.

## Acceptance criteria

- [ ] `lib/idml/document.rb` no longer requires or references Nokogiri.
      Uses REXML (`rexml/document`) for ad-hoc XML queries.
- [ ] `lib/idml/composition/insert_idml.rb` no longer requires or
      references Nokogiri. `BackingStoryMerger` uses REXML.
- [ ] `idml.gemspec` no longer declares `nokogiri` as a dependency.
- [ ] `Gemfile` no longer includes `gem "nokogiri"`.
- [ ] No file in `lib/` requires or references Nokogiri (enforced by
      the anti-pattern spec — see TODO 21).
- [ ] All existing specs continue to pass.

## Files

- `lib/idml/document.rb` — refactor.
- `lib/idml/composition/insert_idml.rb` — refactor.
- `idml.gemspec`, `Gemfile` — remove nokogiri.

## Design notes

- REXML is stdlib; no install friction. Slower than Nokogiri but
  adequate for IDML files (typically < 1 MB per part).
- The long-term goal is full type coverage so even REXML goes away —
  every query routed through typed model methods. REXML is a stopgap
  for parts of the model not yet typed.

## Dependencies

- None (reversible refactor).
