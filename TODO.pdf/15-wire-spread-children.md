# TODO PDF 15: Wire SpreadObject child elements

## Status: DONE — `Idml::Elements::SpreadObject` declares typed child
collections and uses `ordered` mapping. `Idml::Parts::Spread#each_page_item`
yields every page item in document order. See
`lib/idml/elements/spread_object.rb`, `lib/idml/parts/spread.rb`.

## Goal

Extend `Idml::Elements::SpreadObject` to expose its child page items as
typed collections, and `Idml::Parts::Spread` to provide convenient
accessors for rendering.

## Why

The `SpreadObject` currently maps only attributes. The rendering pipeline
needs to iterate over `page`, `rectangle`, `text_frame`, `image`, `polygon`
collections to render each item. Without typed child references, the
pipeline must parse raw XML.

## Acceptance criteria

- [ ] `SpreadObject` declares `attribute :page, Idml::Elements::Page,
      collection: true` and similarly for rectangle, text_frame, image,
      polygon, group, graphic_line.
- [ ] The XML mapping uses `map_element "Page", to: :page` etc.
- [ ] The mapping uses `ordered` to preserve child-element z-order
      (semantically meaningful in IDML — determines visual stacking).
- [ ] `Parts::Spread#each_page_item` yields each child element in document
      order, regardless of type.
- [ ] Round-trip: `Parts::Spread.from_xml(xml).to_xml` is equivalent to
      the original XML (for the modeled subset).
- [ ] Spec: load the sample fixture's Spread_ud1.xml and verify
      `spread.spread.first.page.first.geometric_bounds` is populated.

## Files

- `lib/idml/elements/spread_object.rb` (modify)
- `lib/idml/parts/spread.rb` (add `each_page_item`)
- `spec/idml/parts/spread_spec.rb`

## Design notes

- `ordered` is critical: IDML z-order = child-element order. If the
  mapping isn't ordered, lutaml-model may reorder children on round-trip.
- The `Properties` child element (Label/KeyValuePair) is metadata, not
  a page item — it should not appear in `each_page_item`.

## Dependencies

- TODO 14 (page-item element models).
