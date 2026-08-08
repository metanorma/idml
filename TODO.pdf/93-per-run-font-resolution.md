# TODO PDF 93: Per-run font resolution from CharacterStyleRange

## Status: DONE — font_map architecture implemented

## Problem

All text in the rendered PDF uses the same font (the document's
default Regular weight). Real IDML documents specify per-run fonts
via `CharacterStyleRange#AppliedCharacterStyle` → `CharacterStyle`
→ `Properties/AppliedFont` (family name) + style attributes.

For the `sample-with-table-more` fixture, all text happens to use
`[No character style]` with `NormalParagraphStyle`, so the default
Regular weight is correct. But other IDML documents have bold,
italic, and mixed-family text that our renderer can't express.

## What needs to happen

1. **StyleResolver enhancement**: extract `applied_font` from each
   CSR via its `AppliedCharacterStyle` reference. The chain is:
   - CSR `AppliedCharacterStyle="CharacterStyle/$ID/bold_text"`
   - → CharacterStyle `Self="CharacterStyle/$ID/bold_text"`
   - → CharacterStyle `Properties/AppliedFont` → family name
   - → CharacterStyle `FontStyle` → style (Bold, Italic, etc.)
   - → Fonts.xml lookup → PostScriptName
   - → Pdfrb::FontResolver → file path → pdfrb font resource

2. **Multi-font registration**: FontSetup registers each distinct
   font used by any CSR, not just the document default. Returns a
   map of `applied_font_ref → pdfrb_symbol`.

3. **StyledRun enhancement**: carries the resolved pdfrb font
   resource Symbol (not just the PS name string).

4. **TextFrameRenderer**: uses `run.font_resource` for each
   `canvas.text` / `canvas.text_rich` call instead of the single
   `context.font_ps_name`.

5. **TableRenderer**: same — per-cell font resolution from the
   cell's CSR.

## Scope

- For documents with uniform styling (like the test fixture), no
  visible change — the default Regular font is already correct.
- For documents with bold/italic/mixed-family runs, text would
  render in the correct font per run.
- Font subsetting becomes per-font: each registered font gets its
  own used-codepoint set and subset.

## Dependencies

- pdfrb 0.6.0 with IO-based font loading (DONE, v0.5.3).
- CharacterStyle element model (exists — verify AppliedFont
  extraction from Properties).
- FontReferenceResolver (exists — already builds family → PSName
  lookup from Fonts.xml).

## Acceptance criteria

- [ ] StyledRun carries a resolved pdfrb font resource Symbol.
- [ ] CSR with `AppliedCharacterStyle` referencing a bold style
      renders in bold font.
- [ ] CSR with no applied style renders in the document default.
- [ ] Multiple fonts embedded when document uses multiple families.
- [ ] Font subsetting works per-font (each font subsetted to its
      own used codepoints).
