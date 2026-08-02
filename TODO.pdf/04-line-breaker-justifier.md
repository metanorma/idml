# TODO PDF 04: Line breaker + justifier

## Goal

Break shaped text into lines that fit within a frame width, then
justify each line per its paragraph alignment.

## Acceptance criteria

- [ ] `Idml::TextEngine::LineBreaker.break(glyphs:, frame_width:)`
      returns an Array of `Line` objects, each holding a sub-range
      of glyphs and the line's natural width.
- [ ] Greedy algorithm: accumulate words until exceeding frame
      width, then break. Word boundary = space glyph.
- [ ] Hyphenation: optional, via `hyphenate: true` kwarg. Uses
      simple suffix rules in the first version (TeX patterns
      deferred).
- [ ] `Idml::TextEngine::Justifier.justify(line:, frame_width:,`
      `alignment:)` adjusts glyph x-positions per alignment:
      - `:left` — no adjustment.
      - `:center` — center the line in the frame.
      - `:right` — right-align.
      - `:justified` — distribute extra space between words.
- [ ] Justified mode distributes space per the paragraph's
      MinimumWordSpacing / DesiredWordSpacing / MaximumWordSpacing
      (already typed on ParagraphStyleRange).
- [ ] Spec: break a 100-word paragraph at 300pt width, verify no
      line exceeds 300pt. Verify center/right/justified produce
      correct x-offsets.

## Files

- `lib/idml/text_engine/line_breaker.rb`
- `lib/idml/text_engine/justifier.rb`
- `lib/idml/text_engine/line.rb`
- `spec/idml/text_engine/line_breaker_spec.rb`
- `spec/idml/text_engine/justifier_spec.rb`

## Design notes

- Greedy breaking is not as good as Knuth-Plass (InDesign's
  Paragraph Composer), but it handles 90% of cases correctly.
  Bad breaks (orphan/widow lines, rivers) are visible but the text
  is readable.
- The Justifier distributes "slack" (frame_width - line_width)
  across word spaces for justified text. Each space grows by
  slack / number_of_spaces, clamped to min/max word spacing.

## Dependencies

- TODO 03 (Shaper).
