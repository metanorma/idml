# TODO PDF 40: Font PS name resolution from Fonts.xml

## Goal

Connect the IDML document's Fonts.xml (FontFamily/Font entries with
PostScriptName) to the FontResolver so text rendering uses the correct
font, not the hardcoded "Helvetica" default.

## Status: PARTIALLY DONE

## What was done

- Verified `Parts::Fonts` typed model parses FontFamily → Font entries.
- `FontFamily` and `Font` element models exist and expose PostScriptName.
- The FontResolver can find fonts by family name + style.

## What remains

- Map CharacterStyleRange#applied_font → FontFamily/Font → PostScriptName
  → FontResolver search.
- Add PostScriptName-based search to FontResolver (current search is
  family-name based).
- Pipeline: pass document font references to the font resolver.
- When a document font can't be found on disk, log a warning and fall
  back to the default font.

## Dependencies

- TODO 29 (StyleResolver for applied_font extraction).
- TODO 33 (font resolution from IDML).
