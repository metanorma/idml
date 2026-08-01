# TODO 04: Spread + MasterSpread models

## Goal

Model the two spread-flavored parts. These are the largest and most
structurally diverse parts (Spread.rnc is 4,430 lines).

## Acceptance criteria

- [ ] `Idml::Parts::Spread` parses `<idPkg:Spread>` (root) with all attributes
      and child element collections from the RNG.
- [ ] `Idml::Parts::MasterSpread` parses `<idPkg:MasterSpread>` similarly.
      Subclass or sibling — decide based on RNG divergence (likely sibling;
      they have different attribute sets).
- [ ] Element classes nested under `Idml::Spread::*`:
      `Rectangle`, `Polygon`, `GraphicLine`, `TextFrame`, `Group`, `Page`,
      `Image`, `EPS`, `PDF`, `Movie`, `Sound`, `Media`, `HTMLItem`, `EPS`,
      `Page`, plus their child elements (`Properties`, `Path`, `TextFrame`,
      etc.).
- [ ] `Package.spreads` returns an Array of `Spread` instances (one per
      `Spreads/Spread_*.xml`). `Package.master_spreads` similar.
- [ ] `Package.part("Spreads/Spread_ud1.xml")` returns a `Spread` instance.
- [ ] Round-trip spec: parse → serialize → XML-equivalent, per the fixture's
      two spreads.
- [ ] Attribute-set spec: each element class declares the RNG-listed attribute
      set.

## Files

- `lib/idml/parts/spread.rb` — root + nested element classes.
- `lib/idml/parts/master_spread.rb`
- `lib/idml/parts.rb` — autoload spread/master_spread.
- `lib/idml/package.rb` — convenience accessors `spreads`, `master_spreads`.
- `spec/idml/parts/spread_spec.rb`
- `spec/idml/parts/master_spread_spec.rb`

## Design notes

- Spread is the most attribute-dense element in IDML. The RNG defines
  hundreds of attributes (most optional). Use a systematic approach:
  - Group attributes by category (geometry, styling, transitions, etc.) in
    the model file. Visual grouping only — the XML output is order-independent
    for attributes.
  - Mark optional attributes with the `:` default pattern (`attribute :foo,
    :string, default: nil` or omit default if lutaml-model handles optional).
- Child element order matters (z-order in spread). Use `ordered` on root.
- For elements that may appear many times in any order (Page items: Rectangle,
  TextFrame, Polygon, etc.), `map_element` each one with `collection: true`.
- MasterSpread is structurally similar but not identical. Read its RNG
  carefully and don't subclass unless the attribute sets truly nest.
- `Self` attributes are unique IDs; model as `:string`. Cross-references via
  `ParentStory`, `FillColor`, etc. are also strings (we don't resolve them at
  the model layer; resolution is a Document-layer concern, TODO 10+).

## Dependencies

- TODO 03 (registry pattern).
