# TODO PDF 81: sRGB ICC profile + output intent for PDF/A

## Status: PLANNED (needs binary asset)

## Goal

Vendor an sRGB ICC profile (~3 KB ICC v2) under `data/idml/` and wire
it into `Pipeline` so PDF/A output registers a real `/OutputIntent`
referencing the embedded profile. Closes the remaining gap in
TODO 77 (XMP packet is emitted today; output intent is not).

## Background

PDF/A-2 requires:

- `/OutputIntents` array on `/Catalog` with at least one entry.
- Each entry references an ICC profile stream and declares
  `/OutputConditionIdentifier` (e.g., `"sRGB"`) plus
  `/S /GTS_PDFA1`.

pdfrb 0.5.0 exposes the API:

```ruby
document.output_intents.embed_icc(icc_bytes,
                                  identifier: "sRGB",
                                  condition: "sRGB IEC61966-2.1",
                                  subtype: :GTS_PDFA1)
```

What's missing: the ICC bytes themselves.

## Plan

1. **Vendor sRGB ICC bytes** under `data/idml/sRGB.icc`. Source
   options:
   - The ICC's official sRGB IEC61966-2.1 profile (~3 KB binary).
   - A minimal hand-built v2 profile.
2. **`Render::IccProfile`** helper that loads the bytes via a path
   relative to the gem root (similar to `Pdfrb::DataDir.resolve`).
3. **Pipeline integration**:
   ```ruby
   if pdfa_requested?
     PdfaPacket.attach(writer.document, metadata)
     bytes = IccProfile.srgb_bytes
     writer.document.output_intents.embed_icc(
       bytes, identifier: "sRGB", condition: "sRGB IEC61966-2.1",
       subtype: :GTS_PDFA1
     )
   end
   ```
4. **Spec** asserts `/OutputIntents` present, references an ICC
   stream with the right identifier.

## Acceptance criteria

- [ ] `data/idml/sRGB.icc` exists and is < 10KB.
- [ ] PDF/A output has `/OutputIntents` referencing the embedded ICC.
- [ ] veraPDF validation reports zero metadata-related failures.
- [ ] Non-PDF/A output unchanged (no ICC embedding).

## Dependencies

- pdfrb `OutputIntents#embed_icc` (DONE).
- sRGB ICC profile binary (TODO: vendor).
