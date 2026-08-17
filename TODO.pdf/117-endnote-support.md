# TODO PDF 117: Endnote support

## Status: OPEN (modeling COMPLETE 2026-08-18; rendering OPEN pending
a real fixture)

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

## Design for rendering (needs a real InDesign fixture to validate)

1. Marker: story-level `Endnote`/`EndnoteRange` pairs delimit the
   anchor range; marker position requires story text-offset
   bookkeeping the extraction layer doesn't currently track (unlike
   footnotes, which sit inside a CSR). A range-aware extraction is
   the prerequisite.
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
