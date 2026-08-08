# TODO PDF 33: Font resolution from IDML

## Status: DONE — `Parts::Fonts` parses FontFamily → Font entries
(`postscript_name` accessor). `FontReferenceResolver.build(package)`
constructs the family → PSName lookup. `FontSetup` resolves to a file
path via pdfrb's FontResolver. See TODOs 40, 93 and
`lib/idml/render/font_reference_resolver.rb`,
`lib/idml/render/font_setup.rb`.

## Goal

Resolve fonts referenced in IDML documents using Resources/Fonts.xml.
The FontFamily and Font entries map family/style names to PostScript
names, which the FontResolver uses to find the actual font file.

## Why

Currently the Pipeline always uses "Helvetica" as the default font.
Real IDML documents reference specific fonts (Minion Pro, Myriad Pro,
etc.) via CharacterStyleRange#AppliedFont. The Fonts.xml part carries
the PostScriptName needed to locate the font file on disk.

## Acceptance criteria

- [ ] `Parts::Fonts` typed model parses FontFamily → Font entries.
- [ ] `FontFamily#name` and `Font#postscript_name` accessible.
- [ ] Pipeline reads `package.fonts` and passes font info to the
      FontResolver.
- [ ] FontResolver can search by PostScriptName (not just family name).
- [ ] CharacterStyleRange#applied_font mapped to a font file.
- [ ] Spec: load fixture Fonts.xml, verify "Minion Pro" family has
      PostScriptName "MinionPro-Regular".

## Files

- `lib/idml/parts/fonts.rb` (verify typed model)
- `lib/idml/elements/font_family.rb` (verify)
- `lib/idml/elements/font.rb` (verify)
- `lib/idml/text_engine/font_resolver.rb` (add PS name search)
- `spec/idml/text_engine/font_resolver_spec.rb`

## Dependencies

- TODO 01 (FontMetrics).
- TODO 02 (FontResolver).
