# TODO PDF 102: Anchored objects (anchored object settings)

## Status: COMPLETE — implemented 2026-08-16

## What was built

- Model wiring: `anchored_object_setting` attribute + mapping on
  Rectangle, Oval, Polygon, GraphicLine, Group, and Path (per
  `*_Object` in Story.rnc — every page item can carry
  `<AnchoredObjectSetting>`). The setting parses AnchoredPosition
  (InlinePosition / AboveLine / Anchored), AnchorPoint,
  AnchorXoffset / AnchorYoffset, Horizontal/VerticalReferencePoint,
  and the remaining schema attributes.
- `CharacterStyleRange` now models its story-embedded page-item
  children: `rectangle`, `oval`, `polygon`, `graphic_line`,
  `group`, `text_frame` collections. Previously these elements were
  dropped at parse time — anchored objects were lost entirely.
- Rendering: `TextFrameRenderer` discovers embedded items via the
  shared `story_csrs` walk and renders each through
  `PageItemRenderer` dispatch (fill, stroke, gradients, images —
  everything the spread-level path does) with a child context.
  Items render at their own stored geometry: InDesign resolves an
  anchored object's position when saving the file, so the stored
  ItemTransform + PathGeometry IS the anchored position for all
  three AnchorTypes.

## Known limitations

- AnchorType-specific text reflow is not simulated: the layout
  engine positions body text independently of embedded items, so
  body text may overlap inline/above-line objects in frames whose
  stored text positions differ from our layout engine's output.
- HorizontalReferencePoint / VerticalReferencePoint /
  HorizontalAlignment / VerticalAlignment on the setting are parsed
  but not consulted (stored geometry already encodes the result).

## Acceptance criteria

- [x] Page item with AnchoredObjectSetting AnchorType="Inline"
      renders at its anchored position (stored geometry).
- [x] Page item with AnchorType="Above Line" renders above the
      anchored line (stored geometry).
- [x] Page item with AnchorType="Anchored" renders at the position
      derived from the anchor (stored geometry; AnchorX/Yoffset
      parsing verified).
