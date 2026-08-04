# TODO PDF 79: PDF outline (bookmarks)

## Status: DONE

## What was implemented

`idml render` now emits PDF outline entries from IDML bookmarks. The
flow:

1. `<Bookmark>` and `<HyperlinkPageDestination>` elements are parsed
   from designmap (`Parts::Designmap#bookmark`,
   `#hyperlink_page_destination`).
2. `Render::BookmarkResolver` walks bookmarks, resolves
   `Bookmark#destination` (Self) →
   `HyperlinkPageDestination#destination_page` (Page Self) →
   page index (via spread iteration), and yields `[title, page_index]`
   pairs.
3. `Pipeline#emit_bookmarks` calls
   `PdfrbWriter#add_bookmark(title, page_index)` for each resolved
   entry. `PdfrbWriter` delegates to `Pdfrb::Document::Outline#add`.

## Element models added

- `Idml::Elements::Bookmark` — `<Bookmark>` element with Self, Name,
  and Destination attributes.
- `Idml::Elements::HyperlinkPageDestination` (added for hyperlinks)
  reused here.

## Verification

- `lib/idml/elements/bookmark.rb` — element model.
- `lib/idml/parts/designmap.rb:50` — bookmark + hyperlink_page_destination
  attributes and element mappings.
- `lib/idml/render/bookmark_resolver.rb` — destination chain + page
  lookup.
- `lib/idml/render/pipeline.rb:60` — `emit_bookmarks` call.
- `spec/idml/render/bookmark_resolver_spec.rb` — 2 specs covering
  resolved and unresolved destinations.

## Acceptance criteria

- [x] IDML bookmarks appear as top-level PDF outline entries.
- [x] Clicking a bookmark navigates to the right page (page_index).
- [x] Bookmarks with unresolvable destinations skipped.
- [x] Spec covers a fixture-equivalent synthetic with two resolvable
      and one broken bookmark.
