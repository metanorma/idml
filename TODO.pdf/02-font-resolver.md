# TODO PDF 02: Font resolver

## Status: DONE — `Idml::Render::FontSetup` resolves the document default
font from `Resources/Fonts.xml`, with `FontReferenceResolver` providing
the family → PostScriptName lookup. Per-run resolution lives in
`TextFrameRenderer#font_for_run`. See TODOs 33, 40, 93.

## Goal

Map IDML font references (family + style) to .ttf/.otf file paths on
disk. IDML's `Fonts.xml` lists every font used; the resolver finds
the actual font program.

## Acceptance criteria

- [ ] `Idml::TextEngine::FontResolver.new(font_search_paths:)`
      accepts a list of directories to search.
- [ ] `#resolve(family_name:, style_name:)` returns a
      `FontMetrics` instance (from TODO 01) or nil if not found.
- [ ] Searches common locations: system font dirs, user font dirs,
      InDesign Document fonts folder (inside the IDML package's
      parent), and any user-configured paths.
- [ ] Handles style aliases: "Regular" = "Normal" = "Book";
      "Bold" = "Semibold" when no exact match.
- [ ] Caches resolved fonts by (family, style) key.
- [ ] Spec: resolve a system font (e.g., "Arial" / "Regular" on
      macOS or "DejaVu Sans" / "Book" on Linux).

## Files

- `lib/idml/text_engine/font_resolver.rb`
- `spec/idml/text_engine/font_resolver_spec.rb`

## Design notes

- Font resolution is inherently platform-dependent. macOS uses
  `~/Library/Fonts/`, `/Library/Fonts/`, `/System/Library/Fonts/`.
  Linux uses `/usr/share/fonts/`, `~/.local/share/fonts/`.
  Windows uses `C:\Windows\Fonts\`.
- The IDML package itself may carry a "Document fonts" folder
  (via InDesign's Package feature). Check there first.
- For tests, bundle a small open-source font (e.g., DejaVu Sans
  subset or Source Sans Pro) under `spec/fixtures/fonts/`.

## Dependencies

- TODO 01 (FontMetrics).
