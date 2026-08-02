# TODO PDF 29: Character style extraction

## Goal

Extract font family, size, color, and style attributes from
CharacterStyleRange elements in Stories. Pass these as styled text runs
to the text engine for per-run rendering.

## Why

Currently the renderer uses `story.text_content` which flattens all
styled runs into a single string. Real documents have mixed fonts,
sizes, and colors within a single text frame. Each CharacterStyleRange
carries `AppliedFont`, `PointSize`, `FillColor`, `FontStyle` etc.

## Acceptance criteria

- [ ] `Idml::Render::StyleResolver` extracts styled runs from a Story.
- [ ] Each run carries: text, font_family, font_style, point_size,
      fill_color, fill_tint.
- [ ] Style attributes cascade from ParagraphStyleRange →
      CharacterStyleRange (CSR overrides PSR).
- [ ] Style attributes resolved from Resources/Styles.xml when CSR
      references an `AppliedCharacterStyle`.
- [ ] Spec: extract runs from the fixture's Story, verify font size
      and family are populated.

## Files

- `lib/idml/render/style_resolver.rb`
- `spec/idml/render/style_resolver_spec.rb`

## Dependencies

- TODO 14 (CharacterStyleRange model exists).
- TODO 22 (ColorResolver).
