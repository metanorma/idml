# TODO 26: RNC-faithful typed models

## Goal

Every typed element class declares the full attribute set defined for
that element in the RNG Compact schemas at
`reference-docs/schemas/package/`. No more guessing from fixture
content; the RNC is the single source of truth.

## Why

The user (rightly) called out that the current StoryInner /
ParagraphStyleRange / CharacterStyleRange / Content / XmlElement
classes model only the attributes I needed for the Document queries
(Self, MarkupTag, text). The RNC declares dozens more per element —
layout, styling, hyphenation, kerning, etc. Faithful modeling means
users can manipulate every attribute the IDML spec exposes.

## Acceptance criteria

For each typed element class listed below, the attribute set must
match the corresponding RNC definition exactly. A spec asserts the
match.

- [ ] `Idml::Elements::StoryInner` ← `Story_Object` in
      `Stories/Story.rnc` (60+ attributes).
- [ ] `Idml::Elements::ParagraphStyleRange` ←
      `ParagraphStyleRange_Object` (large attribute set).
- [ ] `Idml::Elements::CharacterStyleRange` ←
      `CharacterStyleRange_Object`.
- [ ] `Idml::Elements::Content` ← `Content_Object`.
- [ ] `Idml::Elements::XmlElement` ← `XMLElement_Object`.
- [ ] Each part class (`Spread`, `MasterSpread`, `Story`,
      `BackingStory`, `Fonts`, `Graphic`, `Style`, `StyleMapping`,
      `Preferences`, `Tags`, `Mapping`, `Designmap`) declares the full
      attribute set from its root element's RNC definition.
- [ ] Round-trip per part continues to pass on every fixture (the
      attribute expansion shouldn't break parsing).

## Files

- `lib/idml/elements/*.rb`
- `lib/idml/parts/*.rb`
- `spec/idml/elements/*_spec.rb` (new) — attribute-set assertions
  against the RNC.
- `spec/idml/parts/*_spec.rb` (existing) — update attribute-set
  expectations to match RNC.

## Design notes

- The RNC for each element lists `attribute Name { type }?` lines.
  Translate each to `attribute :ruby_name, :lutaml_type` plus a
  `map_attribute "Name", to: :ruby_name` in the xml block.
- Ruby names: snake_case of the XML name (`HyphenateCapitalizedWords`
  → `:hyphenate_capitalized_words`). For Ruby-reserved names (`Self`,
  `Class`), append `_attr` (`Self` → `:self_attr`).
- Don't edit the RNC. The schema is the source of truth; the Ruby
  class mirrors it.
- The current Document queries only need a few attributes per element,
  but the classes should expose all of them. Future queries don't have
  to expand the model; they just use the methods that are already
  there.

## Dependencies

- TODO 23 (lutaml-model only).
