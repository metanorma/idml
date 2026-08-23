# TODO PDF 130: Shape-mode (Contour) text wrap

## Status: COMPLETE — implemented 2026-08-23

## Problem

Two gaps in the text wrap (TODO 114):

1. The TextWrapMode dispatch compared against "BoundingBox" — the
   schema enum (TextWrapModes_EnumValue in datatype.rnc) spells it
   "BoundingBoxTextWrap", so REAL documents never matched any mode
   and text never wrapped.
2. Contour mode (text following the item's actual shape) was not
   implemented at all.

## What was done

- Enum fix: BoundingBoxTextWrap accepted (legacy "BoundingBox"
  spelling kept for the synthetic fixtures); JumpObjectTextWrap /
  NextColumnTextWrap approximate as the bounding box (the per-run
  width reduction already pushes text past the object);
  Contour gets real contour following.
- `Render::WrapContour`: flattens the item's PathGeometry (Bézier
  segments sampled at 8 steps, ItemTransform applied, y flipped)
  into PDF-space polygons — one per subpath, so compound paths
  with holes work via even-odd ray casting at the text band's
  midline. The overlap intervals expand by the TextWrapOffset
  bounds (`Properties > TextWrapOffset`, now modeled on
  TextWrapPreference via TypedValue) and clip to the frame.
- `TextWrapResolver` dispatches per mode; overlap_width handles
  both the box rect and polygon shapes.

## Known limitations

- Band coverage samples the midline (sub-half-line-height notches
  are missed); offsets expand intervals uniformly rather than
  offsetting the polygon geometrically; Inverse mode is not
  implemented (falls back to no wrap).
