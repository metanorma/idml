# TODO PDF 151: Schema conformance for the Elements layer

## Status: COMPLETE — implemented 2026-08-31

## Problem

Architecture review round four: 147 element classes held hundreds
of wire attributes transcribed from the RNC, but only 11 classes
had attribute-set specs — the project's own drift defense
(CLAUDE.md convention 5) covered a tenth of the surface. Any
hand-edit that added, dropped, or misspelled a `map_attribute`
passed every test.

## Solution

- **`Idml::Schema::Rnc`** (`schema/rnc.rb`): the RNC parsing
  extracted from the generator script into a lib adapter
  (`element_attribute_map`, `element_definition`). Two consumers
  over one seam — `scripts/rnc_to_lutaml.rb` (now presentation
  only) and the conformance spec.
- **Schema-conformance spec** (`elements_schema_conformance_spec.rb`):
  for every Elements class — no wire attribute outside the RNC
  universe (catches typos and inventions), and every mapped
  destination is a declared attribute (mapping/declaration
  consistency). Legacy non-schema classes (TableCell) carry an
  explicit allow-list. Full equality is documented as
  unenforceable (deliberate subsets; typedef-composed attributes).

**Bug found by the probe and fixed**: `TextFramePreference`
carried four invented attributes (`InsetTop/Left/Bottom/Right`)
that appear in no schema, no spec, and no real file — while the
schema-faithful inset carrier (`Properties > InsetSpacing`, spec
examples 31/32) was unmodeled, so real documents' text frame
insets were silently ignored. New `Elements::InsetSpacing`
(single unit → all sides; list → [top, right, bottom, left]),
wired into `layout_frame`; the invented attributes removed.

## Files

- `lib/idml/schema.rb`, `lib/idml/schema/rnc.rb` (new)
- `scripts/rnc_to_lutaml.rb`
- `lib/idml/elements/inset_spacing.rb` (new)
- `lib/idml/elements/text_frame_preference.rb`,
  `lib/idml/elements/properties.rb`, `lib/idml/elements.rb`
- `lib/idml/render/renderers/text_frame_renderer.rb`,
  `lib/idml.rb`
- `spec/idml/elements_schema_conformance_spec.rb` (new)
- `spec/idml/elements/inset_spacing_spec.rb` (new)
