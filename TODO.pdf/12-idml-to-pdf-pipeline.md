# TODO PDF 12: IDML → PDF pipeline

## Goal

Top-level pipeline: `Idml::Package` → `Pdfrb::Document` → PDF file.
Ties together the text engine, render layer, and pdfrb.

## Acceptance criteria

- [ ] `Idml::Render.render(package:, to:, font_search_paths:)`
      produces a PDF at the given path.
- [ ] For each Spread in the package, creates a PDF Page.
- [ ] Each Page rendered via SpreadRenderer (TODO 10).
- [ ] Fonts resolved via FontResolver (TODO 02) and embedded
      (TODO 11).
- [ ] Colors resolved from Graphic.xml.
- [ ] Images resolved from href links (TODO 09).
- [ ] `Idml::CLI` gains a `render` subcommand:
      `idml render path.idml -o output.pdf`.
- [ ] Spec: render the sample-with-image fixture, verify the
      output PDF has the expected number of pages and is valid.

## Files

- `lib/idml/render.rb` — top-level entry + autoloads.
- `lib/idml/render/pipeline.rb`
- `lib/idml/cli.rb` — add `render` subcommand.
- `spec/idml/render/pipeline_spec.rb`

## Design notes

- The pipeline is the "director" — it doesn't do rendering itself;
  it orchestrates FontResolver, SpreadRenderer, and pdfrb.
- Output quality will NOT match InDesign's export. This is an
  approximation: basic shapes, left/justified text, no OpenType
  features, no advanced paragraph composition. Documented gap.

## Dependencies

- TODOs 01–11 (everything above).
- pdfrb gem (Canvas/content stream support).
