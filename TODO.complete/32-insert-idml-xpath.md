# TODO 32: InsertIdml full XPath-based slicing

## Goal

Replace the current structural-merge `InsertIdml` with a real
XPath-based subtree slicer that ports SimpleIDML's algorithm.

## Acceptance criteria

- [ ] `InsertIdml.new(dest).call(source:, at:, only:)` extracts the
      `only` XPath subtree from source's BackingStory and inserts it
      at the `at` XPath in dest's BackingStory.
- [ ] Story references carried via XMLContent are also copied.
- [ ] Spread page items that back the inserted structure are copied
      from source's spread to dest's spread.
- [ ] Spec: inserting a known article subtree into a known location
      on the destination matches the expected structure tree.

## Files

- `lib/idml/composition/insert_idml.rb`
- `lib/idml/composition/geometry.rb` (helper for spread item placement)
- `spec/idml/composition/insert_idml_spec.rb`

## Design notes

- Port from `~/src/external/SimpleIDML/src/simple_idml/idml.py`
  (`IDMLPackage.insert_idml`).
- The current structural merge is left as a fallback or removed.

## Dependencies

- TODOs 14, 12.
