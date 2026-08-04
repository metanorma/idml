# TODO PDF 77: PDF/A XMP metadata and output intent

## Status: PLANNED (design only)

## Goal

Emit PDF/A-compliant XMP metadata so the rendered PDF passes
veraPDF/A validation. PDF/A requires:

1. An XMP metadata stream on the Catalog (`/Metadata`).
2. The XMP must include:
   - `pdfaid:part` — PDF/A version part number (e.g. `2`).
   - `pdfaid:conformance` — `A`, `B`, or `U`.
   - `dc:format` = `application/pdf`.
3. An `/OutputIntent` referencing an ICC profile (sRGB for PDF/A-2).
4. No unreferenced fonts, embedded fonts subsetted, no JPEG-in-JPEG,
   etc. (TODOs 52, 53 cover most of this).

The CLI's `--pdf-a` flag already sets `compliance: :pdfa2a` on the
Pipeline. Today this is treated as a hint but produces no PDF/A-
specific output. This TODO implements the actual XMP + output
intent emission.

## Background

pdfrb 0.4.0 ships the primitives:

- `Pdfrb::XMP::Packet` — assembles an XMP packet from Dublin Core,
  PDF, XMP Basic, and XMP Rights schemas.
- `Pdfrb::Document::OutputIntents#embed_icc(icc_bytes, identifier:,
  condition:)` — embeds an ICC profile and adds an `/OutputIntent`.
- `Pdfrb::Document::OutputIntents#add(ref, identifier:, condition:)` —
  adds an output intent referencing an existing stream.

pdfrb's `XMP::Schemas` only covers Dublin Core + PDF + XMP Basic +
XMP Rights. The PDF/A `pdfaid:` namespace is not yet modelled, so
extending the packet requires either:

1. Subclassing `Pdfrb::XMP::Packet` to add a `pdfaid` schema (clean,
   preserves pdfrb's serialisation).
2. Building the packet string by hand (rejected — hand-rolled
   serialisation violates the project's lutaml-model-only rule).

## Plan

1. Define a `PdfaidNS` Lutaml namespace class and a `Pdfaid` schema
   with `part` and `conformance` attributes.
2. Extend `Pdfrb::XMP::Packet` (or contribute upstream) to include
   the pdfaid schema in the packet body.
3. Bundle an sRGB ICC profile (or accept a user-supplied path).
4. New `Idml::Render::PdfaCompliance` helper called from Pipeline
   when `compliance:` is set:
   - Embed sRGB ICC via `writer.document.output_intents.embed_icc(...)`.
   - Build the XMP packet with pdfaid:part=2, pdfaid:conformance=A.
   - Attach the packet to the Catalog as `/Metadata`.
5. Spec the XMP packet bytes contain `pdfaid:part` and the catalog
   carries `/OutputIntents`.

## Acceptance criteria

- [ ] `idml render --pdf-a sample.idml -o out.pdf` produces a PDF
      with `/OutputIntents` referencing an sRGB ICC profile.
- [ ] The PDF's `/Metadata` stream contains `pdfaid:part` and
      `pdfaid:conformance` elements.
- [ ] `veraPDF --flavour 2a out.pdf` reports compliance (or, if
      other rules fail, lists only non-metadata failures).
- [ ] Spec covers XMP assembly and ICC embedding.

## Dependencies

- pdfrb 0.4.0 `XMP::Packet`, `OutputIntents` (DONE).
- A pdfaid schema model in pdfrb or in `Idml::Render::XmpExtensions`.
- An sRGB ICC profile asset.
- TODO 75 (Lutaml XMP) — same blocker.
