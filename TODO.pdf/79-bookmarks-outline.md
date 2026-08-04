# TODO PDF 79: PDF outline (bookmarks)

## Status: PLANNED (design only)

## Goal

Map IDML `<Bookmark>` elements in `designmap.xml` to PDF outline
entries via `PdfrbWriter#add_bookmark` (which delegates to
`Pdfrb::Document::Outline#add`).

Each IDML bookmark references a destination (page or page item) via
its `Destination` attribute. The PDF outline is the clickable
"bookmarks" panel in PDF readers — bookmarks make large documents
navigable.

## Background

IDML models bookmarks in `designmap.xml`:

```xml
<Bookmark Self="Bookmark/abc" Name="Section 1"
          Destination="PDFPageDestination/def"/>
```

The `Destination` attribute references a `PDFPageDestination_Object`
(also in designmap.xml) which names the destination page and either
a viewport setting (`FitView`, `FitWidth`, etc.) or a Y position.

pdfrb's Outline API:

```ruby
document.outline.add(title, dest: page)  # add bookmark
document.outline.add(title, dest: page, parent: parent)  # nested
```

`PdfrbWriter#add_bookmark(title, page_index)` already exists as a
thin wrapper; this TODO extends it to accept named-destination
resolution and adds Pipeline integration.

## Plan

1. **Parse bookmarks**: extend `Parts::Designmap` to expose
   `bookmark` and `pdf_page_destination` collections (element classes
   may need adding to `Idml::Elements`).
2. **Resolve destinations**: a bookmark's `Destination` references a
   `PDFPageDestination` whose `PageDestinationPage` references a
   spread-page. Build a Self → page_index map at pipeline start.
3. **Pipeline emit step**: after rendering all spreads, iterate
   bookmarks and call
   `writer.add_bookmark(name, page_index: page_index_of(destination))`.
4. **Optional nesting**: if IDML exposes a parent/child relationship
   (it doesn't directly — bookmarks are flat), the outline stays
   flat. Future work could derive hierarchy from heading styles.

## pdfrb dependencies

- `Pdfrb::Document::Outline#add(title, dest:, parent: nil)` — DONE in
  pdfrb 0.4.0. `dest` accepts a page object or reference.

## Acceptance criteria

- [ ] IDML bookmarks appear as top-level PDF outline entries.
- [ ] Clicking a bookmark navigates to the right page.
- [ ] Bookmarks with unresolvable destinations are skipped (no crash).
- [ ] Spec covers a fixture with bookmarks + a fixture without.

## Dependencies

- Element classes `Idml::Elements::Bookmark`, `PDFPageDestination`
  (TODO: add via rnc_to_lutaml generator).
- Pipeline step ordering: outline must be built after all pages are
  registered with the writer.
