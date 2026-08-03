# TODO PDF 61: Known limitations and future work

## Status: DOCUMENTED

## Known limitations

1. **Font embedding**: pdfrb 0.3.0 registers fonts by name but does
   not embed FontFile2 binary data in the PDF. Text renders correctly
   on systems with the font installed but may not render on other
   systems. Requires pdfrb font subsetting support (TODO 52).

2. **Image fixture tests**: The fixture IDML references an external
   JPEG at a macOS-specific path. Tests that check image embedding
   are skipped on CI. A self-contained fixture with an embedded image
   would fix this.

3. **Text engine integration**: TextFrameRenderer uses the text engine
   for line breaking when FontMetrics is available (Helvetica as .ttf).
   On macOS, Helvetica is a .ttc collection, so the fallback simple
   renderer is used (no line breaking). Per-run styling (different
   fonts/sizes in one frame) is simplified to use the first run's style.

4. **Dead code**: Old modules (PdfWriter, FontEmbedder, Color, Path,
   Text) are marked DEPRECATED but cannot be deleted per the project's
   "never delete source files" policy. They are not used by any active
   code path.

## Future enhancements

- Font subsetting (TODO 52) — requires pdfrb enhancement
- Tagged PDF / PDF/UA (TODO 53) — requires pdfrb StructTreeRoot
- Dead code removal (TODO 51) — when policy allows
- Self-contained test fixture with embedded image
- Per-run text styling with cursor tracking
- Performance benchmark for 100+ page documents
