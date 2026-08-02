# TODO PDF 08: PDF text operators

## Goal

Map positioned glyphs from the text engine to PDF text-showing
operators in a content stream.

## Acceptance criteria

- [ ] `Idml::Render::Text` takes an Array of positioned glyphs and
      produces PDF text operators.
- [ ] `BT` (begin text), `ET` (end text).
- [ ] `Tf` (set font: `/FontName size Tf`).
- [ ] `Td` or `Tm` (set text position).
- [ ] `Tj` (show text string).
- [ ] `TJ` (show text array with per-glyph kerning adjustments).
- [ ] Color operators from TODO 06 inside the BT/ET block.
- [ ] Spec: render "Hello World" at (72, 720) in 12pt → verify
      the operator sequence.

## Files

- `lib/idml/render/text.rb`
- `spec/idml/render/text_spec.rb`

## Dependencies

- TODOs 01–05 (text engine).
- TODO 06 (Color).
