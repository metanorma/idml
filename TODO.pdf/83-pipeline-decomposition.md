# TODO PDF 83: Pipeline decomposition

## Status: DONE

## What was done

Extracted metadata assembly from `Pipeline` into a dedicated
`Render::MetadataBuilder` class. Pipeline now calls
`MetadataBuilder.new(@package).build` instead of inlining the XMP
parsing, date conversion, and defaults logic.

## Why

Pipeline had five private methods dedicated to metadata
(`combined_metadata`, `xmp_metadata`, `default_metadata`,
`pdf_date_string`, `pdf_date`). Each was a single responsibility
unrelated to the pipeline's core orchestration role. Moving them
into a focused class:

- Shrinks Pipeline by ~55 lines.
- Makes MetadataBuilder independently testable.
- Makes Pipeline's intent clearer: orchestrate, not parse.
- Lets future metadata sources (e.g., IDML document properties,
custom user metadata) plug in without touching Pipeline.

## Verification

- `lib/idml/render/metadata_builder.rb` — extracted class.
- `lib/idml/render/pipeline.rb:25` — single-call usage.
- `spec/idml/render/metadata_builder_spec.rb` — 5 specs covering
  defaults, XMP extraction, and the no-XMP fallback.

## Acceptance criteria

- [x] MetadataBuilder extracted as a separate class.
- [x] Pipeline no longer contains XMP/date helpers.
- [x] Existing pipeline specs still pass.
- [x] MetadataBuilder has dedicated specs.
