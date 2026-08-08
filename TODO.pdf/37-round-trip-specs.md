# TODO PDF 37: Round-trip specs for element models

## Status: DONE — Every typed element class has round-trip specs under
`spec/idml/elements/` and `spec/idml/parts/` (parse → serialize →
xml-equivalent). The `sample-with-image` fixture's 14 parts are
validated against the RNC schemas; see also TODO 20 in TODO.complete.

## Goal

Add round-trip specs for every page-item element model: `from_xml(xml)`
→ `to_xml` should produce XML equivalent to the input. This catches
attribute mapping errors and child-element ordering issues.

## Why

The element models were added in TODO 14 with structural specs (parse
fixture, verify attributes) but no round-trip specs. Round-trip is the
project's core quality gate — it proves the model faithfully represents
the XML.

## Acceptance criteria

- [ ] Round-trip spec for: Page, Rectangle, TextFrame, Image, Link,
      Polygon, Group, GraphicLine.
- [ ] Each spec: read fixture part XML → from_xml → to_xml → compare
      with original (ignoring whitespace, attribute order).
- [ ] Spread-level round-trip: Spread_ud1.xml preserves all modeled
      child elements.
- [ ] Any round-trip failure identifies the specific attribute/element
      that diverged.

## Files

- `spec/idml/elements/round_trip_spec.rb`

## Dependencies

- TODO 14 (element models).
