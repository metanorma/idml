# TODO 12: Document layer (cross-part navigation)

## Goal

`Idml::Document` wraps a Package and provides cross-part navigation
that the Package layer deliberately doesn't: resolve `Self` IDs
across parts, traverse the logical XML structure tree, expose
story text as plain strings.

## Acceptance criteria

- [ ] `Idml::Document.new(package)` constructs a Document.
- [ ] `#find_by_self(id)` searches every part for an element with
      `Self="#{id}"` and returns it (as a parsed XML node for now;
      typed model when available). Returns `nil` if not found.
- [ ] `#story_text(story_self)` returns the concatenated plain-text
      content of all `Content` runs in the story with that Self.
- [ ] `#xml_structure` returns the BackingStory tree as a Nokogiri
      document — the logical XML structure InDesign exposes via the
      Structure panel.
- [ ] `#each_story(&block)` yields each Story instance with its text.
- [ ] `#tagged_elements` returns every `XMLElement` in every Story,
      with the markup tag name. Used to map structure to styling.
- [ ] Specs use the fixture and verify a known Self ID resolves.

## Files

- `lib/idml/document.rb`
- `lib/idml.rb` — autoload `Document`.
- `spec/idml/document_spec.rb`

## Design notes

- Document is a READ-ONLY view. It delegates to Package and Parts;
  it does not own state. Constructed cheaply; operations lazy.
- Cross-part resolution requires parsing XML. We use Nokogiri for
  the search; the typed models stay as the "official" representation
  for the parts we've modeled.
- `Self` IDs are globally unique within a document (InDesign
  guarantees this), so a flat search across all parts is correct.

## Dependencies

- TODO 11 (Package accessors) — Document uses them.
