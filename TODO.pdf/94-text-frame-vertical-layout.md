# TODO PDF 94: TextFrameRenderer should delegate to VerticalLayout

## Status: DONE — VerticalLayout refactored to block-style API
(`layout_block` returns positioned lines + next cursor y);
TextFrameRenderer now uses StyleResolver.extract_paragraphs +
VerticalLayout.layout_block for proper vertical stacking across
paragraphs and runs.

## Problem

`TextEngine::VerticalLayout` exists (lib/idml/text_engine/vertical_layout.rb)
with full support for insets, leading, paragraph spacing, and indents.
`TextFrameRenderer#render_run_lines` reinvents that math inline and
ignores every paragraph-level attribute:

- No TextFramePreference insets (InsetTop / InsetLeft / InsetBottom /
  InsetRight) subtracted from the layout box.
- No SpaceBefore / SpaceAfter applied between paragraphs.
- No FirstLineIndent / LeftIndent / RightIndent applied within paragraphs.
- No AutoLeading honored — always uses `size * 1.2`.
- No DropCapLines / DropCapCharacters.

The current `engine_render` walks CSR runs as a flat list, so it
can't even see paragraph boundaries (PSR is the paragraph boundary;
CSR is a run within a paragraph).

## What needs to happen

1. **Group runs by paragraph** in `StyleResolver.extract_runs` —
   return a list of `Paragraph` structs, each carrying:
   - `runs:` — array of `StyledRun`
   - `space_before:`, `space_after:` — from PSR
   - `first_line_indent:`, `left_indent:`, `right_indent:` — from PSR
   - `auto_leading:` — from PSR
   - `alignment:` — already wired today
2. **Replace `render_run_lines`** with a call to
   `VerticalLayout.layout(lines:, frame:, font_size:, leading:,
   space_before:, space_after:, first_line_indent:, left_indent:)`.
3. **Subtract insets** from the frame box in `frame_box` —
   read TextFramePreference InsetTop / InsetLeft / InsetBottom /
   InsetRight and pass them to VerticalLayout::Frame.
4. **Emit positioned glyphs** from VerticalLayout via
   `canvas.text` per line (already the case today, but with
   VerticalLayout-computed positions).

## Architecture rationale

- **DRY**: removes duplicate line-positioning logic.
- **MECE**: VerticalLayout owns vertical placement; TextFrameRenderer
  owns run extraction + canvas emission.
- **OCP**: new paragraph attributes (drop caps, gyoudori) extend
  VerticalLayout, not TextFrameRenderer.

## Acceptance criteria

- [ ] `StyleResolver.extract_runs` returns paragraphs (not flat runs)
      when called with paragraph-aware mode.
- [ ] TextFramePreference insets shrink the layout box.
- [ ] PSR SpaceBefore adds space before the paragraph's first line.
- [ ] PSR FirstLineIndent shifts the first line right.
- [ ] PSR AutoLeading overrides the 1.2 factor.
- [ ] All existing specs still pass.
- [ ] New specs for each paragraph attribute.

## Dependencies

- None — pure refactor on top of existing typed models.
