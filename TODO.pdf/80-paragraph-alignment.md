# TODO PDF 80: Paragraph alignment via Justifier

## Status: DONE

## What was implemented

`TextFrameRenderer#engine_render` now applies paragraph alignment
from each `StyledRun` via the existing `TextEngine::Justifier`.

1. `StyleResolver::StyledRun` gains an `alignment` field, populated
   from `CharacterStyleRange#justification` via
   `StyleResolver::ALIGNMENT_MAP` (IDML enum → Justifier symbol).
2. `TextFrameRenderer#render_run_lines` calls
   `Justifier.justify(line:, frame_width:, alignment:)` per line
   after `LineBreaker.break`, then emits `canvas.text` per line at
   `box[:x] + line.x_offset`.
3. IDML Justification values map cleanly:
   - `Left`, `LeftJustified`, `ToBinding` → `:left`
   - `Center`, `CenterJustified` → `:center`
   - `Right`, `RightJustified` → `:right`
   - `FullyJustified` → `:justified` (Justifier distributes slack
     across spaces)

## Verification

- `lib/idml/render/style_resolver.rb:20` — `ALIGNMENT_MAP`.
- `lib/idml/render/style_resolver.rb:48` — `alignment_for(csr)`.
- `lib/idml/render/renderers/text_frame_renderer.rb:73` —
  `Justifier.justify` call + per-line text emission.
- `spec/idml/render/render_helpers_spec.rb` — alignment field on
  StyledRun + ALIGNMENT_MAP specs.

## Acceptance criteria

- [x] StyledRun carries alignment.
- [x] Center-aligned paragraphs render centered in their frame.
- [x] Right-aligned paragraphs render flush-right.
- [x] Left alignment (default) renders unchanged.
- [x] Fully-justified distributes slack across spaces via Justifier.
