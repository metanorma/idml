# TODO 05: Story + BackingStory models

## Goal

Model the two story-flavored parts. Stories carry text flow content;
BackingStory is the root of the logical XML tree.

## Acceptance criteria

- [ ] `Idml::Parts::Story` parses `<idPkg:Story>` with all RNG-declared
      attributes and child elements.
- [ ] `Idml::Parts::BackingStory` parses `<XmlStory>` (BackingStory.xml's
      root element). Sibling class, not subclass.
- [ ] Element classes nested under `Idml::Story::*`:
      `ParagraphStyleRange` (`ParagraphStyleRange`), `CharacterStyleRange`
      (`CharacterStyleRange`), `Content` (`Content`), `XMLElement`
      (`XMLElement`), `SpecialCharacter`, `DiscretionaryHyphen`, `Footnote`,
      `Gaiji`, `HiddenText`, `VariableInstance`, `Table`, `Cell`, `Attributes`
      (XMLElement attrs).
- [ ] `Package.stories` returns Array of `Story` instances.
- [ ] `Package.backing_story` returns the single `BackingStory` instance.
- [ ] Convenience: `story.text` returns the concatenated plain-text content
      of all `Content` runs.
- [ ] Round-trip spec per fixture story (4 of them) and the BackingStory.

## Files

- `lib/idml/parts/story.rb`
- `lib/idml/parts/backing_story.rb`
- `lib/idml/parts.rb` — autoload both.
- `lib/idml/package.rb` — `stories`, `backing_story` accessors.
- `spec/idml/parts/story_spec.rb`
- `spec/idml/parts/backing_story_spec.rb`

## Design notes

- Stories are where IDML gets hairy: deeply nested runs with mixed content
  (text + child elements). Use `ordered` everywhere.
- `ParagraphStyleRange` (`<ParagraphStyleRange>`) wraps block-level text;
  `CharacterStyleRange` (`<CharacterStyleRange>`) wraps inline runs. Both can
  contain `Content` (text), `XMLElement` (XML structure tag), and special
  characters (`<SpecialCharacter>`).
- `Content` element is mixed-content: has text content AND an attribute
  `XMLElement` reference. Use `map_content` + `map_attribute`.
- `story.text` is a derived convenience; the model itself preserves structure.
  Implement as an iteration over the content tree.
- XMLElement is the bridge to the logical XML structure (tags applied in
  InDesign's Structure panel). Preserve its `MarkupTag` attribute — that's
  the connection to Tags.xml.
- `BackingStory` is the root of the XML structure tree. Its `XMLElement`
  children mirror the InDesign document's logical structure. Distinct enough
  from `Story` to warrant a sibling class.

## Dependencies

- TODO 03.
