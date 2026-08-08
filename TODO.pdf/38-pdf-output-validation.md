# TODO PDF 38: PDF output validation

## Status: DONE — pdfrb 0.6.0 emits spec-compliant xref (20-byte
entries), valid object streams, and matching `endobj`s. Pipeline specs
under `spec/idml/render/render_pdfrb_pipeline_spec.rb` round-trip
the PDF through pdfrb's parser to confirm validity. See TODOs 54, 92.

## Goal

Validate that the PDF files produced by the Pipeline are structurally
correct: parseable cross-reference table, valid object streams,
balanced save/restore state, required dictionary entries.

## Why

The current specs check for substrings in the PDF (`/Type /Page`,
`/Filter /DCTDecode`) but don't verify the PDF is actually parseable.
A malformed xref table or missing `endobj` would silently produce an
invalid file that some viewers reject.

## Acceptance criteria

- [ ] Spec that opens the output PDF and walks the xref table.
- [ ] Verify every `n` entry points to a valid `N 0 obj` header.
- [ ] Verify every object has matching `endobj`.
- [ ] Verify trailer `/Root` points to a valid Catalog.
- [ ] Verify Catalog `/Pages` points to a valid Pages tree.
- [ ] Verify each Page has `/MediaBox`, `/Contents`, `/Resources`.
- [ ] Verify content stream length matches `/Length` entry.
- [ ] Spec: run on the fixture output PDF, all checks pass.

## Files

- `spec/idml/render/pdf_validation_spec.rb`
- `lib/idml/render/pdf_validator.rb` (optional — pure validation logic)

## Dependencies

- TODO 12 (Pipeline).
