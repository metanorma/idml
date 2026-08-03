# TODO PDF 55: Dead code deprecation markers

## Status: DONE (modules already removed)

## What was done

The old hand-rolled modules have already been deleted from the codebase
during the pdfrb migration (TODO 51 + TODO 62). No `Idml::Render::PdfWriter`,
`Idml::Render::FontEmbedder`, `Idml::Render::Color`, `Idml::Render::Path`,
or `Idml::Render::Text` references remain in `lib/` or `spec/`.

The original goal — deprecation comments on dead modules — is moot:
there are no dead modules to deprecate. This TODO is closed without
further work.

## Verification

`grep -rn "PdfWriter|FontEmbedder|Render::Color\b|Render::Path\b|Render::Text\b" lib/ spec/`
returns zero matches.

## Acceptance criteria

- [x] No live code references the old hand-rolled modules.
- [x] `bundle exec rake` is green (2314 examples, 0 failures).
