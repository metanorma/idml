# TODO PDF 149: Architecture review round two — policy modules + test seam

## Status: COMPLETE — implemented 2026-08-29

## Problem

Follow-up architecture review (hot-spot: the renderer) after
TODO 148's wing split:

1. The keep-options family (paragraph deferral: KeepAllLines /
   KeepFirstLines / KeepLastLines windows, KeepWithNext,
   StartParagraph breaks) was ten private predicates buried in
   the engine — only testable through full end-to-end renders.
2. Frame-positioning policy (FirstBaselineOffset modes, vertical
   justification, content-height estimation) was interleaved with
   run emission, and `first_paragraph_leading(state)` /
   `first_paragraph_leading_for(paragraph)` were near-duplicate
   leading helpers maintained apart.
3. The render specs' real interface — the PDF content stream —
   was parsed by copy-pasted regexes (99 scan() sites, five
   private helper reimplementations); two spec bugs this week
   came from exactly this duplication.

## Solution

- **`Renderers::KeepPolicy`** (~118 lines, module_function): the
  deferral predicates extracted as a standalone pure module. The
  engine calls one entry point,
  `KeepPolicy.paragraph_deferred?(...)`. New direct unit spec
  (`keep_policy_spec.rb`, 14 examples) drives the window
  arithmetic with real `StyleResolver::Paragraph` structs — no
  canvas, writer, or fonts.
- **`Renderers::FrameMetrics`** (~160 lines, module_function):
  baseline modes, vertical-justify offsets, and content-height
  estimation in one home. The duplicate leading helpers are
  consolidated onto `FrameMetrics.leading_for(paragraph)`, which
  KeepPolicy also reuses.
- **`PdfStream`** (spec_helper): one named parser for the content
  stream (`text_positions`, `text_ys`, `bt_count`, `stroke_count`,
  `rect_count`); the five private spec helpers and all inline
  scan() idioms replaced.

TextFrameRenderer: 1235 → 960 lines (flow + emission only). Suite
3222 → 3256 examples. Zero behavior change.

## Files

- `lib/idml/render/renderers/keep_policy.rb` (new)
- `lib/idml/render/renderers/frame_metrics.rb` (new)
- `lib/idml/render/renderers/text_frame_renderer.rb`
- `lib/idml/render.rb`
- `spec/spec_helper.rb` + 10 render specs
- `spec/idml/render/renderers/keep_policy_spec.rb` (new)
