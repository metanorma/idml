# TODO PDF 116: AppliedParagraphStyle / AppliedCharacterStyle resolution from Resources/Styles.xml

## Status: DONE — `Render::StyleLookup` indexes ParagraphStyle and
CharacterStyle from Resources/Styles.xml by Self. StyleResolver
uses it to fill in formatting attributes that PSR/CSR elements don't
declare inline. PSR/CSR inline attributes override style values.

## Problem

In real IDML documents, the `<ParagraphStyleRange>` element often
carries ONLY an `AppliedParagraphStyle` reference and NO inline
formatting attributes. The actual formatting (Justification,
SpaceBefore, PointSize, etc.) lives in the referenced
`<ParagraphStyle>` definition in `Resources/Styles.xml`.

Example from the sample-with-table-more fixture:
```xml
<ParagraphStyleRange AppliedParagraphStyle="ParagraphStyle/$ID/NormalParagraphStyle">
  <CharacterStyleRange AppliedCharacterStyle="CharacterStyle/$ID/[No character style]">
    ...
  </CharacterStyleRange>
</ParagraphStyleRange>
```

The PSR has NO inline Justification, SpaceBefore, etc. Those values
are on `ParagraphStyle Self="ParagraphStyle/$ID/NormalParagraphStyle"`
in Styles.xml.

Today StyleResolver reads attributes directly from the PSR element.
When the PSR has only a style reference (common in real documents),
the renderer uses default values for everything.

## Impact

For the `sample-with-table-more` fixture, every PSR uses
`NormalParagraphStyle` — which in InDesign maps to 12pt Regular with
left alignment. The renderer happens to produce approximately right
output because the defaults match. But for documents that use custom
paragraph styles (Heading 1 = 24pt Bold Centered, Body Text = 11pt
Justified with 6pt SpaceAfter), the output would be wrong.

## What needs to happen

1. `Render::StyleResolver` resolves `AppliedParagraphStyle` to a
   `ParagraphStyle` from `Parts::Style` (Resources/Styles.xml).
2. PSR inline attributes override the style's attributes (when both
   are present — this is the IDML "local override" mechanism).
3. Same for `AppliedCharacterStyle` → `CharacterStyle` resolution.
4. The merged attributes become the Paragraph/StyledRun's values.

Architecture: `Parts::Style` already parses `<ParagraphStyle>` and
`<CharacterStyle>` entries. StyleResolver needs access to the style
part (via `context.package.styles` or similar).

## Acceptance criteria

- [ ] PSR with only AppliedParagraphStyle resolves formatting from
      the referenced ParagraphStyle.
- [ ] PSR inline attributes override style attributes.
- [ ] CharacterStyle resolution for CSR's AppliedCharacterStyle.
- [ ] Spec: fixture with custom paragraph style renders correctly.

## Dependencies

- None — pure feature work on existing models.
