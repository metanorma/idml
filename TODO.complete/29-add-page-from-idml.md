# TODO 29: AddPageFromIdml composition op

## Goal

Implement `Composition::AddPageFromIdml` — copy a page from a source
package into a destination package. Follows the same pattern as
`InsertIdml` (structural merge) and uses `Prefix` to avoid Self
collisions.

## Acceptance criteria

- [ ] `AddPageFromIdml.new(dest_pkg).call(source:, page_number:, at:, only:)`
      returns a new Package with the source's specified page appended.
- [ ] Prefixes both packages to avoid Self collisions.
- [ ] Adds the source page's spread to dest's spreads list (in designmap).
- [ ] Adds the source page's stories to dest's package.
- [ ] Spec: adding a page from a multi-page fixture to a single-page
      fixture results in a package with one more page.

## Files

- `lib/idml/composition/add_page_from_idml.rb`
- `spec/idml/composition/add_page_from_idml_spec.rb`

## Design notes

- Page-level extraction from a Spread requires identifying which
  `<Page>` child of the spread corresponds to the requested page
  number, plus the page items between this Page boundary and the next.
- This is a simplified structural implementation — full geometric
  reflow is deferred.

## Dependencies

- TODOs 11, 14 (Geometry for transforms if needed).
