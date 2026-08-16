# TODO PDF 111: Footnote support

## Status: COMPLETE — implemented 2026-08-16

## What was built

- `Elements::Footnote` — schema-faithful model of `Footnote_Object`
  (Story.rnc): no attributes, PSR/CSR children carrying the footnote
  text. Wired into `CharacterStyleRange` and `StoryInner` (`footnote`
  collection). Footnote text is excluded from `text_content` so it
  never leaks into body text.
- `Render::Footnote` — footnote semantics unit (MECE):
  - `Counter`: story-scoped sequential numbering, honoring
    FootnoteOption `StartAt`.
  - `marker_run`: superscript marker emitted into the body text at the
    anchoring CSR's position; inherits the CSR's character styling.
  - `extract`: footnote paragraphs via StyleResolver with the marker
    text (`Prefix + number + Suffix`) prefixed to the first run.
  - `layout_entries` / `reserved_height`: one shared Shaper →
    LineBreaker → VerticalLayout walk drives both height measurement
    and rendering, so the reserved area always matches what's drawn.
  - `emit_separator`: separator rule honoring FootnoteOption RuleOn /
    RuleLineWeight / RuleWidth / RuleLeftIndent.
- `TextFrameRenderer`: marker runs are collected during body layout
  (`register_footnote`), each raising the effective bottom limit so
  body text avoids the footnote area (incremental reservation,
  InDesign-style); after body layout, `render_footnote_entries` draws
  the separator and the footnote paragraphs above the frame's content
  bottom. Per-column in multi-column frames.
- `FootnoteOption` (Preferences.xml) honored: StartAt, Prefix, Suffix,
  RuleOn, RuleLineWeight, RuleWidth, RuleLeftIndent, Spacer
  (separator gap), SpaceBetween (inter-entry gap).

## Known limitations

- Numbering restarts per story; document-wide continuous numbering
  and per-section restart are not modeled.
- Footnote overflow balancing (a footnote too tall for its frame
  moving wholly to the next frame, NoSplitting) is not modeled.
- The simple-render fallback (no font metrics) shows markers inline
  but does not render footnote text at the frame bottom.
- Footnotes nested in CSRs inside CSRs (CSR > CSR > Footnote) are
  not extracted; only direct CSR children emit markers.

## Acceptance criteria

- [x] Footnote text rendered at bottom of containing frame.
- [x] Footnote marker in body text (superscript, numbered).
- [x] Numbering honors FootnoteOption StartAt / Prefix / Suffix
      (per-story scope).
