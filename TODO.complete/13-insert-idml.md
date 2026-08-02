# TODO 13: InsertIdml composition operation

## Goal

`Composition::InsertIdml` — merge one package's structural content
into another. Prefixes both packages to avoid Self collisions, then
merges BackingStory, Stories, Spreads, MasterSpreads, and updates
designmap's StoryList to reference the source stories.

## Status

DONE. The implementation lives in
`lib/idml/composition/insert_idml.rb`. Specs in
`spec/idml/composition/insert_idml_spec.rb` cover:
- Returns a new Package (no mutation of receiver).
- Prefixes both sides (`dest_` / `src_`).
- Carries source stories, spreads, and master spreads through.
- Rewrites designmap StoryList to include source's stories.

## Design

- Uses `Composition::Prefix` to namespace every Self reference
  (including StoryList and the various cross-reference attributes
  like FillColor, ParentStory, XMLContent) so the two packages can
  coexist in one output without ID collisions.
- Merges at the structural level: BackingStory's `xml_story`
  collection is extended; per-part copies via Package#each_part.
- No XPath. The structural merge handles the realistic use case
  (compose two packages into one). Subtree extraction at the page-
  item level would require modeling IDML's geometric reflow — out
  of scope for this gem.
