# TODO 28: Designmap migration to DocumentObject

## Goal

Replace the hand-written attribute list on `Idml::Parts::Designmap`
with a typed `DocumentObject` inner element — the same wrapper
pattern used by `Story` (which wraps `StoryInner`).

## Acceptance criteria

- [ ] `Designmap` declares a single `inner` attribute of type
      `Idml::Elements::DocumentObject`.
- [ ] `Designmap.dom_version`, `Designmap.self_attr`, `Designmap.name`
      continue to work via delegation.
- [ ] All existing designmap specs pass unchanged.
- [ ] Round-trip suite continues to pass on every fixture.

## Files

- `lib/idml/parts/designmap.rb`
- `lib/idml/elements/document_object.rb` (regenerate if needed)
- `spec/idml/parts/designmap_spec.rb` (existing — verify still passes)

## Design notes

- The current Designmap has 33 hand-written attributes that match
  `Document_Object`'s direct attributes. Migrating them into the
  typed `DocumentObject` element keeps the wrapper pattern consistent
  with Story → StoryInner, Spread → SpreadObject, etc.

## Dependencies

- None.
