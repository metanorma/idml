# TODO PDF 80: Paragraph alignment via Justifier

## Status: PLANNED (code exists, not wired)

## Goal

Apply IDML paragraph alignment (`Left`, `Center`, `Right`,
`FullyJustified`) to rendered text by integrating the existing
`TextEngine::Justifier` into `TextFrameRenderer#engine_render`.

## Background

The text engine has three modules:

- `Shaper` — converts text → shaped glyphs with widths. USED.
- `LineBreaker` — wraps glyphs into lines by frame width. USED.
- `Justifier` — adjusts `Line#x_offset` per alignment. NOT USED.

`Justifier.justify(line:, frame_width:, alignment:)` already
implements left/center/right offset calculation. It's spec'd but
not called by any renderer.

IDML's `CharacterStyleRange#justification` (and the paragraph-style
equivalent) carries the alignment enum. The values map cleanly:

| IDML              | Justifier symbol |
|-------------------|------------------|
| `Left`            | `:left`          |
| `Center`          | `:center`        |
| `Right`           | `:right`         |
| `LeftJustified`   | `:left` (simple) |
| `RightJustified`  | `:right`         |
| `CenterJustified` | `:center`        |
| `FullyJustified`  | `:left` (deferred — full justify needs word-space distribution) |
| `ToBinding`       | `:left`          |

## Plan

1. **Add `alignment` to `StyleResolver::StyledRun`** — populated
   from `CharacterStyleRange#justification` (or the applied
   paragraph style's justification).
2. **Map IDML enum → Justifier symbol** in a small helper (e.g.,
   `StyleResolver::ALIGNMENT_MAP`).
3. **In `TextFrameRenderer#render_run_lines`**, after
   `LineBreaker.break`, call `Justifier.justify(line:, frame_width:,
   alignment:)` for each line. Then offset the `text_lines` call's
   `at: [box[:x] + line.x_offset, ...]` per line.

   Because `canvas.text_lines` emits all lines with the same x,
   switch to per-line `canvas.text` calls when any line has a
   non-zero `x_offset`. Or use `text_rich` with per-run x offsets.

4. **Spec**: render a center-aligned paragraph, verify the BT/ET
   text position is offset from the left edge.

## Acceptance criteria

- [ ] StyledRun carries alignment.
- [ ] Center-aligned paragraphs render centered in their frame.
- [ ] Right-aligned paragraphs render flush-right.
- [ ] Left alignment (default) renders unchanged.
- [ ] Fully-justified falls back to left (deferred to TODO 81).

## Dependencies

- None new — Justifier already implemented and spec'd.
