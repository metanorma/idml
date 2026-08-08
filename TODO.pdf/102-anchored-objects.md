# TODO PDF 102: Anchored objects (anchored object settings)

## Status: OPEN — gap identified in 2026-08-08 audit

## Problem

`Elements::AnchoredObjectSetting` is modeled with the standard
attributes (AnchorSpot, AnchorXunit, AnchorYunit, AnchorPoint,
AnchorSpaceBefore, etc.). The renderer doesn't consult it.

In IDML, an anchored object is a page item (Rectangle, Polygon,
Group) that's "anchored" to a position within a story's text flow.
When the text reflows, the anchored object moves with it. Today
the renderer treats anchored objects as standalone page items in
the Spread — they appear at their spread coordinates, not their
anchored position.

## What needs to happen

1. Detect when a page item has an `AnchoredObjectSetting` child
   with `AnchorType` indicating inline/anchored (vs. inline-only
   or floating).
2. For anchored items, suppress standalone rendering in the spread.
3. When laying out the story that owns the anchored object, reserve
   space at the anchor point and render the item there.

This is a significant feature — anchored objects are common in
real-world documents but rare in test fixtures.

## Acceptance criteria

- [ ] Page item with AnchoredObjectSetting AnchorType="Inline" renders
      at the anchor character's position within the text flow.
- [ ] Page item with AnchorType="Above Line" renders above the line
      containing the anchor.
- [ ] Page item with AnchorType="Anchored" renders at the absolute
      position derived from AnchorXunit / AnchorYunit.

## Dependencies

- TODO 94 (need to know character positions in the text flow).
