# TODO PDF 77: PDF/A XMP packet and Catalog /Metadata stream

## Status: PARTIAL — XMP packet emitted; ICC output intent deferred

## What was implemented

`idml render --pdf-a sample.idml -o out.pdf` now emits the XMP
metadata stream required by PDF/A on `/Catalog`. The CLI flag sets
`compliance: :pdfa2a` on the Pipeline; `Pipeline` calls
`PdfaPacket.attach(writer.document, metadata)` which:

1. Builds an XMP packet string with the `pdfaid:` namespace plus the
   same `dc:`/`pdf:`/`xmp:` fields already in the Info dict.
2. Adds the packet as a `/Metadata` stream on `/Catalog` with
   `/Type /Metadata` and `/Subtype /XML`.
3. Sets `/Lang` on `/Catalog` (defaults to `en-US`).

The packet declares:

- `pdfaid:part = 2` (PDF/A-2)
- `pdfaid:conformance = A` (Level A — accessible)
- `dc:format = application/pdf`
- Title/Author/Subject/Keywords from the Info dict
- xmp:CreatorTool/CreateDate/ModifyDate from the Info dict

## What remains deferred

PDF/A also requires an `/OutputIntents` entry referencing an ICC
profile (typically sRGB IEC61966-2.1 for PDF/A-2). pdfrb's
`OutputIntents#embed_icc(icc_bytes, identifier:, condition:)` API is
ready, but the idml gem does not bundle an ICC profile binary.

To complete TODO 77 fully:

1. Vendor `sRGB.icc` (~3KB ICC v2 profile) under `data/idml/`.
2. New `Render::IccProfile` helper that reads the bundled bytes.
3. `Pipeline` calls
   `writer.document.output_intents.embed_icc(bytes, identifier: "sRGB",
   condition: "sRGB IEC61966-2.1", subtype: :GTS_PDFA1)` when
   `pdfa_requested?`.
4. Spec asserts `/OutputIntents` entry references the embedded ICC.

Until the ICC bytes are vendored, the XMP packet alone satisfies
veraPDF's "XMP Metadata required" rule (rule 6.1-2) but not the
"Output intent" rule (6.2.3).

## Verification

- `lib/idml/render/pdfa_packet.rb` — XMP packet builder + attach.
- `lib/idml/render/pipeline.rb:31` — `attach` call when compliance set.
- `spec/idml/render/pdfa_packet_spec.rb` — 11 specs covering packet
  structure, escaping, optional-field omission, idempotent attach.
- `spec/idml/render/render_pdfrb_pipeline_spec.rb` — integration spec
  verifies `/Type /Metadata`, `/Subtype /XML`, pdfaid presence.

## Acceptance criteria

- [x] `--pdf-a` flag triggers XMP packet emission.
- [x] Packet declares `pdfaid:part` and `pdfaid:conformance`.
- [x] `dc:format = application/pdf` always present.
- [x] Catalog `/Lang` set.
- [x] Packet reuses XMP-extracted fields (TODO 75).
- [x] XML special characters in field values are escaped.
- [ ] sRGB ICC profile embedded as `/OutputIntent` (deferred — needs
      binary asset vendoring).
- [ ] veraPDF compliance run reports zero metadata violations.
