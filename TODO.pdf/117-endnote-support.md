# TODO PDF 117: Endnote support

## Status: COMPLETE — implemented 2026-08-26

## Problem

IDML endnotes use a reference architecture unlike footnotes: the
main story carries `<Endnote Self="..." EndnoteTextRange="..."/>`
plus `<EndnoteRange SourceEndnote="..."/>` markers (both at Story
level, per Story.rnc), while the endnote TEXT lives in a separate
story flagged `IsEndnoteStory="true"`. Documents with endnotes
(scholarly publishing) currently drop endnote text entirely.

## What is done (2026-08-18)

- `Elements::Endnote` (Self, EndnoteTextRange) and
  `Elements::EndnoteRange` (Self, SourceEndnote) — schema-faithful
  models, wired into `StoryInner` (`endnote`, `endnote_range`
  collections). Round-trip + parse specs.
- `StoryInner#is_endnote_story` already parsed, so endnote stories
  are identifiable.
- Reference markers render (2026-08-19): CSR-level `EndnoteRange`
  elements (verified against CharacterStyleRange_Object in
  Story.rnc) emit superscript marker runs numbered by a counter
  SEPARATE from footnotes — endnoted text now shows visible numbered
  references instead of dropping them. `StoryInner` also parses
  `StoryPreference` (vertical writing support).

## End-of-story text rendering (2026-08-26)

1. ~~Marker~~ DONE 2026-08-19: CSR-level EndnoteRange emits a
   superscript marker run at the CSR's position (same pattern as
   footnotes). Story-level Endnote/EndnoteRange pairs (no CSR
   anchor) remain unplaced.
2. Endnote text: resolve `EndnoteTextRange` → the endnote story
   (IsEndnoteStory) → its paragraphs.
3. Placement: per EndnoteOption Scope — end of story / end of
   section / end of document; end-of-story is the tractable default
   (append after the referencing story's last paragraph).
4. Numbering: endnotes number separately from footnotes
   (FootnoteOption vs EndnoteOption StartAt/Prefix/Suffix — the
   Endnote preference object is not yet modeled in Preferences).

## Why rendering is deferred

The marker-position machinery (text-range resolution) cannot be
validated without a real fixture; blind implementation risks wrong
anchor placement on production files. Schema modeling + round-trip
is complete and verified.

## Final implementation notes

When a main story carries EndnoteRange markers, the package's
endnote stories (IsEndnoteStory="true", package order) append
after the main flow via the chain state — end-of-story placement
per the design above. Each endnote story's first run is prefixed
with its ordinal ("1 …", "2 …") matching the body markers'
sequential numbering. Verified by an end-to-end synthetic-package
spec (3 text blocks with the marker, 1 without).

## Known limitations

- Multi-story linkage is not modeled: ALL endnote stories follow
  the marker-bearing story (correct for single-article documents;
  the EndnoteTextRange chain remains the fixture-gated refinement
  for multi-article layouts).
- EndnoteOption (Scope / StartAt / Prefix / Suffix) is not yet
  modeled in Preferences; numbering is ordinal.
