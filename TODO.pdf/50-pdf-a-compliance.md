# TODO PDF 50: PDF/A compliance mode

## Goal

Add a `--pdf-a` option that produces PDF/A-1a, PDF/A-2a, or PDF/A-3a
compliant output. Requires: all fonts embedded, ICC profiles, tagged
content, XMP metadata, no encryption.

## Acceptance criteria

- [ ] Pipeline accepts a `compliance:` option (:pdfa1a, :pdfa2a, :pdfa3a).
- [ ] All fonts force-embedded (no Type1 base-14 fallback).
- [ ] ICC color profile embedded (sRGB for screen, FOGRA39 for print).
- [ ] XMP metadata packet in the PDF.
- [ ] Tagged content for accessibility (StructTreeRoot).
- [ ] Spec: produce a PDF/A-2a file, verify structure markers.

## Dependencies

- TODO 11 (font embedding).
- TODO 35 (PDF metadata).
