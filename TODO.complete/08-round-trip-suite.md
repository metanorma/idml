# TODO 08: Whole-package round-trip suite

## Goal

End-to-end: open `spec/fixtures/sample-with-image/sample-with-image.idml`,
parse every typed part, serialize back, rezip, assert XML-equivalence per
part.

## Acceptance criteria

- [ ] `spec/idml/round_trip_spec.rb` opens the fixture, iterates every part
      name, calls `Package.part(name)`, calls `to_xml` on the result, and
      asserts the output is XML-equivalent (via Nokogiri canonicalization)
      to the original.
- [ ] All 14 typed parts pass: designmap, 2 spreads, 1 master spread, 4
      stories, BackingStory, Tags, Graphic, Fonts, Styles, Preferences.
- [ ] Untyped parts (mimetype, META-INF/container.xml, META-INF/metadata.xml)
      round-trip as raw bytes.
- [ ] `Idml::Package.write(parts:, to:)` produces a valid IDML ZIP that
      Adobe InDesign can open (manual verification by user; document the
      verification in spec comments — wait, no comments — in the TODO file).
- [ ] Byte-for-byte comparison documented: where it matches and where it
      differs (e.g., XML declaration whitespace, attribute order). Use
      canonicalization for the comparison; report drift.

## Files

- `spec/idml/round_trip_spec.rb`
- `lib/idml/test_support.rb` (optional) — helpers like
  `assert_xml_equivalent(a, b)`. If small enough, inline in the spec.

## Design notes

- XML equivalence: parse both sides with Nokogiri, canonicalize via
  `Nokogiri::XML::Document#canonicalize`, compare strings. This handles
  attribute order, whitespace, namespace declaration placement.
- For the strictest round-trip (byte-for-byte), document but don't gate the
  suite on it — that's a future enhancement requiring tighter XML formatter
  control.
- Parameterize by fixture so we can add cross-version fixtures later.

## Dependencies

- TODO 02–07 (all part models).
