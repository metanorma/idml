# TODO PDF 14: Page-item element models

## Status: DONE — `Idml::Elements::{Page,Rectangle,TextFrame,Image,Link,
Polygon,Group,GraphicLine}` all carry attributes from the RNC and are
registered under `Idml::Elements`. Round-trip and attribute-set specs
live under `spec/idml/elements/`.

## Goal

Create typed `Lutaml::Model::Serializable` subclasses for every page-item
element that appears inside a `<Spread>`. These are the geometric objects
the renderer must iterate over: Page, Rectangle, TextFrame, Image, Link,
Polygon, Group, GraphicLine, Ellipse.

## Why

The `SpreadObject` model currently only carries attributes — it has no
typed references to its child page items. This forces the rendering
pipeline to fall back to regex on raw XML, violating the project's
"lutaml-model only" rule and making the pipeline fragile.

## Acceptance criteria

- [ ] `Idml::Elements::Page` — child of Spread; carries GeometricBounds,
      ItemTransform, AppliedMaster.
- [ ] `Idml::Elements::Rectangle` — FillColor, FillTint, StrokeColor,
      StrokeWeight, ItemTransform, GeometricBounds (via Properties),
      ContentType.
- [ ] `Idml::Elements::TextFrame` — ParentStory, ItemTransform,
      ContentType, GeometricBounds, TextFrameOffset.
- [ ] `Idml::Elements::Image` — ItemTransform, Space, ActualPpi,
      ImageTypeName.
- [ ] `Idml::Elements::Link` — LinkResourceURI, LinkResourceFormat.
- [ ] `Idml::Elements::Polygon` — ItemTransform, FillColor, PathPointArray.
- [ ] `Idml::Elements::Group` — ItemTransform, child page items.
- [ ] `Idml::Elements::GraphicLine` — ItemTransform, StrokeColor.
- [ ] Each class has a round-trip spec: `from_xml` → `to_xml` is equivalent.
- [ ] Each class is registered in `lib/idml/elements.rb` autoloads.

## Files

- `lib/idml/elements/page.rb`
- `lib/idml/elements/rectangle.rb`
- `lib/idml/elements/text_frame.rb`
- `lib/idml/elements/image.rb`
- `lib/idml/elements/link.rb`
- `lib/idml/elements/polygon.rb`
- `lib/idml/elements/group.rb`
- `lib/idml/elements/graphic_line.rb`
- `spec/idml/elements/page_item_spec.rb` (or per-class specs)

## Design notes

- Attribute lists come from `reference-docs/schemas/package/Spreads/Spread.rnc`
  at the `*_Object` definitions (Rectangle_Object at line 3471, Page_Object
  at line 4166, etc.). Only render-relevant attributes need to be declared
  initially — the rest can be added incrementally.
- The `Image` element contains a `Link` child — `Image` should have
  `attribute :link, Idml::Elements::Link, collection: true`.
- `Rectangle` and `TextFrame` can contain child `Image` elements (graphic
  content placed inside a frame).
- Reserved Ruby names: `Self` → `self_attr`, `class` → `class_attr`, etc.

## Dependencies

- TODO 14 is the foundation for TODOs 15–18.
