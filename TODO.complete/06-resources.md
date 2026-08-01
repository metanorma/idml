# TODO 06: Resources models (Fonts, Graphic, Style, StyleMapping, Preferences)

## Goal

Model the five Resources parts.

## Acceptance criteria

- [ ] `Idml::Parts::Fonts` parses `<idPkg:Fonts>` root with `FontFamily` and
      `Font` collections.
- [ ] `Idml::Parts::Graphic` parses `<idPkg:Graphic>` root with `Color`,
      `ColorGroup`, `FlattenerCustomSettings`, `Tracking`, `Tint`, `MixedInk`,
      `MixedInkGroup`, `Gradient`, `StrokeStyle` collections per RNG.
- [ ] `Idml::Parts::Style` parses `<idPkg:Style>` root with `RootCharacterStyleGroup`,
      `RootParagraphStyleGroup`, `RootCellStyleGroup`, `RootTableStyleGroup`,
      `RootObjectStyleGroup`, plus their style children.
- [ ] `Idml::Parts::StyleMapping` parses `<idPkg:StyleMapping>` with
      `ImportXmlElementToStyleMap`, `ImportXmlElementToInlineStoryMap`,
      `ExportXmlTagToStyleMap` collections.
- [ ] `Idml::Parts::Preferences` parses `<idPkg:Preferences>` with its many
      child collections (`AdobePageMatch`, `Application`, `DocumentPreference`,
      `DisplayPerformancePreference`, etc. — list per RNG).
- [ ] `Package.fonts`, `Package.graphic`, `Package.style`,
      `Package.style_mapping`, `Package.preferences` accessors.
- [ ] Round-trip spec for each part using fixture data.

## Files

- `lib/idml/parts/fonts.rb`
- `lib/idml/parts/graphic.rb`
- `lib/idml/parts/style.rb`
- `lib/idml/parts/style_mapping.rb`
- `lib/idml/parts/preferences.rb`
- `lib/idml/parts.rb` — autoload all five.
- `lib/idml/package.rb` — accessors.
- `spec/idml/parts/{fonts,graphic,style,style_mapping,preferences}_spec.rb`

## Design notes

- These parts are large but structurally regular: root + collections of
  similar children. Pattern is repeatable across the five.
- Preferences is the biggest (1,827 RNG lines). Don't try to model every
  nested preference; model the top-level child collections and let inner
  content round-trip via nested element classes.
- Styles have nested groups (style groups contain styles). Build out the
  nested class tree.
- For long-tail elements (rare style options, obscure preferences), use
  typed mapping where the RNG gives a clear type, `:string` for opaque
  enums. Mark attribute-set assertions to match what we model.

## Dependencies

- TODO 03.
