# TODO PDF 40: Font PS name resolution from Fonts.xml

## Status: DONE

## What was implemented

The pipeline now resolves document fonts from `Resources/Fonts.xml` via
PostScriptName lookup, falling back to the default font when the file
isn't found on disk:

1. `Idml::TextEngine::FontResolver#resolve_by_ps_name(ps_name)`
   walks system font directories and matches on each candidate font's
   internal PostScript name (read by Fontisan).
2. `Idml::Render::Pipeline#resolve_document_font_path` iterates
   `Parts::Fonts#font_family` → `FontFamily#font`, skips entries with
   `Status="Missing"`, and returns the first match.
3. `Pipeline#register_font` rescues any resolver failure and returns
   `Render::DEFAULT_FONT` (`"Helvetica"`) so rendering never crashes
   when a font file is absent.
4. The chosen font name is threaded through `RenderContext` to every
   renderer via `font_ps_name`.

## Verification

- `lib/idml/render/pipeline.rb:170` — `resolve_document_font_path`
- `lib/idml/render/pipeline.rb:185` — `resolve_by_ps_name` call
- `lib/idml/text_engine/font_resolver.rb:38` — PS-name search

## Acceptance criteria

- [x] Parts::Fonts typed model parses FontFamily → Font entries.
- [x] FontFamily and Font element models expose PostScriptName.
- [x] PostScriptName-based search added to FontResolver.
- [x] Pipeline passes document font references to the resolver.
- [x] Falls back to default font when document font can't be found.

## Out of scope

Per-run font selection (each `CharacterStyleRange#applied_font`
mapped to its own registered font) requires TODO 67's multi-font
`text_rich` integration and is tracked there. This TODO covers the
document-default font, which is what every renderer uses today.
