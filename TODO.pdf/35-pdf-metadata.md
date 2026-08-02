# TODO PDF 35: PDF metadata

## Goal

Embed document metadata (Title, Author, Subject, Keywords, Creator,
Producer, CreationDate) in the PDF Info dictionary, sourced from the
IDML Preferences part.

## Why

PDF metadata is used by search engines, document management systems,
and accessibility tools. Currently the produced PDF has no metadata
beyond the bare structure.

## Acceptance criteria

- [ ] `PdfWriter#add_info(hash)` writes an Info object referenced by
      the trailer.
- [ ] Pipeline extracts metadata from Preferences (document title,
      author) and designmap (DOMVersion).
- [ ] Producer set to "idml gem v{VERSION}".
- [ ] CreationDate set to current time (PDF date format).
- [ ] Spec: render a PDF, verify `/Title`, `/Producer`, `/CreationDate`
      in the Info dictionary.

## Files

- `lib/idml/render/pdf_writer.rb` (add_info method)
- `lib/idml/render/pipeline.rb` (extract + pass metadata)
- `spec/idml/render/pdf_metadata_spec.rb`

## Dependencies

- TODO 12 (Pipeline).
