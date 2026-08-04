# TODO PDF 81: sRGB ICC profile + output intent for PDF/A

## Status: DONE

## What was implemented

Pipeline now embeds an sRGB ICC profile and registers a PDF/A
output intent when `compliance: :pdfa2a` (or any `:pdfa*`).

1. `Render::IccProfile.srgb_bytes` returns ICC bytes from the first
   available source:
   - `ENV["IDML_SRGB_ICC"]` (explicit override)
   - `data/idml/srgb.icc` inside the gem tree (user-vendored)
   - macOS system profile at
     `/System/Library/ColorSync/Profiles/sRGB Profile.icc`
   Returns `nil` if none available.
2. `Pipeline#embed_pdfa_output_intent` reads bytes and calls
   `writer.document.output_intents.embed_icc(bytes, identifier:
   "sRGB", condition: "sRGB IEC61966-2.1", subtype: :GTS_PDFA1)`.
3. Embedding is graceful — if no profile is available, the XMP
   packet is still attached (from TODO 77) but `/OutputIntents` is
   omitted.

## Why no bundled ICC

The idml gem stays dependency-free for binary assets. Users who
need PDF/A on non-macOS systems can either:
- Set `IDML_SRGB_ICC=/path/to/srgb.icc` in the environment, or
- Drop a profile at `<gem>/data/idml/srgb.icc` after install.

This avoids bundling a binary whose licensing might be ambiguous,
while still using well-formed ICC bytes when they're available.

## Verification

- `lib/idml/render/icc_profile.rb` — locator helper.
- `lib/idml/render/pipeline.rb:32` — `embed_pdfa_output_intent` call.
- `spec/idml/render/icc_profile_spec.rb` — 3 specs covering env var,
  system path, and no-source fallback.
- Pipeline integration test: PDF/A output now includes both
  `/Metadata` (XMP) and `/OutputIntents` referencing sRGB.

## Acceptance criteria

- [x] `data/idml/srgb.icc` path supported (user-vendored).
- [x] `IDML_SRGB_ICC` env var supported.
- [x] macOS system path probed as fallback.
- [x] PDF/A output has `/OutputIntents` referencing embedded ICC
      when any source is available.
- [x] Non-PDF/A output unchanged (no ICC embedding).
- [x] Graceful fallback when no source available (XMP only).
