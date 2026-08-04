# TODO PDF 65: pdfrb feature integration

## Status: DONE

All proposals landed in pdfrb 0.4.0+ are now integrated into the idml
gem's render pipeline. Summary of what's wired up:

## Implemented features

1. **Canvas#text_lines** (TODO 27): `TextFrameRenderer#engine_render`
   emits one `text_lines` call per styled run after shaping/line-
   breaking. Each run's glyphs render as a batched multi-line block.
2. **Canvas#text_rich** (TODO 67): `TextFrameRenderer#simple_render`
   emits one `text_rich` call per frame in the no-metrics fallback
   path. pdfrb's measurement API handles run advance.
3. **Real PDF gradient shadings** (TODOs 49, 66, 68): `RectangleRenderer`
   dispatches to `Shadings#add_axial` or `add_radial` based on
   `Gradient.type`, then `Canvas#fill_shading`.
4. **Canvas#with_transparency** (TODO 69): `Blending.wrap` applies
   IDML `BlendingSetting` opacity + blend modes to all shape renderers.
5. **Stroke-style setters** (TODO 70/72): `StrokeStyle.apply` calls
   `Canvas#line_cap=`/`line_join=`/`miter_limit=`/`dash_pattern=` from
   IDML `EndCap`/`EndJoin`/`MiterLimit`/`StrokeDashAndGap`.
6. **Font subsetting** (TODO 52): `Pipeline` calls `Fonts#subset_fonts!`
   before write. Each TrueType font's FontFile2 is rewritten with only
   the used glyphs.
7. **Tagged PDF structure** (TODO 76): `StructureTracker` +
   `StructureMapper` + `PageItemRenderer.wrap_tagged` emit a real
   `/StructTreeRoot` with per-item structure elements.
8. **PDF/A XMP** (TODO 77): `PdfaPacket` builds an XMP packet declaring
   `pdfaid:part=2`, `pdfaid:conformance=A`, attaches as
   `/Catalog/Metadata` stream when `compliance:` is set.
9. **XMP metadata extraction** (TODO 75): `Parts::XmpMeta` parses
   `META-INF/metadata.xml` (XMP packet) using Lutaml namespace
   composition; Pipeline threads dc:title/creator/description/subject
   plus xmp:CreatorTool/CreateDate/ModifyDate into the Info dict.
10. **Per-glyph width measurement** (TODO 63): `TextEngine::PdfrbFontMetrics`
    delegates to pdfrb's `Fonts#glyph_width` (real TTF parsing via
    `Pdfrb::Font::TrueType::File`). Fontisan dependency removed.
11. **Font resolution** (TODO 40): Pipeline resolves document fonts
    via `Pdfrb::FontResolver#find_by_ps_name`, falls back to default.

## Deferred / out of scope

- **PDF/A ICC output intent** (TODO 77 partial) — sRGB ICC profile
  not vendored. XMP packet alone satisfies "XMP required" rule but
  not the "output intent" rule.
- **Hyperlinks** (TODO 78) — design doc only.
- **Bookmarks/outline** (TODO 79) — design doc only.
- **Stroke style references** (TODO 70 limitation) — only inline
  `StrokeDashAndGap` attribute is parsed; named `StrokeStyle` self-IDs
  in Resources/Graphic.xml not yet resolved.

## Acceptance criteria

- [x] TextFrameRenderer uses `canvas.text_lines` (engine path) and
      `canvas.text_rich` (fallback path).
- [x] Real PDF gradient shadings via pdfrb.
- [x] Transparency and blend modes.
- [x] Stroke styling.
- [x] Font subsetting.
- [x] Tagged PDF structure.
- [x] PDF/A XMP packet.
- [x] XMP metadata extraction.
- [x] FontMetrics replaced with pdfrb measurement.
- [x] FontResolver replaced with `Pdfrb::FontResolver`.
- [x] `fontisan` removed from gemspec.
