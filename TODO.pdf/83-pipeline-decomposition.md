# TODO PDF 83: Pipeline decomposition

## Status: DONE

## What was done

Two extractions from `Pipeline` into dedicated classes:

1. **`Render::MetadataBuilder`** — metadata assembly (combined
   defaults + XMP-extracted fields, ISO 8601 → PDF date conversion).
2. **`Render::FontSetup`** — document font resolution via
   `Pdfrb::FontResolver`, registration with pdfrb, and
   `PdfrbFontMetrics` adapter construction.

Pipeline now does pure orchestration: build writer → set metadata →
apply compliance → set up structure → resolve font → render spreads
→ flush structure → emit bookmarks → subset → write. No parsing,
no date math, no font-path lookup.

## Why

Pipeline had 9 private methods across metadata, font setup, and
rendering concerns. Each concern is now its own class:

- `MetadataBuilder` — Info dict assembly.
- `FontSetup` — font file lookup + registration + metrics adapter.
- `PdfaPacket` — XMP packet + Catalog /Metadata attachment.
- `IccProfile` — locate sRGB ICC bytes.
- `BookmarkResolver` — destination chain + page index.
- `HyperlinkResolver` — source → URL lookup.
- `HyperlinkEmitter` — Link annotation emission.
- `StructureTracker` — MCID allocation + element registration.
- `StructureMapper` — item → PDF structure type.
- `ImageCollector` — image registration + placement.

Pipeline shrunk from ~225 lines (v0.3.0) to ~135 lines (v0.4.2).

## Verification

- `lib/idml/render/metadata_builder.rb` — extracted.
- `lib/idml/render/font_setup.rb` — extracted.
- `lib/idml/render/pipeline.rb` — orchestration only.
- `spec/idml/render/metadata_builder_spec.rb` — 5 specs.
- `spec/idml/render/font_setup_spec.rb` — 4 specs.
- `spec/idml/render/placement_spec.rb` — added for completeness.

## Acceptance criteria

- [x] MetadataBuilder extracted.
- [x] FontSetup extracted.
- [x] Pipeline no longer contains metadata/font helpers.
- [x] Each extracted class has dedicated specs.
- [x] All existing pipeline specs still pass.

