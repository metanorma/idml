# TODO 07: XML structure models (Tags, Mapping)

## Goal

Model the two small XML/ parts.

## Acceptance criteria

- [ ] `Idml::Parts::Tags` parses `<idPkg:Tags>` root with `XMLTag` collection.
- [ ] `Idml::Parts::Mapping` parses `<idPkg:Mapping>` root with `XMLImportMap`
      collection.
- [ ] `Package.tags`, `Package.mapping` accessors.
- [ ] Round-trip spec per fixture.

## Files

- `lib/idml/parts/tags.rb`
- `lib/idml/parts/mapping.rb`
- `lib/idml/parts.rb` — autoload both.
- `lib/idml/package.rb` — accessors.
- `spec/idml/parts/{tags,mapping}_spec.rb`

## Design notes

- These are the smallest parts. Good for closing out the part layer with a
  quick win after the large TODO 04–06 work.
- `XMLTag` has `Self`, `Name`, `TagColor` attributes — straightforward.
- `XMLImportMap` has `MarkupTag`, `MappedStyle` — also straightforward.

## Dependencies

- TODO 03.
