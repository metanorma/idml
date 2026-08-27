# TODO PDF 144: Named mojikumi sets modeled

## Status: COMPLETE (modeling) — implemented 2026-08-27

## Problem

Designmap-level `<MojikumiTable>` elements (named mojikumi sets:
詳細 etc. with per-class-pair aki overrides) were ignored by the
model — a document declaring custom spacing lost that information
on round-trip.

## Solution

New elements per `designmap.rnc` / `datatype.rnc`:

- `Elements::MojikumiTable` — Self / Name / BasedOnMojikumiSet +
  `#aki_overrides` (flattened document-order overrides).
- `Elements::MojikumiTableProperties` — OverrideMojikumiAkiList.
- `Elements::OverrideMojikumiAkiList` — the entries.
- `Elements::OverrideMojikumiAki` — all 8 typedef attributes
  (Target/SideMojikumiClass, SideIsAfterTarget, Minimum/Desired/
  Maximum, CompressionPriority, AkiDoesNotFloat).

`Parts::Designmap` maps the children; round-trip verified.

**Not yet applied**: rendering still uses the built-in class-based
aki rules (TODOs 125/132/13); consuming BasedOnMojikumiSet and the
override entries in `CjkLayout` is the follow-up (TODO.pdf/61).

## Files

- `lib/idml/elements/mojikumi_table.rb`
- `lib/idml/parts/designmap.rb`
- `lib/idml/elements.rb`
- `spec/idml/elements/mojikumi_table_spec.rb`
- `spec/idml/parts/designmap_spec.rb`
