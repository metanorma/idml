# TODO 23: Delete REXML; route all XML through lutaml-model

## Goal

The gem uses ONLY `lutaml-model` for XML. No REXML, no Nokogiri, no
direct adapter access. Every query goes through typed
`Lutaml::Model::Serializable` subclasses.

## Acceptance criteria

- [ ] `lib/idml/document.rb` no longer requires or references REXML.
      `find_by_self` returns the part name where the Self was found
      (string-based search — no XML parsing).
      `story_text` and `each_story` use the typed `Story#text_content`
      and `Story#self_id`.
      `xml_structure` returns the typed `BackingStory` instance.
      `tagged_elements` walks the typed XMLElement collection.
- [ ] `lib/idml/composition/insert_idml.rb` no longer requires or
      references REXML. `BackingStoryMerger` parses via the typed
      `BackingStory` model, manipulates the typed tree, serializes back.
- [ ] New typed models:
      - `lib/idml/elements/content.rb` — `<Content>` (text).
      - `lib/idml/elements/xml_element.rb` — recursive `<XMLElement>`
        (Self, MarkupTag, XMLContent, child XMLElement, child Content).
- [ ] `Story` and `BackingStory` declare `Content` and `XMLElement`
      as typed children.
- [ ] `Story#text_content` returns the concatenated Content text.
- [ ] `Story#self_id` exposes the inner `<Story Self="...">` attribute
      via typed mapping.
- [ ] `idml.gemspec` and `Gemfile` drop the `rexml` direct dependency.
- [ ] All existing specs continue to pass (with API adjustments for
      `find_by_self` returning a String).

## Files

- `lib/idml/elements.rb` (autoloads)
- `lib/idml/elements/content.rb`
- `lib/idml/elements/xml_element.rb`
- `lib/idml/parts/story.rb` — add typed children
- `lib/idml/parts/backing_story.rb` — add typed children
- `lib/idml/document.rb` — refactor off REXML
- `lib/idml/composition/insert_idml.rb` — refactor off REXML
- `idml.gemspec`, `Gemfile`
- `spec/idml/document_spec.rb` — adjust find_by_self expectations

## Design notes

- The long-term goal remains: expand typed coverage so every element
  is typed. This TODO types just what Document and InsertIdml need:
  Content (text) and XMLElement (recursive tree).
- `find_by_self` over elements we haven't typed returns nil. Document
  this as a known limitation; the long-tail typing work (TODOs 04–07
  expansion) shrinks the gap over time.
- `BackingStoryMerger` becomes: parse dest + source into typed
  `BackingStory`, append source's `xml_element` collection to dest's,
  serialize via `BackingStory.to_xml`.

## Dependencies

- None (reversible refactor).
