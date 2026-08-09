# TODO PDF 110: Conditional text (AppliedConditions)

## Status: OPEN — gap identified in 2026-08-09 audit

## Problem

PSR and CSR both carry an `AppliedConditions` attribute (a list of
condition Self IDs). In InDesign, conditions let authors mark text
as conditional (e.g., "show only in instructor edition", "draft
review comments"). Each `<Condition>` in Resources/Styles.xml
declares whether it's visible, its highlight color, etc.

Today the renderer ignores `AppliedConditions` — all conditional
text renders regardless of condition visibility. For documents that
use conditions heavily (textbooks, legal, regulatory), this means
the PDF always shows every variant instead of the chosen subset.

## What needs to happen

1. Verify `Elements::Condition` exists in the model (Resources/Styles.rnc).
2. Add `Render::ConditionFilter` that reads visible conditions from
   Resources/Styles.xml.
3. StyleResolver filters PSRs/CSRs whose AppliedConditions reference
   a hidden condition.
4. Spec: PSR with condition A (hidden) doesn't render; condition B
   (visible) renders.

## Acceptance criteria

- [ ] Condition model from RNC.
- [ ] ConditionFilter.from_styles(graphic_or_styles).
- [ ] StyleResolver.extract_paragraphs takes optional ConditionFilter.
- [ ] Hidden-condition runs filtered out.

## Dependencies

- None — pure feature work on existing models.
