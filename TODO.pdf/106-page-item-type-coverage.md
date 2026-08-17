# TODO PDF 106: Page-item type coverage — Ellipse, Path, EPS, WMF, PICT, HtmlItem

## Status: COMPLETE (rendering scope) — implemented 2026-08-17

## What was built (2026-08-17 refinement: true contours)

- `Render::Contour` — draws an item's PathGeometry as true Bézier
  contours: PathPointType anchors, LeftDirection / RightDirection
  control handles, ItemTransform applied per point, y flipped into
  PDF space. One subpath per GeometryPathType (compound paths);
  closed unless PathOpen="true"; degenerate handles fall back to the
  anchor. OvalRenderer, PathRenderer, and PolygonRenderer all
  delegate here — ovals render as real ellipses (rotation preserved
  through the transform), polygons as their actual outlines, Paths
  as compound contours. Bounding-box rectangle fallback when an
  item has no PathGeometry but has geometric_bounds.
- `Render::ShapePaint` — the single owner of the IDML → PDF paint
  mapping (solid fill, gradient shading fill, stroke styling, and
  the PDF paint-op sequencing including fill_stroke on one path).
  RectangleRenderer now delegates to it; the fill/stroke/gradient
  logic it previously duplicated across shape renderers lives in
  one place.
- Oval/Path modeled + registered in RENDERER_MAP (earlier
  milestone); Polygon renders contours instead of its bounding box.

## Out of scope (unchanged)

- EPS / WMF / PICT / HtmlItem / Movie / Sound / FormField — foreign
  or interactive formats, not modeled. Image placement goes through
  ImageCollector (separate, model-driven path).

## Acceptance criteria

- [x] SpreadObject has `oval` + `path` collections (Ellipse is the
      Oval element in the schema's naming).
- [x] OvalRenderer / PathRenderer registered in RENDERER_MAP.
- [x] True Bézier rendering from PathGeometry anchors + control
      points (TODO 106 refinement complete).
- [x] Compound Path objects render with multiple sub-paths.

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
