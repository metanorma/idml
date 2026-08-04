# TODO PDF 78: Hyperlink annotations

## Status: PLANNED (design only)

## Goal

Map IDML `<HyperlinkTextSource>` / `<HyperlinkTextDestination>` /
`<HyperlinkURLObject>` to PDF Link annotations:

- URL hyperlinks → `/Subtype /Link` with `/A /URI` action.
- Page-item cross-references → `/Subtype /Link` with `/D` destination.
- Email, file, and text-anchor destinations per the same pattern.

Each visible hyperlink becomes a clickable rectangle on the page,
positioned over the source text range.

## Background

IDML models hyperlinks as **text sources** in `Stories/Story_*.xml`
and **destinations** in `designmap.xml` and across stories:

```xml
<!-- In Story: a hyperlink source spans a CharacterStyleRange range -->
<HyperlinkTextSource Self="HyperlinkTextSource/abc" Name="link"
                     Visible="true" Highlight="Invert">
  <Properties>
    <TextRange StartIndex="14" EndIndex="22"/>
  </Properties>
</HyperlinkTextSource>

<!-- In designmap.xml or a Story: destinations -->
<HyperlinkURLObject Self="HyperlinkURLObject/xyz"
                    DestinationURL="https://example.com"
                    DestinationName="Example"/>
<HyperlinkPageItemReference Self="..." DestinationPageItem="di1"/>
```

The source's `TextRange` says "characters 14-22 of this story".
Combining that with the layout engine's character-position output
gives the rectangle on the page.

## Plan

1. **Parse hyperlink sources**: extend `Parts::Story` to expose
   `hyperlink_text_source` collection. Same for
   `hyperlink_text_destination`. Element classes already in
   `Idml::Elements` (TODO: add if missing).
2. **Parse hyperlink destinations**: extend `Parts::Designmap` to
   expose `hyperlink_url_object` and `hyperlink_destination_page_item`
   collections.
3. **Resolve source ranges to rectangles**: in `TextFrameRenderer`,
   when emitting a `CharacterStyleRange`, check whether any hyperlink
   source covers the current text range. If yes, emit the rectangle
   for that range as a Link annotation.
4. **Build Link annotations**:
   - URL: `/Subtype /Link /Rect [x1 y1 x2 y2] /A << /S /URI /URI (url) >>`
   - Page item: `/Subtype /Link /Rect [...] /D [page_ref /XYZ x y zoom]`
5. **Pipeline plumbing**: each annotation needs a page reference;
   add `writer.add_link_annotation(page_index:, rect:, uri: nil, dest: nil)`.

## pdfrb dependencies

- `Pdfrb::Document::Annotations#add(rect:, subtype:, **attrs)` — generic
  annotation helper. Verify presence and signature.

## Acceptance criteria

- [ ] URL hyperlinks in IDML render as clickable Link annotations.
- [ ] Cross-reference links jump to the correct page+position.
- [ ] Hidden hyperlinks (`Visible="false"`) are skipped.
- [ ] Spec covers URL, page-item, and invisible cases.

## Dependencies

- IDML element classes for hyperlink sources/destinations (mostly
  present — verify and extend as needed).
- pdfrb Annotations API.
- Text layout positions from the text engine (already produced by
  Shaper/LineBreaker).
