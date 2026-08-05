# TODO PDF 90: Per-run font resolution

## Status: PLANNED (TODO 89 audit follow-up)

## Problem

`Idml::Render::FontSetup#register` picks the first non-missing font
in the document's `font_family` collection. For the
`sample-with-table-more` fixture that's `MinionPro-BoldCn` — but
InDesign's reference PDF embeds `MinionPro-Regular` because each
text run's `CharacterStyleRange#AppliedFont` specifies a per-run font.

The current `Idml::Render::StyleResolver::StyledRun` carries font
metadata but not the resolved per-run font. All text renders with
the first-available font, which may not match what the CSR's
`AppliedFont` references.

## Plan

1. **Extract per-run font** — `StyleResolver` adds
   `applied_font: <PSName>` to `StyledRun`, populated from
   `csr.applied_font` (a `CharacterStyle` reference, not a font
   directly).

2. **Resolve to font resource** — `FontSetup` exposes a
   `font_for_ps_name(ps_name)` that returns a registered font
   resource (Symbol) or nil. Pre-registers all non-missing fonts
   in the document upfront so the lookup is constant-time.

3. **Pass per-run font through the renderer** — the render path
   resolves `run.applied_font` → font resource once, registers if
   needed, and uses that for the canvas.text / text_rich /
   text_lines calls.

4. **Track font-by-font used codepoints** — each font tracks its
   own set of used codepoints so `subset_fonts!` can produce
   per-font subsets.

## Verification

After implementation:
- `Idml::Render::FontSetup#register_resolved(ps_name)` returns a
  Symbol for each `ps_name` it knows about.
- `StyleResolver::StyledRun#applied_font` returns the PSName string
  when set.
- TextFrameRenderer resolves `run.applied_font` once per run and
  uses the returned Symbol for all canvas text ops.
- subset_fonts! produces a smaller output for sample-with-table-more.

## Acceptance criteria

- [ ] The idml render's embedded font for sample-with-table-more is
      `MinionPro-Regular`, not `MinionPro-BoldCn`.
- [ ] Font stream size shrinks from 232KB to <50KB after subsetting.
- [ ] Spec asserts the correct font is selected per run.
