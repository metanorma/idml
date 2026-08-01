# TODO 13: InsertIdml composition operation

## Goal

Implement `Composition::InsertIdml` — copies an XPath subtree from
a source package into a destination package, after prefixing both
to avoid Self collisions. The foundational multi-package op.

## Acceptance criteria

- [ ] `InsertIdml.new(dest_pkg).call(source:, at:, only:)` returns
      a new Package with the source's `only` subtree inserted at the
      destination's `at` XPath.
- [ ] Both packages are prefixed before insertion: destination with
      `"main_"`, source with `"<arbitrary>_"`.
- [ ] Affected parts: BackingStory (XML structure tree), Spreads
      (page items), Stories (text flows). Resources (Fonts, Styles,
      Graphic) are merged.
- [ ] All `Self` and `XMLContent` references are rewritten to use
      the prefixed IDs.
- [ ] Spec: insert one fixture into another (or itself) and verify
      the resulting structure has the expected elements.

## Files

- `lib/idml/composition/insert_idml.rb`
- `lib/idml/composition/id_collision_resolver.rb` (helper)
- `spec/idml/composition/insert_idml_spec.rb`

## Design notes

- Port the algorithm from `~/src/external/SimpleIDML/src/simple_idml/idml.py`
  (`IDMLPackage.insert_idml`). It's well-tested there.
- Use Nokogiri for XPath navigation within BackingStory.
- Prefixing reuses the existing `Composition::Prefix` command.
- The `at` and `only` arguments are XPath expressions into the
  XML structure tree (BackingStory + Story linkage), not the file
  system. Same convention as SimpleIDML.

## Dependencies

- TODO 11 (accessors), TODO 12 (Document for navigation),
  TODO 14 (Geometry for coordinate translation — though for pure
  structural insertion, geometry can be skipped).
