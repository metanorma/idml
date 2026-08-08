# TODO PDF 106: Page-item type coverage — Ellipse, Path, EPS, WMF, PICT, HtmlItem

## Status: OPEN — gap identified in 2026-08-08 audit

## Problem

The IDML Spread schema (`reference-docs/schemas/package/Spreads/Spread.rnc`)
defines many page-item types. Today the codebase models and renders
six:

| Modeled & rendered | Notes |
|---|---|
| `Rectangle` | full support |
| `TextFrame` | full support |
| `Polygon` | full support |
| `GraphicLine` | full support |
| `Group` | full support |
| `Table` | full support (story-embedded) |

Schema types that are NOT modeled or NOT rendered:

| Type | Used for | Status |
|---|---|---|
| `Ellipse` | Circular/elliptical shapes | Not modeled in SpreadObject children, no renderer |
| `Image_Object` | Placed raster images | Handled via `ImageCollector` separately; not in RENDERER_MAP |
| `EPS_Object` | Placed EPS files | Not modeled, not rendered |
| `WMF_Object` | Windows Metafile (legacy) | Not modeled, not rendered |
| `PICT_Object` | Mac PICT (legacy) | Not modeled, not rendered |
| `Path_Object` | Compound paths (multi-path shapes) | Not modeled |
| `HtmlItem_Object` | Embedded HTML (InDesign 19+) | Not modeled, not rendered |
| `Movie_Object`, `Sound_Object` | Media placeholders | Not modeled, not rendered |
| `FormField_Object`, `SignatureField_Object` | Interactive forms | Not modeled, not rendered |

## What needs to happen (priorities)

1. **Ellipse** — model in `Elements::Ellipse` (very similar to Polygon;
   just emit a polygon with many vertices, or use pdfrb's circle if it
   exists). Add to SpreadObject children and RENDERER_MAP.
2. **Image in RENDERER_MAP** — today images are extracted via
   `ImageCollector` (regex-free, model-driven) but rendered in a
   separate code path. Unify so the dispatcher sees Image like any
   other page item.
3. **EPS** — model `Elements::EPS`. For rendering, either:
   - Embed the EPS as a PostScript XObject (PDF supports this), or
   - Rasterize to PNG and embed (requires external tool).
4. **Path** — model `Elements::Path` (compound shape). Renderer emits
   multiple sub-paths within one `m..l..h` sequence.
5. **HtmlItem** — out of scope for v1 (requires HTML rendering engine).
6. **Movie/Sound/FormField** — out of scope for v1 (interactive elements).

## Acceptance criteria

- [ ] SpreadObject has `ellipse` collection.
- [ ] `EllipseRenderer` registered in RENDERER_MAP.
- [ ] Image page items (when present as Spread children) render via the
      standard PageItemRenderer dispatch path.
- [ ] EPS files embedded as PostScript XObjects (or skipped with a warning).
- [ ] Compound Path objects render with multiple sub-paths.

## Dependencies

- None — independent feature work.
