## Appendix C. IDML Defaults

InDesign's IDML defaults are stored in the file Predef.iddx, which is stored inside the Default folder inside the Presets folder in the InDesign application folder. When opening and converting an IDML document, InDesign will use this file to provide default values for any elements or attributes that are not present in the IDML document. These default values ensure consistency when converting IDML files to InDesign documents.

Do not make changes to the Predef.iddx file.

The following shows the contents of the Predef.iddx file.

## 1.1.1 <Document> Attributes

The <Document> element contains all of the other elements in the Predef.iddx file.

| AttributeName         | Value |
| --------------------- | ---------------------------------- |
| DOMVersion            | 7.0 |
| Self                  | d |
| StoryList             | u9b |
| ZeroPoint             | 0 0 |
| ActiveLayer           | ub6 |
| CMYKProfile           | U.S. Web Coated (SWOP) v2 |
| RGBProfile            | sRGB IEC61966­2.1 |
| SolidColorIntent      | UseColorSettings |
| AfterBlendingIntent   | UseColorSettings |
| DefaultImageIntent    | UseColorSettings |
| RGBPolicy             | PreserveEmbeddedProfiles |
| CMYKPolicy            | CombinationOfPreserveAndSafeCmyk |
| AccurateLABSpots      | false |

## 1.1.2 Languages

The default languages are the following ('%3a' in the following listing represents a colon):

[No Language], English%3a USA, English%3a USA Medical, English%3a USA Legal, French, Spanish%3a Castilian, Italian, English%3a UK, Swedish, Danish, Norwegian%3a Bokmal, Portuguese, Portuguese%3a Brazilian, French%3a Canadian, Norwegian%3a Nynorsk, Finnish, Catalan, Russian, Bulgarian, Czech, Polish, Romanian, Greek, Turkish, Hungarian, English%3a Canadian, Slovak, Croatian, Estonian, Latvian, Lithuanian, Slovenian, German%3a Traditional, German%3a Reformed, de\_DE\_2006, Dutch, nl\_NL\_2005, German%3a Swiss, de\_CH\_2006, Ukrainian

## 1.1.3 Colors

The default colors are:

Black, Cyan, Magenta, Paper, Registration, Yellow, u7d, u7f

## 1.1.4 Inks

The default inks are:

Process Cyan, Process Magenta, Process Yellow, and Process Black.

## 1.1.5 Swatches

The only default swatch is None .

## 1.1.6 Gradients

The only default gradient is named "u7e" , which includes the default colors "u7f" and Black .

## 1.1.7 Stroke Styles

The default stroke styles are:

Triple\_Stroke, ThickThinThick, ThinThickThin, ThickThick, ThickThin, ThinThick, ThinThin, Japanese Dots, White Diamond, Left Slant Hash, Right Slant Hash, Straight Hash, Wavy, Canned Dotted, Canned Dashed 3x2, , Dashed, and Solid

## 1.1.8 Font Families

Each font family contains a set of fonts. In the following listing, the indented listings are the names of the fonts within a given font family.

```
Myriad Pro Myriad Pro Condensed Myriad Pro Condensed Italic Myriad Pro Bold Condensed Myriad Pro Bold Condensed Italic Myriad Pro Regular Myriad Pro Italic Myriad Pro Semibold Myriad Pro Semibold Italic Myriad Pro Bold Myriad Pro Bold Italic Minion Pro Minion Pro Bold Cond Minion Pro Bold Cond Italic Minion Pro Regular Minion Pro Italic Minion Pro Medium Minion Pro Medium Italic Minion Pro Semibold Minion Pro Semibold Italic Minion Pro Bold Minion Pro Bold Italic Kozuka Mincho Pro Kozuka Mincho Pro EL Kozuka Mincho Pro L Kozuka Mincho Pro R
```

Kozuka Mincho Pro M

Kozuka Mincho Pro B

Kozuka Mincho Pro H

## 1.1.9 Composite Font

The defaults file defines a composite font, made up of <CompositeFontEntry> elements. The composite font uses the fonts Kozuka Mincho Pro R, Symbols, and Minion Pro Regular.

## 1.1.10 Character Styles

The defaults file contains a <RootCharacterStyle> element, which, in turn, contains a <CharacterStyle> element named [No CharacterStyle] .

## [No CharacterStyle]

Table 1. CharacterStyle Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | -------------------------- |
| Imported          | false |
| Name              | $ID/[No CharacterStyle] |

## 1.1.11 Paragraph Styles

The defaults file contains a <RootParagraphStyle> element, which, in turn, contains the following <ParagraphStyle> elements: [No paragraph style] , Normal Paragraph Style .

## [No paragraph style]

Table 2. Paragraph Style Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------------- |
| Imported          | false |
| FillColor         | Color/Black |
| FontStyle         | Regular |
| PointSize         | 12 |
| HorizontalScale   | 100 |
| KerningMethod     | $ID/Metrics |
| Ligatures         | true |
| PageNumberType    | AutoPageNumber |
| StrokeWeight      | 1 |
| Tracking          | 0 |
| Composer          | HL Composer |

| AttributeName               | Value |
| --------------------------- | ------------------ |
| DropCapCharacters           | 0 |
| DropCapLines                | 0 |
| BaselineShift               | 0 |
| Capitalization              | Normal |
| StrokeColor                 | Swatch/None |
| HyphenateLadderLimit        | 3 |
| VerticalScale               | 100 |
| LeftIndent                  | 0 |
| RightIndent                 | 0 |
| FirstLineIndent             | 0 |
| AutoLeading                 | 120 |
| AppliedLanguage             | $ID/English: USA |
| Hyphenation                 | true |
| HyphenateAfterFirst         | 2 |
| HyphenateBeforeLast         | 2 |
| HyphenateCapitalizedWords   | true |
| HyphenateWordsLongerThan    | 5 |
| NoBreak                     | false |
| HyphenationZone             | 36 |
| SpaceBefore                 | 0 |
| SpaceAfter                  | 0 |
| Underline                   | false |
| OTFFigureStyle              | Default |
| DesiredWordSpacing          | 100 |
| MaximumWordSpacing          | 133 |
| MinimumWordSpacing          | 80 |
| DesiredLetterSpacing        | 0 |
| MaximumLetterSpacing        | 0 |
| MinimumLetterSpacing        | 0 |
| DesiredGlyphScaling         | 100 |
| MaximumGlyphScaling         | 100 |
| MinimumGlyphScaling         | 100 |
| StartParagraph              | Anywhere |
| KeepAllLinesTogether        | false |
| KeepWithNext                | 0 |
| KeepFirstLines              | 2 |
| KeepLastLines               | 2 |
| Position                    | Normal |
| StrikeThru                  | false |

| AttributeName              | Value |
| -------------------------- | ---------------- |
| CharacterAlignment         | AlignEmCenter |
| KeepLinesTogether          | false |
| StrokeTint                 | ­1 |
| FillTint                   | ­1 |
| OverprintStroke            | false |
| OverprintFill              | false |
| GradientStrokeAngle        | 0 |
| GradientFillAngle          | 0 |
| GradientStrokeLength       | ­1 |
| GradientFillLength         | ­1 |
| GradientStrokeStart        | 0 0 |
| GradientFillStart          | 0 0 |
| Skew                       | 0 |
| RuleAboveLineWeight        | 1 |
| RuleAboveTint              | ­1 |
| RuleAboveOffset            | 0 |
| RuleAboveLeftIndent        | 0 |
| RuleAboveRightIndent       | 0 |
| RuleAboveWidth             | ColumnWidth |
| RuleBelowLineWeight        | 1 |
| RuleBelowTint              | ­1 |
| RuleBelowOffset            | 0 |
| RuleBelowLeftIndent        | 0 |
| RuleBelowRightIndent       | 0 |
| RuleBelowWidth             | ColumnWidth |
| RuleAboveOverprint         | false |
| RuleBelowOverprint         | false |
| RuleAbove                  | false |
| RuleBelow                  | false |
| LastLineIndent             | 0 |
| HyphenateLastWord          | true |
| ParagraphBreakType         | Anywhere |
| SingleWordJustification    | FullyJustified |
| OTFOrdinal                 | false |
| OTFFraction                | false |
| OTFDiscretionaryLigature   | false |
| OTFTitling                 | false |
| RuleAboveGapTint           | ­1 |
| RuleAboveGapOverprint      | false |

| AttributeName               | Value |
| --------------------------- | -------------------- |
| RuleBelowGapTint            | ­1 |
| RuleBelowGapOverprint       | false |
| Justification               | LeftAlign |
| DropcapDetail               | 0 |
| PositionalForm              | None |
| OTFMark                     | true |
| HyphenWeight                | 5 |
| OTFLocale                   | true |
| HyphenateAcrossColumns      | true |
| KeepRuleAboveInFrame        | false |
| IgnoreEdgeAlignment         | false |
| OTFSlashedZero              | false |
| OTFStylisticSets            | 0 |
| OTFHistorical               | false |
| OTFContextualAlternate      | true |
| UnderlineGapOverprint       | false |
| UnderlineGapTint            | ­1 |
| UnderlineOffset             | ­9999 |
| UnderlineOverprint          | false |
| UnderlineTint               | ­1 |
| UnderlineWeight             | ­9999 |
| StrikeThroughGapOverprint   | false |
| StrikeThroughGapTint        | ­1 |
| StrikeThroughOffset         | ­9999 |
| StrikeThroughOverprint      | false |
| StrikeThroughTint           | ­1 |
| StrikeThroughWeight         | ­9999 |
| MiterLimit                  | 4 |
| StrokeAlignment             | OutsideAlignment |
| EndJoin                     | MiterEndJoin |
| OTFSwash                    | false |
| Tsume                       | 0 |
| LeadingAki                  | ­1 |
| TrailingAki                 | ­1 |
| KinsokuType                 | KinsokuPushInFirst |
| KinsokuHangType             | None |
| BunriKinshi                 | true |
| RubyOpenTypePro             | true |
| RubyFontSize                | ­1 |

| AttributeName              | Value |
| -------------------------- | --------------------- |
| RubyAlignment              | RubyJIS |
| RubyType                   | PerCharacterRuby |
| RubyParentSpacing          | RubyParent121Aki |
| RubyXScale                 | 100 |
| RubyYScale                 | 100 |
| RubyXOffset                | 0 |
| RubyYOffset                | 0 |
| RubyPosition               | AboveRight |
| RubyAutoAlign              | true |
| RubyParentOverhangAmount   | RubyOverhangOneRuby |
| RubyOverhang               | false |
| RubyAutoScaling            | false |
| RubyParentScalingPercent   | 66 |
| RubyTint                   | ­1 |
| RubyOverprintFill          | Auto |
| RubyStrokeTint             | ­1 |
| RubyOverprintStroke        | Auto |
| RubyWeight                 | ­1 |
| KentenKind                 | None |
| KentenFontSize             | ­1 |
| KentenXScale               | 100 |
| KentenYScale               | 100 |
| KentenPlacement            | 0 |
| KentenAlignment            | AlignKentenCenter |
| KentenPosition             | AboveRight |
| KentenCustomCharacter      |  |
| KentenCharacterSet         | CharacterInput |
| KentenTint                 | ­1 |
| KentenOverprintFill        | Auto |
| KentenStrokeTint           | ­1 |
| KentenOverprintStroke      | Auto |
| KentenWeight               | ­1 |
| Tatechuyoko                | false |
| TatechuyokoXOffset         | 0 |
| TatechuyokoYOffset         | 0 |
| AutoTcy                    | 0 |
| AutoTcyIncludeRoman        | false |
| Jidori                     | 0 |
| GridGyoudori               | 0 |

| AttributeName                  | Value |
| ------------------------------ | ---------------------- |
| GridAlignFirstLineOnly         | false |
| GridAlignment                  | None |
| CharacterRotation              | 0 |
| RotateSingleByteCharacters     | false |
| Rensuuji                       | true |
| ShataiMagnification            | 0 |
| ShataiDegreeAngle              | 4500 |
| ShataiAdjustTsume              | true |
| ShataiAdjustRotation           | false |
| Warichu                        | false |
| WarichuLines                   | 2 |
| WarichuSize                    | 50 |
| WarichuLineSpacing             | 0 |
| WarichuAlignment               | Auto |
| WarichuCharsBeforeBreak        | 2 |
| WarichuCharsAfterBreak         | 2 |
| OTFHVKana                      | false |
| OTFProportionalMetrics         | false |
| OTFRomanItalics                | false |
| LeadingModel                   | LeadingModelAkiBelow |
| ScaleAffectsLineHeight         | false |
| ParagraphGyoudori              | false |
| CjkGridTracking                | false |
| GlyphForm                      | None |
| RubyAutoTcyDigits              | 0 |
| RubyAutoTcyIncludeRoman        | false |
| RubyAutoTcyAutoScale           | true |
| TreatIdeographicSpaceAsSpace   | false |
| AllowArbitraryHyphenation      | false |
| BulletsAndNumberingListType    | NoList |
| NumberingStartAt               | 1 |
| NumberingLevel                 | 1 |
| NumberingContinue              | true |
| NumberingApplyRestartPolicy    | true |
| BulletsAlignment               | LeftAlign |
| NumberingAlignment             | LeftAlign |
| NumberingExpression            | ^#.^t |
| BulletsTextAfter               | ^t |
| DigitsType                     | DefaultDigits |

| AttributeName               | Value |
| --------------------------- | ---------------------- |
| Kashidas                    | DefaultKashidas |
| DiacriticPosition           | OpentypePosition |
| CharacterDirection          | DefaultDirection |
| ParagraphDirection          | LeftToRightDirection |
| ParagraphJustification      | DefaultJustification |
| XOffsetDiacritic            | 0 |
| YOffsetDiacritic            | 0 |
| OTFOverlapSwash             | false |
| OTFStylisticAlternate       | false |
| OTFJustificationAlternate   | false |
| OTFStretchedAlternate       | false |
| KeyboardDirection           | DefaultDirection |
| SpanSplitColumnCount        | All |
| SpanColumnType              | SingleColumn |
| SplitColumnsInsideGutter    | 6 |
| SplitColumnsOutsideGutter   | 6 |
| KeepWithPrevious            | false |

Table 3. Paragraph Properties Represented as Elements

| ElementName             | Value |
| ----------------------- | ----------------------- |
| Leading                 | Auto |
| AppliedFont             | Minion Pro |
| RuleAboveColor          | Text Color |
| RuleBelowColor          | Text Color |
| RuleAboveType           | StrokeStyle/$ID/Solid |
| RuleBelowType           | StrokeStyle/$ID/Solid |
| BalanceRaggedLines      | NoBalancing |
| RuleAboveGapColor       | Swatch/None |
| RuleBelowGapColor       | Swatch/None |
| UnderlineColor          | Text Color |
| UnderlineGapColor       | Swatch/None |
| UnderlineType           | StrokeStyle/$ID/Solid |
| StrikeThroughColor      | Text Color |
| StrikeThroughGapColor   | Swatch/None |
| StrikeThroughType       | StrokeStyle/$ID/Solid |
| Mojikumi                | Nothing |
| KinsokuSet              | Nothing |
| RubyFont                | $ID/ |
| RubyFontStyle           | Nothing |

| ElementName                | Value |
| -------------------------- | ----------------------------------------------------------- |
| RubyFill                   | Text Color |
| RubyStroke                 | Text Color |
| KentenFont                 | $ID/ |
| KentenFontStyle            | Nothing |
| KentenFillColor            | Text Color |
| KentenStrokeColor          | Text Color |
| BulletChar                 | BulletCharacterType=UnicodeOnly BulletCharacterValue=8226 |
| NumberingFormat            | 1, 2, 3, 4... |
| BulletsFont                | $ID/ |
| BulletsFontStyle           | Nothing |
| AppliedNumberingList       | NumberingList/$ID/[Default] |
| NumberingRestartPolicies   | RestartPolicy=AnyPreviousLevel LowerLevel=0 UpperLevel=0 |
| BulletsCharacterStyle      | CharacterStyle/$ID/[No CharacterStyle] |
| NumberingCharacterStyle    | CharacterStyle/$ID/[No CharacterStyle] |

## NormalParagraphStyle

Table 4. Paragraph Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ----------------------------------------- |
| Imported           | false |
| NextStyle          | ParagraphStyle/$ID/NormalParagraphStyle |
| KeyboardShortcut   | 0 0 |

Table 5. Paragraph Properties Represented as Elements

| ElementName     | Value |
| --------------- | -------------------------- |
| BasedOn         | $ID/[No paragraph style] |
| PreviewColor    | Nothing |

## 1.1.12 TOC Styles

The defaults file contains a single TOC style.

Table 6. TOC Style Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ----------------------------------------- |
| TitleStyle        | ParagraphStyle/$ID/[No paragraph style] |
| Title             | Contents |

| AttributeName          | Value |
| ---------------------- | ------------------------- |
| Name                   | $ID/DefaultTOCStyleName |
| RunIn                  | false |
| IncludeHidden          | false |
| IncludeBookDocuments   | false |
| CreateBookmarks        | true |
| SetStoryDirection      | Horizontal |
| NumberedParagraphs     | IncludeFullParagraph |

## 1.1.13 Cell Styles

The defaults file contains a single cell style, [None] .

Table 7. Cell Style Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------------------------------------- |
| AppliedParagraphStyle   | ParagraphStyle/$ID/[No paragraph style] |
| Name                    | $ID/[None] |

## 1.1.14 Table Styles

The defaults file contains a two table styles, [No table style] and [Basic Table] .

## [No table style]

Table 8. Table Style Properties Represented as Attributes

| AttributeName                 | Value |
| ----------------------------- | ----------------------- |
| Name                          | $ID/[No table style] |
| StrokeOrder                   | BestJoins |
| TopBorderStrokeWeight         | 1 |
| TopBorderStrokeType           | StrokeStyle/$ID/Solid |
| TopBorderStrokeColor          | Color/Black |
| TopBorderStrokeTint           | 100 |
| TopBorderStrokeOverprint      | false |
| TopBorderStrokeGapColor       | Color/Paper |
| TopBorderStrokeGapTint        | 100 |
| TopBorderStrokeGapOverprint   | false |
| LeftBorderStrokeWeight        | 1 |
| LeftBorderStrokeType          | StrokeStyle/$ID/Solid |
| LeftBorderStrokeColor         | Color/Black |

| AttributeName                    | Value |
| -------------------------------- | ----------------------- |
| LeftBorderStrokeTint             | 100 |
| LeftBorderStrokeOverprint        | false |
| LeftBorderStrokeGapColor         | Color/Paper |
| LeftBorderStrokeGapTint          | 100 |
| LeftBorderStrokeGapOverprint     | false |
| BottomBorderStrokeWeight         | 1 |
| BottomBorderStrokeType           | StrokeStyle/$ID/Solid |
| BottomBorderStrokeColor          | Color/Black |
| BottomBorderStrokeTint           | 100 |
| BottomBorderStrokeOverprint      | false |
| BottomBorderStrokeGapColor       | Color/Paper |
| BottomBorderStrokeGapTint        | 100 |
| BottomBorderStrokeGapOverprint   | false |
| RightBorderStrokeWeight          | 1 |
| RightBorderStrokeType            | StrokeStyle/$ID/Solid |
| RightBorderStrokeColor           | Color/Black |
| RightBorderStrokeTint            | 100 |
| RightBorderStrokeOverprint       | false |
| RightBorderStrokeGapColor        | Color/Paper |
| RightBorderStrokeGapTint         | 100 |
| RightBorderStrokeGapOverprint    | false |
| SpaceBefore                      | 4 |
| SpaceAfter                       | ­4 |
| SkipFirstAlternatingStrokeRows   | 0 |
| SkipLastAlternatingStrokeRows    | 0 |
| StartRowStrokeCount              | 0 |
| StartRowStrokeColor              | Color/Black |
| StartRowStrokeWeight             | 1 |
| StartRowStrokeType               | StrokeStyle/$ID/Solid |
| StartRowStrokeTint               | 100 |
| StartRowStrokeGapOverprint       | false |
| StartRowStrokeGapColor           | Color/Paper |
| StartRowStrokeGapTint            | 100 |
| StartRowStrokeOverprint          | false |
| EndRowStrokeCount                | 0 |
| EndRowStrokeColor                | Color/Black |
| EndRowStrokeWeight               | 0.25 |
| EndRowStrokeType                 | StrokeStyle/$ID/Solid |
| EndRowStrokeTint                 | 100 |

| AttributeName                       | Value |
| ----------------------------------- | ----------------------- |
| EndRowStrokeOverprint               | false |
| EndRowStrokeGapColor                | Color/Paper |
| EndRowStrokeGapTint                 | 100 |
| EndRowStrokeGapOverprint            | false |
| SkipFirstAlternatingStrokeColumns   | 0 |
| SkipLastAlternatingStrokeColumns    | 0 |
| StartColumnStrokeCount              | 0 |
| StartColumnStrokeColor              | Color/Black |
| StartColumnStrokeWeight             | 1 |
| StartColumnStrokeType               | StrokeStyle/$ID/Solid |
| StartColumnStrokeTint               | 100 |
| StartColumnStrokeOverprint          | false |
| StartColumnStrokeGapColor           | Color/Paper |
| StartColumnStrokeGapTint            | 100 |
| StartColumnStrokeGapOverprint       | false |
| EndColumnStrokeCount                | 0 |
| EndColumnStrokeColor                | Color/Black |
| EndColumnStrokeWeight               | 0.25 |
| EndColumnLineStyle                  | StrokeStyle/$ID/Solid |
| EndColumnStrokeTint                 | 100 |
| EndColumnStrokeOverprint            | false |
| EndColumnStrokeGapColor             | Color/Paper |
| EndColumnStrokeGapTint              | 100 |
| EndColumnStrokeGapOverprint         | false |
| ColumnFillsPriority                 | false |
| SkipFirstAlternatingFillRows        | 0 |
| SkipLastAlternatingFillRows         | 0 |
| StartRowFillColor                   | Color/Black |
| StartRowFillCount                   | 0 |
| StartRowFillTint                    | 20 |
| StartRowFillOverprint               | false |
| EndRowFillCount                     | 0 |
| EndRowFillColor                     | Swatch/None |
| EndRowFillTint                      | 100 |
| EndRowFillOverprint                 | false |
| SkipFirstAlternatingFillColumns     | 0 |
| SkipLastAlternatingFillColumns      | 0 |
| StartColumnFillCount                | 0 |
| StartColumnFillColor                | Color/Black |

| AttributeName                       | Value |
| ----------------------------------- | ------------------------ |
| StartColumnFillTint                 | 20 |
| StartColumnFillOverprint            | false |
| EndColumnFillCount                  | 0 |
| EndColumnFillColor                  | Swatch/None |
| EndColumnFillTint                   | 100 |
| EndColumnFillOverprint              | false |
| HeaderRegionSameAsBodyRegion        | true |
| FooterRegionSameAsBodyRegion        | true |
| LeftColumnRegionSameAsBodyRegion    | true |
| RightColumnRegionSameAsBodyRegion   | true |
| HeaderRegionCellStyle               | n |
| FooterRegionCellStyle               | n |
| LeftColumnRegionCellStyle           | n |
| RightColumnRegionCellStyle          | n |
| BodyRegionCellStyle                 | CellStyle/$ID/[None]/> |

## [Basic Table]

Table 9. Table Style Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ------------------- |
| KeyboardShortcut   | 0 0 |
| Name               | $ID/[Basic Table] |

## Table 10. Table Style Properties Represented as Elements

| ElementName     | Value |
| --------------- | ---------------------- |
| BasedOn         | $ID/[No table style] |

## 1.1.15 Named Grids

The defaults file contains a single <NamedGrid> element, [Page Grid] . This element contains a <GridDataInformation> element, which, in turn, contains an <AppliedFont> element.

Table 11. Table Style Properties Represented as Elements

| AttributeName     | Value |
| ----------------- | ----------------- |
| Name              | $ID/[Page Grid] |

Table 12. Grid Data Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------------- |
| FontStyle            | Regular |
| PointSize            | 12 |
| CharacterAki         | 0 |
| LineAki              | 9 |
| HorizontalScale      | 100 |
| VerticalScale        | 100 |
| LineAlignment        | LeftOrTopLineJustify |
| GridAlignment        | AlignEmCenter |
| CharacterAlignment   | AlignEmCenter |

Table 13. Grid Data Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------ |
| AppliedFont     | Minion Pro |

## 1.1.16 Object Styles

The defaults file contains a series of <ObjectStyle> elements: [None] , [Normal Graphics Frame] , [Normal TextFrame] , and [Normal Grid] .

Each <ObjectStyle> element contains the following elements (some of these elements contain child elements; these child elements are indicated by an indent).

```
<TextFramePreference> <InsetSpacing> <BaselineFrameGridOption> <BaselineFrameGridColor> <AnchoredObjectSetting> <TextWrapPreference> <TextWrapOffset> <ContourOption> <StoryPreference>
```

<FrameFittingOption>

Some of the <ObjectStyle> elements also contain the following elements:

```
<ObjectStyleObjectEffectsCategorySettings> <ObjectStyleStrokeEffectsCategorySettings> <ObjectStyleFillEffectsCategorySettings> <ObjectStyleContentEffectsCategorySettings>
```

## [None]

Table 14. Object Style Properties Represented as Attributes

| AttributeName             | Value |
| ------------------------- | ----------------------------------------- |
| AppliedParagraphStyle     | ParagraphStyle/$ID/[No paragraph style] |
| FillColor                 | Swatch/None |
| FillTint                  | ­1 |
| StrokeWeight              | 0 |
| MiterLimit                | 4 |
| EndCap                    | ButtEndCap |
| EndJoin                   | MiterEndJoin |
| StrokeType                | StrokeStyle/$ID/Solid |
| LeftLineEnd               | None |
| RightLineEnd              | None |
| StrokeColor               | Swatch/None |
| StrokeTint                | ­1 |
| TopLeftCornerOption       | None |
| TopRightCornerOption      | None |
| BottomLeftCornerOption    | None |
| BottomRightCornerOption   | None |
| TopLeftCornerRadius       | 12 |
| TopRightCornerRadius      | 12 |
| BottomLeftCornerRadius    | 12 |
| BottomRightCornerRadius   | 12 |
| GapColor                  | Swatch/None |
| GapTint                   | ­1 |
| StrokeAlignment           | CenterAlignment |
| Nonprinting               | false |
| GradientFillAngle         | 0 |
| GradientStrokeAngle       | 0 |
| AppliedNamedGrid          | n |

Table 15. TextFrame Preferences Properties Represented as Attributes

| AttributeName          | Value |
| ---------------------- | -------------- |
| TextColumnCount        | 1 |
| TextColumnGutter       | 12 |
| TextColumnFixedWidth   | 144 |
| UseFixedColumnWidth    | false |
| FirstBaselineOffset    | AscentOffset |

| AttributeName                | Value |
| ---------------------------- | ---------- |
| MinimumFirstBaselineOffset   | 0 |
| VerticalJustification        | TopAlign |
| VerticalThreshold            | 0 |
| IgnoreWrap                   | false |
| VerticalBalanceColumns       | false |

## Table 16. TextFrame Preferences Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| InsetSpacing    | <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> |

## Table 17. BaselineFrameGrid Options Represented as Attributes

| AttributeName                        | Value |
| ------------------------------------ | ------------ |
| UseCustomBaselineFrameGrid           | false |
| StartingOffsetForBaselineFrameGrid   | 0 |
| BaselineFrameGridRelativeOption      | TopOfInset |
| BaselineFrameGridIncrement           | 12 |

## Table 18. BaselineFrameGrid Options Represented as Elements

| ElementName              | Value |
| ------------------------ | ----------- |
| BaselineFrameGridColor   | LightBlue |

## Table 19. Anchored Object Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | ------------------- |
| AnchoredPosition           | InlinePosition |
| SpineRelative              | false |
| LockPosition               | false |
| PinPosition                | true |
| AnchorPoint                | BottomRightAnchor |
| HorizontalAlignment        | LeftAlign |
| HorizontalReferencePoint   | TextFrame |
| VerticalAlignment          | BottomAlign |
| VerticalReferencePoint     | LineBaseline |
| AnchorXoffset              | 0 |
| AnchorYoffset              | 0 |
| AnchorSpaceAbove           | 0 |

## Table 20. TextWrapPreferences Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------- |
| Inverse                 | false |
| ApplyToMasterPageOnly   | false |
| TextWrapSide            | BothSides |
| TextWrapMode            | None |

## Table 21. TextWrapPreferences Properties Represented as Elements

| ElementName      | Value |
| ---------------- | ------------------------------- |
| TextWrapOffset   | Top=0 Left=0 Bottom=0 Right=0 |

## Table 22. Contour Option Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------- |
| ContourType          | SameAsClipping |
| IncludeInsideEdges   | false |
| ContourPathName      | $ID/ |

## Table 23. StoryPreferences Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ---------------------- |
| OpticalMarginAlignment   | false |
| OpticalMarginSize        | 12 |
| FrameType                | TextFrameType |
| StoryOrientation         | Horizontal |
| StoryDirection           | LeftToRightDirection |

Table 24. Frame Fitting Option Properties Represented as Attributes

| AttributeName         | Value |
| --------------------- | --------------- |
| LeftCrop              | 0 |
| TopCrop               | 0 |
| RightCrop             | 0 |
| BottomCrop            | 0 |
| FittingOnEmptyFrame   | None |
| FittingAlignment      | TopLeftAnchor |
| AutoFit               | false |

## [Normal Graphics Frame]

Table 25. Object Style Properties Represented as Attributes

| AttributeName                    | Value |
| -------------------------------- | ----------------------------------------- |
| Name                             | $ID/[Normal Graphics Frame] |
| AppliedParagraphStyle            | ParagraphStyle/$ID/[No paragraph style] |
| ApplyNextParagraphStyle          | false |
| EnableFill                       | true |
| EnableStroke                     | true |
| EnableParagraphStyle             | false |
| EnableTextFrameGeneralOptions    | false |
| EnableTextFrameBaselineOptions   | false |
| EnableStoryOptions               | false |
| EnableTextWrapAndOthers          | false |
| EnableAnchoredObjectOptions      | false |
| FillColor                        | Swatch/None |
| FillTint                         | ­1 |
| StrokeWeight                     | 1 |
| MiterLimit                       | 4 |
| EndCap                           | ButtEndCap |
| EndJoin                          | MiterEndJoin |
| StrokeType                       | StrokeStyle/$ID/Solid |
| LeftLineEnd                      | None |
| RightLineEnd                     | None |
| StrokeColor                      | Color/Black |
| StrokeTint                       | ­1 |
| TopLeftCornerOption              | None |
| TopRightCornerOption             | None |
| BottomLeftCornerOption           | None |
| BottomRightCornerOption          | None |
| TopLeftCornerRadius              | 12 |
| TopRightCornerRadius             | 12 |
| BottomLeftCornerRadius           | 12 |
| BottomRightCornerRadius          | 12 |
| OverprintStroke                  | false |
| GapColor                         | Swatch/None |
| GapTint                          | ­1 |
| StrokeAlignment                  | CenterAlignment |
| Nonprinting                      | false |
| GradientFillAngle                | 0 |

| AttributeName                  | Value |
| ------------------------------ | --------- |
| GradientStrokeAngle            | 0 |
| AppliedNamedGrid               | n |
| KeyboardShortcut               | 0 0 |
| EnableFrameFittingOptions      | false |
| EnableStrokeAndCornerOptions   | true |

## Table 26. Object Style Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------ |
| BasedOn         | $ID/[None] |

## Table 27. TextFrame Preferences Properties Represented as Attributes

| AttributeName                | Value |
| ---------------------------- | -------------- |
| TextColumnCount              | 1 |
| TextColumnGutter             | 12 |
| TextColumnFixedWidth         | 144 |
| UseFixedColumnWidth          | false |
| FirstBaselineOffset          | AscentOffset |
| MinimumFirstBaselineOffset   | 0 |
| VerticalJustification        | TopAlign |
| VerticalThreshold            | 0 |
| IgnoreWrap                   | false |

## Table 28. TextFrame Preferences Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| InsetSpacing    | <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> |

## Table 29. BaselineFrameGrid Options Represented as Attributes

| AttributeName                        | Value |
| ------------------------------------ | ------------ |
| UseCustomBaselineFrameGrid           | false |
| StartingOffsetForBaselineFrameGrid   | 0 |
| BaselineFrameGridRelativeOption      | TopOfInset |
| BaselineFrameGridIncrement           | 12 |

## Table 30. BaselineFrameGrid Options Represented as Elements

| ElementName              | Value |
| ------------------------ | ----------- |
| BaselineFrameGridColor   | LightBlue |

## Table 31. Anchored Object Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | ------------------- |
| AnchoredPosition           | InlinePosition |
| SpineRelative              | false |
| LockPosition               | false |
| PinPosition                | true |
| AnchorPoint                | BottomRightAnchor |
| HorizontalAlignment        | LeftAlign |
| HorizontalReferencePoint   | TextFrame |
| VerticalAlignment          | BottomAlign |
| VerticalReferencePoint     | LineBaseline |
| AnchorXoffset              | 0 |
| AnchorYoffset              | 0 |
| AnchorSpaceAbove           | 0 |

## Table 32. TextWrapPreferences Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------- |
| Inverse                 | false |
| ApplyToMasterPageOnly   | false |
| TextWrapSide            | BothSides |
| TextWrapMode            | None |

## Table 33. TextWrapPreferences Properties Represented as Elements

| ElementName      | Value |
| ---------------- | ------------------------------- |
| TextWrapOffset   | Top=0 Left=0 Bottom=0 Right=0 |

## Table 34. Contour Option Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------- |
| ContourType          | SameAsClipping |
| IncludeInsideEdges   | false |
| ContourPathName      | $ID/ |

Table 35. StoryPreferences Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ---------------------- |
| OpticalMarginAlignment   | false |
| OpticalMarginSize        | 12 |
| FrameType                | TextFrameType |
| StoryOrientation         | Horizontal |
| StoryDirection           | LeftToRightDirection |

## Table 36. Frame Fitting Option Properties Represented as Attributes

| AttributeName         | Value |
| --------------------- | --------------- |
| LeftCrop              | 0 |
| TopCrop               | 0 |
| RightCrop             | 0 |
| BottomCrop            | 0 |
| FittingOnEmptyFrame   | None |
| FittingAlignment      | TopLeftAnchor |
| AutoFit               | false |

Table 37. Object Style Object Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 38. Object Style Stroke Effects Category Settings Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | --------- |
| EnableTransparency   | true |
| EnableDropShadow     | true |
| EnableFeather        | true |
| EnableInnerShadow    | true |
| EnableOuterGlow      | true |

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 39. Object Style Fill Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 40. Object Style Content Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

## [Normal TextFrame]

Table 41. Object Style Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------------------- |
| Name              | $ID/[Normal TextFrame] |

| AttributeName                    | Value |
| -------------------------------- | ----------------------------------------- |
| AppliedParagraphStyle            | ParagraphStyle/$ID/NormalParagraphStyle |
| ApplyNextParagraphStyle          | false |
| EnableFill                       | true |
| EnableStroke                     | true |
| EnableParagraphStyle             | false |
| EnableTextFrameGeneralOptions    | true |
| EnableTextFrameBaselineOptions   | true |
| EnableStoryOptions               | false |
| EnableTextWrapAndOthers          | false |
| EnableAnchoredObjectOptions      | false |
| FillColor                        | Swatch/None |
| FillTint                         | ­1 |
| StrokeWeight                     | 0 |
| MiterLimit                       | 4 |
| EndCap                           | ButtEndCap |
| EndJoin                          | MiterEndJoin |
| StrokeType                       | StrokeStyle/$ID/Solid |
| LeftLineEnd                      | None |
| RightLineEnd                     | None |
| StrokeColor                      | Swatch/None |
| StrokeTint                       | ­1 |
| TopLeftCornerOption              | None |
| TopRightCornerOption             | None |
| BottomLeftCornerOption           | None |
| BottomRightCornerOption          | None |
| TopLeftCornerRadius              | 12 |
| TopRightCornerRadius             | 12 |
| BottomLeftCornerRadius           | 12 |
| BottomRightCornerRadius          | 12 |
| GapColor                         | Swatch/None |
| GapTint                          | ­1 |
| StrokeAlignment                  | CenterAlignment |
| Nonprinting                      | false |
| GradientFillAngle                | 0 |
| GradientStrokeAngle              | 0 |
| AppliedNamedGrid                 | n |
| KeyboardShortcut                 | 0 0 |
| EnableFrameFittingOptions        | false |
| EnableStrokeAndCornerOptions     | true |

## Table 42. Object Style Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------ |
| BasedOn         | $ID/[None] |

## Table 43. TextFrame Preferences Properties Represented as Attributes

| AttributeName                | Value |
| ---------------------------- | -------------- |
| TextColumnCount              | 1 |
| TextColumnGutter             | 12 |
| TextColumnFixedWidth         | 144 |
| UseFixedColumnWidth          | false |
| FirstBaselineOffset          | AscentOffset |
| MinimumFirstBaselineOffset   | 0 |
| VerticalJustification        | TopAlign |
| VerticalThreshold            | 0 |
| IgnoreWrap                   | false |

## Table 44. TextFrame Preferences Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| InsetSpacing    | <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> |

## Table 45. BaselineFrameGrid Options Represented as Attributes

| AttributeName                        | Value |
| ------------------------------------ | ------------ |
| UseCustomBaselineFrameGrid           | false |
| StartingOffsetForBaselineFrameGrid   | 0 |
| BaselineFrameGridRelativeOption      | TopOfInset |
| BaselineFrameGridIncrement           | 12 |

## Table 46. BaselineFrameGrid Options Represented as Elements

| ElementName              | Value |
| ------------------------ | ----------- |
| BaselineFrameGridColor   | LightBlue |

## Table 47. Anchored Object Settings Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ---------------- |
| AnchoredPosition   | InlinePosition |
| SpineRelative      | false |

| AttributeName              | Value |
| -------------------------- | ------------------- |
| LockPosition               | false |
| PinPosition                | true |
| AnchorPoint                | BottomRightAnchor |
| HorizontalAlignment        | LeftAlign |
| HorizontalReferencePoint   | TextFrame |
| VerticalAlignment          | BottomAlign |
| VerticalReferencePoint     | LineBaseline |
| AnchorXoffset              | 0 |
| AnchorYoffset              | 0 |
| AnchorSpaceAbove           | 0 |

## Table 48. TextWrapPreferences Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------- |
| Inverse                 | false |
| ApplyToMasterPageOnly   | false |
| TextWrapSide            | BothSides |
| TextWrapMode            | None |

## Table 49. TextWrapPreferences Properties Represented as Elements

| ElementName      | Value |
| ---------------- | ------------------------------- |
| TextWrapOffset   | Top=0 Left=0 Bottom=0 Right=0 |

## Table 50. Contour Option Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------- |
| ContourType          | SameAsClipping |
| IncludeInsideEdges   | false |
| ContourPathName      | $ID/ |

## Table 51. StoryPreferences Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ---------------------- |
| OpticalMarginAlignment   | false |
| OpticalMarginSize        | 12 |
| FrameType                | TextFrameType |
| StoryOrientation         | Horizontal |
| StoryDirection           | LeftToRightDirection |

Table 52. Frame Fitting Option Properties Represented as Attributes

| AttributeName         | Value |
| --------------------- | --------------- |
| LeftCrop              | 0 |
| TopCrop               | 0 |
| RightCrop             | 0 |
| BottomCrop            | 0 |
| FittingOnEmptyFrame   | None |
| FittingAlignment      | TopLeftAnchor |
| AutoFit               | false |

Table 53. Object Style Object Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 54. Object Style Stroke Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 55. Object Style Fill Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 56. Object Style Content Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

## [Normal Grid]

Table 57. Object Style Properties Represented as Attributes

| AttributeName                    | Value |
| -------------------------------- | ----------------------------------------- |
| Name                             | $ID/[Normal Grid] |
| AppliedParagraphStyle            | ParagraphStyle/$ID/NormalParagraphStyle |
| ApplyNextParagraphStyle          | false |
| EnableFill                       | true |
| EnableStroke                     | true |
| EnableParagraphStyle             | false |
| EnableTextFrameGeneralOptions    | true |
| EnableTextFrameBaselineOptions   | true |
| EnableStoryOptions               | true |

| AttributeName                  | Value |
| ------------------------------ | ----------------------- |
| EnableTextWrapAndOthers        | false |
| EnableAnchoredObjectOptions    | false |
| FillColor                      | Swatch/None |
| FillTint                       | ­1 |
| StrokeWeight                   | 0 |
| MiterLimit                     | 4 |
| EndCap                         | ButtEndCap |
| EndJoin                        | MiterEndJoin |
| StrokeType                     | StrokeStyle/$ID/Solid |
| LeftLineEnd                    | None |
| RightLineEnd                   | None |
| StrokeColor                    | Swatch/None |
| StrokeTint                     | ­1 |
| TopLeftCornerOption            | None |
| TopRightCornerOption           | None |
| BottomLeftCornerOption         | None |
| BottomRightCornerOption        | None |
| TopLeftCornerRadius            | 12 |
| TopRightCornerRadius           | 12 |
| BottomLeftCornerRadius         | 12 |
| BottomRightCornerRadius        | 12 |
| GapColor                       | Swatch/None |
| GapTint                        | ­1 |
| StrokeAlignment                | CenterAlignment |
| Nonprinting                    | false |
| GradientFillAngle              | 0 |
| GradientStrokeAngle            | 0 |
| AppliedNamedGrid               | n |
| KeyboardShortcut               | 0 0 |
| EnableFrameFittingOptions      | false |
| EnableStrokeAndCornerOptions   | true |

Table 58. Object Style Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------ |
| BasedOn         | $ID/[None] |

## Table 59. TextFrame Preferences Properties Represented as Attributes

| AttributeName                | Value |
| ---------------------------- | -------------- |
| TextColumnCount              | 1 |
| TextColumnGutter             | 12 |
| TextColumnFixedWidth         | 144 |
| UseFixedColumnWidth          | false |
| FirstBaselineOffset          | AscentOffset |
| MinimumFirstBaselineOffset   | 0 |
| VerticalJustification        | TopAlign |
| VerticalThreshold            | 0 |
| IgnoreWrap                   | false |

## Table 60. TextFrame Preferences Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| InsetSpacing    | <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> |

## Table 61. BaselineFrameGrid Options Represented as Attributes

| AttributeName                        | Value |
| ------------------------------------ | ------------ |
| UseCustomBaselineFrameGrid           | false |
| StartingOffsetForBaselineFrameGrid   | 0 |
| BaselineFrameGridRelativeOption      | TopOfInset |
| BaselineFrameGridIncrement           | 12 |

## Table 62. BaselineFrameGrid Options Represented as Elements

| ElementName              | Value |
| ------------------------ | ----------- |
| BaselineFrameGridColor   | LightBlue |

## Table 63. Anchored Object Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | ------------------- |
| AnchoredPosition           | InlinePosition |
| SpineRelative              | false |
| LockPosition               | false |
| PinPosition                | true |
| AnchorPoint                | BottomRightAnchor |
| HorizontalAlignment        | LeftAlign |
| HorizontalReferencePoint   | TextFrame |

| AttributeName            | Value |
| ------------------------ | -------------- |
| VerticalAlignment        | BottomAlign |
| VerticalReferencePoint   | LineBaseline |
| AnchorXoffset            | 0 |
| AnchorYoffset            | 0 |
| AnchorSpaceAbove         | 0 |

## Table 64. TextWrapPreferences Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------- |
| Inverse                 | false |
| ApplyToMasterPageOnly   | false |
| TextWrapSide            | BothSides |
| TextWrapMode            | None |

## Table 65. TextWrapPreferences Properties Represented as Elements

| ElementName      | Value |
| ---------------- | ------------------------------- |
| TextWrapOffset   | Top=0 Left=0 Bottom=0 Right=0 |

## Table 66. Contour Option Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------- |
| ContourType          | SameAsClipping |
| IncludeInsideEdges   | false |
| ContourPathName      | $ID/ |

## StoryPreferences Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ---------------------- |
| OpticalMarginAlignment   | false |
| OpticalMarginSize        | 12 |
| FrameType                | FrameGridType |
| StoryOrientation         | Unknown |
| StoryDirection           | LeftToRightDirection |

## Table 67. Frame Fitting Option Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| LeftCrop          | 0 |
| TopCrop           | 0 |
| RightCrop         | 0 |
| BottomCrop        | 0 |

| AttributeName         | Value |
| --------------------- | --------------- |
| FittingOnEmptyFrame   | None |
| FittingAlignment      | TopLeftAnchor |
| AutoFit               | false |

Table 68. Object Style Object Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 69. Object Style Stroke Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 70. Object Style Fill Effects Category Settings Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | --------- |
| EnableTransparency   | true |
| EnableDropShadow     | true |
| EnableFeather        | true |
| EnableInnerShadow    | true |
| EnableOuterGlow      | true |

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

Table 71. Object Style Content Effects Category Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| EnableTransparency         | true |
| EnableDropShadow           | true |
| EnableFeather              | true |
| EnableInnerShadow          | true |
| EnableOuterGlow            | true |
| EnableInnerGlow            | true |
| EnableBevelEmboss          | true |
| EnableSatin                | true |
| EnableDirectionalFeather   | true |
| EnableGradientFeather      | true |

## 1.1.17 Trap Presets

The defaults file contains two <TrapPreset> elements: [No Trap Preset] and $ID/ kDefaultTrapStyleName . These are the default trap presets for the document.

## [No Trap Preset]

Table 72. Trap Preset Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ----------------------- |
| Name               | $ID/k[No Trap Preset] |
| DefaultTrapWidth   | 0.25 |
| BlackWidth         | 0.5 |
| TrapJoin           | MiterEndJoin |
| TrapEnd            | MiterTrapEnds |
| ObjectsToImages    | true |
| ImagesToImages     | true |
| InternalImages     | false |
| OneBitImages       | true |
| ImagePlacement     | CenterEdges |

| AttributeName          | Value |
| ---------------------- | --------- |
| StepThreshold          | 10 |
| BlackColorThreshold    | 100 |
| BlackDensity           | 1.6 |
| SlidingTrapThreshold   | 70 |
| ColorReduction         | 100 |

## $ID/kDefaultTrapStyleName

Table 73. Trap Preset Properties Represented as Attributes

| AttributeName          | Value |
| ---------------------- | --------------------------- |
| Name                   | $ID/kDefaultTrapStyleName |
| DefaultTrapWidth       | 0.25 |
| BlackWidth             | 0.5 |
| TrapJoin               | MiterEndJoin |
| TrapEnd                | MiterTrapEnds |
| ObjectsToImages        | true |
| ImagesToImages         | true |
| InternalImages         | false |
| OneBitImages           | true |
| ImagePlacement         | CenterEdges |
| StepThreshold          | 10 |
| BlackColorThreshold    | 100 |
| BlackDensity           | 1.6 |
| SlidingTrapThreshold   | 70 |
| ColorReduction         | 100 |

## 1.1.18 Transparency Preferences

The <TransparencyPreference> element defines the default transparency preferences.

Table 74. Transparency Preferences Properties Represented as Attributes

| AttributeName         | Value |
| --------------------- | --------- |
| BlendingSpace         | CMYK |
| GlobalLightAngle      | 120 |
| GlobalLightAltitude   | 30 |

## 1.1.19 Transparency Default Container Object

## TransparencySetting

Table 75. BlendingSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| BlendMode         | Normal |
| Opacity           | 100 |
| KnockoutGroup     | false |
| IsolateBlending   | false |

Table 76. DropShadowSetting Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | ---------- |
| Mode                | None |
| BlendMode           | Multiply |
| Opacity             | 75 |
| XOffset             | 7 |
| YOffset             | 7 |
| Size                | 5 |
| EffectColor         | n |
| Noise               | 0 |
| Spread              | 0 |
| UseGlobalLight      | false |
| KnockedOut          | true |
| HonorOtherEffects   | false |

Table 77. FeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ----------- |
| Mode              | None |
| Width             | 9 |
| CornerType        | Diffusion |
| Noise             | 0 |
| ChokeAmount       | 0 |

Table 78. InnerShadowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Applied           | false |
| EffectColor       | n |

| AttributeName     | Value |
| ----------------- | ---------- |
| BlendMode         | Multiply |
| Opacity           | 75 |
| Angle             | 120 |
| Distance          | 7 |
| UseGlobalLight    | false |
| ChokeAmount       | 0 |
| Size              | 7 |
| Noise             | 0 |

Table 79. OuterGlowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| BlendMode         | Screen |
| Opacity           | 75 |
| Noise             | 0 |
| EffectColor       | n |
| Technique         | Softer |
| Spread            | 0 |
| Size              | 7 |
| Source            | EdgeSourced |

Table 80. BevelAndEmbossSetting Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | --------------- |
| Applied              | false |
| Style                | InnerBevel |
| Technique            | SmoothContour |
| Depth                | 100 |
| Direction            | Up |
| Size                 | 7 |
| Soften               | 0 |
| Angle                | 120 |
| Altitude             | 30 |
| UseGlobalLight       | false |
| HighlightColor       | n |
| HighlightBlendMode   | Screen |
| HighlightOpacity     | 75 |
| ShadowColor          | n |
| ShadowBlendMode      | Multiply |

| AttributeName     | Value |
| ----------------- | --------- |
| ShadowOpacity     | 75 |

## Table 81. SatinSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 50 |
| Angle             | 120 |
| Distance          | 7 |
| Size              | 7 |
| InvertEffect      | false |

## Table 82. DirectionalFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| LeftWidth         | 0 |
| RightWidth        | 0 |
| TopWidth          | 0 |
| BottomWidth       | 0 |
| ChokeAmount       | 0 |
| Angle             | 0 |
| FollowShapeMode   | LeadingEdge |
| Noise             | 0 |

## StrokeTransparencySetting

## Table 83. BlendingSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| BlendMode         | Normal |
| Opacity           | 100 |
| KnockoutGroup     | false |
| IsolateBlending   | false |

Table 84. DropShadowSetting Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | ---------- |
| Mode                | None |
| BlendMode           | Multiply |
| Opacity             | 75 |
| XOffset             | 7 |
| YOffset             | 7 |
| Size                | 5 |
| EffectColor         | n |
| Noise               | 0 |
| Spread              | 0 |
| UseGlobalLight      | false |
| KnockedOut          | true |
| HonorOtherEffects   | false |

Table 85. FeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ----------- |
| Mode              | None |
| Width             | 9 |
| CornerType        | Diffusion |
| Noise             | 0 |
| ChokeAmount       | 0 |

Table 86. InnerShadowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 75 |
| Angle             | 120 |
| Distance          | 7 |
| UseGlobalLight    | false |
| ChokeAmount       | 0 |
| Size              | 7 |
| Noise             | 0 |

Table 87. OuterGlowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| BlendMode         | Screen |
| Opacity           | 75 |
| Noise             | 0 |
| EffectColor       | n |
| Technique         | Softer |
| Spread            | 0 |
| Size              | 7 |
| Source            | EdgeSourced |

Table 88. BevelAndEmbossSetting Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | --------------- |
| Applied              | false |
| Style                | InnerBevel |
| Technique            | SmoothContour |
| Depth                | 100 |
| Direction            | Up |
| Size                 | 7 |
| Soften               | 0 |
| Angle                | 120 |
| Altitude             | 30 |
| UseGlobalLight       | false |
| HighlightColor       | n |
| HighlightBlendMode   | Screen |
| HighlightOpacity     | 75 |
| ShadowColor          | n |
| ShadowBlendMode      | Multiply |
| ShadowOpacity        | 75 |

Table 89. SatinSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 50 |
| Angle             | 120 |
| Distance          | 7 |

| AttributeName     | Value |
| ----------------- | --------- |
| Size              | 7 |
| InvertEffect      | false |

Table 90. DirectionalFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| LeftWidth         | 0 |
| RightWidth        | 0 |
| TopWidth          | 0 |
| BottomWidth       | 0 |
| ChokeAmount       | 0 |
| Angle             | 0 |
| FollowShapeMode   | LeadingEdge |
| Noise             | 0 |

Table 91. GradientFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Applied           | false |
| Type              | Linear |
| Angle             | 0 |
| Length            | 0 |
| GradientStart     | 0 0 |
| HiliteAngle       | 0 |
| HiliteLength      | 0 |

## FillTransparencySetting

Table 92. BlendingSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| BlendMode         | Normal |
| Opacity           | 100 |
| KnockoutGroup     | false |
| IsolateBlending   | false |

Table 93. DropShadowSetting Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | ---------- |
| Mode                | None |
| BlendMode           | Multiply |
| Opacity             | 75 |
| XOffset             | 7 |
| YOffset             | 7 |
| Size                | 5 |
| EffectColor         | n |
| Noise               | 0 |
| Spread              | 0 |
| UseGlobalLight      | false |
| KnockedOut          | true |
| HonorOtherEffects   | false |

Table 94. FeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ----------- |
| Mode              | None |
| Width             | 9 |
| CornerType        | Diffusion |
| Noise             | 0 |
| ChokeAmount       | 0 |

Table 95. InnerShadowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 75 |
| Angle             | 120 |
| Distance          | 7 |
| UseGlobalLight    | false |
| ChokeAmount       | 0 |
| Size              | 7 |
| Noise             | 0 |

Table 96. OuterGlowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| BlendMode         | Screen |
| Opacity           | 75 |
| Noise             | 0 |
| EffectColor       | n |
| Technique         | Softer |
| Spread            | 0 |
| Size              | 7 |
| Source            | EdgeSourced |

Table 97. BevelAndEmbossSetting Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | --------------- |
| Applied              | false |
| Style                | InnerBevel |
| Technique            | SmoothContour |
| Depth                | 100 |
| Direction            | Up |
| Size                 | 7 |
| Soften               | 0 |
| Angle                | 120 |
| Altitude             | 30 |
| UseGlobalLight       | false |
| HighlightColor       | n |
| HighlightBlendMode   | Screen |
| HighlightOpacity     | 75 |
| ShadowColor          | n |
| ShadowBlendMode      | Multiply |
| ShadowOpacity        | 75 |

Table 98. SatinSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 50 |
| Angle             | 120 |
| Distance          | 7 |

| AttributeName     | Value |
| ----------------- | --------- |
| Size              | 7 |
| InvertEffect      | false |

Table 99. DirectionalFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| LeftWidth         | 0 |
| RightWidth        | 0 |
| TopWidth          | 0 |
| BottomWidth       | 0 |
| ChokeAmount       | 0 |
| Angle             | 0 |
| FollowShapeMode   | LeadingEdge |
| Noise             | 0 |

## Table 100. GradientFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Applied           | false |
| Type              | Linear |
| Angle             | 0 |
| Length            | 0 |
| GradientStart     | 0 0 |
| HiliteAngle       | 0 |
| HiliteLength      | 0 |

## ContentTransparencySetting

Table 101. BlendingSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| BlendMode         | Normal |
| Opacity           | 100 |
| KnockoutGroup     | false |
| IsolateBlending   | false |

Table 102. DropShadowSetting Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | ---------- |
| Mode                | None |
| BlendMode           | Multiply |
| Opacity             | 75 |
| XOffset             | 7 |
| YOffset             | 7 |
| Size                | 5 |
| EffectColor         | n |
| Noise               | 0 |
| Spread              | 0 |
| UseGlobalLight      | false |
| KnockedOut          | true |
| HonorOtherEffects   | false |

Table 103. FeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ----------- |
| Mode              | None |
| Width             | 9 |
| CornerType        | Diffusion |
| Noise             | 0 |
| ChokeAmount       | 0 |

Table 104. InnerShadowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 75 |
| Angle             | 120 |
| Distance          | 7 |
| UseGlobalLight    | false |
| ChokeAmount       | 0 |
| Size              | 7 |
| Noise             | 0 |

Table 105. OuterGlowSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| BlendMode         | Screen |
| Opacity           | 75 |
| Noise             | 0 |
| EffectColor       | n |
| Technique         | Softer |
| Spread            | 0 |
| Size              | 7 |
| Source            | EdgeSourced |

Table 106. BevelAndEmbossSetting Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | --------------- |
| Applied              | false |
| Style                | InnerBevel |
| Technique            | SmoothContour |
| Depth                | 100 |
| Direction            | Up |
| Size                 | 7 |
| Soften               | 0 |
| Angle                | 120 |
| Altitude             | 30 |
| UseGlobalLight       | false |
| HighlightColor       | n |
| HighlightBlendMode   | Screen |
| HighlightOpacity     | 75 |
| ShadowColor          | n |
| ShadowBlendMode      | Multiply |
| ShadowOpacity        | 75 |

Table 107. SatinSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------- |
| Applied           | false |
| EffectColor       | n |
| BlendMode         | Multiply |
| Opacity           | 50 |
| Angle             | 120 |
| Distance          | 7 |

| AttributeName     | Value |
| ----------------- | --------- |
| Size              | 7 |
| InvertEffect      | false |

Table 108. DirectionalFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| Applied           | false |
| LeftWidth         | 0 |
| RightWidth        | 0 |
| TopWidth          | 0 |
| BottomWidth       | 0 |
| ChokeAmount       | 0 |
| Angle             | 0 |
| FollowShapeMode   | LeadingEdge |
| Noise             | 0 |

Table 109. GradientFeatherSetting Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Applied           | false |
| Type              | Linear |
| Angle             | 0 |
| Length            | 0 |
| GradientStart     | 0 0 |
| HiliteAngle       | 0 |
| HiliteLength      | 0 |

## 1.1.20 StoryPreferences

The <StoryPreference> element defines the default StoryPreferences for the document.

Table 110. StoryPreferences Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ---------------------- |
| OpticalMarginAlignment   | false |
| OpticalMarginSize        | 12 |
| FrameType                | TextFrameType |
| StoryOrientation         | Horizontal |
| StoryDirection           | LeftToRightDirection |

## 1.1.21 TextFrame Preferences

The <TextFramePreference> element defines the default TextFrame preferences for the document.

Table 111. TextFrame Preferences Properties Represented as Attributes

| AttributeName                | Value |
| ---------------------------- | -------------- |
| TextColumnCount              | 1 |
| TextColumnGutter             | 12 |
| TextColumnFixedWidth         | 144 |
| UseFixedColumnWidth          | false |
| FirstBaselineOffset          | AscentOffset |
| MinimumFirstBaselineOffset   | 0 |
| VerticalJustification        | TopAlign |
| VerticalThreshold            | 0 |
| IgnoreWrap                   | false |
| VerticalBalanceColumns       | false |

Table 112. TextFrame Preferences Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------------------------------------------------------------------------------------------------------------------------------- |
| InsetSpacing    | <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> <ListItem type=unit>0</ListItem> |

## 1.1.22 Text Preferences

The <TextPreference> element defines the default text preferences for the document.

Table 113. Text Preferences Properties Represented as Attributes

| AttributeName                | Value |
| ---------------------------- | --------- |
| TypographersQuotes           | true |
| HighlightHjViolations        | false |
| HighlightKeeps               | false |
| HighlightSubstitutedGlyphs   | false |
| HighlightCustomSpacing       | false |
| HighlightSubstitutedFonts    | true |
| UseOpticalSize               | true |
| UseParagraphLeading          | false |
| SuperscriptSize              | 58.3 |
| SuperscriptPosition          | 33.3 |

| AttributeName                | Value |
| ---------------------------- | ------------ |
| SubscriptSize                | 58.3 |
| SubscriptPosition            | 33.3 |
| SmallCap                     | 70 |
| LeadingKeyIncrement          | 2 |
| BaselineShiftKeyIncrement    | 2 |
| KerningKeyIncrement          | 20 |
| ShowInvisibles               | false |
| JustifyTextWraps             | false |
| AbutTextToTextWrap           | true |
| ZOrderTextWrap               | false |
| LinkTextFilesWhenImporting   | false |
| HighlightKinsoku             | false |
| UseNewVerticalScaling        | false |
| UseCidMojikumi               | false |
| EnableStylePreviewMode       | false |
| SmartTextReflow              | true |
| AddPages                     | EndOfStory |
| LimitToMasterTextFrames      | true |
| PreserveFacingPageSpreads    | false |
| DeleteEmptyPages             | false |

## 1.1.23 Text Defaults

The <TextDefault> element defines the default text formatting for the document.

Table 114. Text Defaults Properties Represented as Attributes

| AttributeName             | Value |
| ------------------------- | ---------------- |
| FirstLineIndent           | 0 |
| LeftIndent                | 0 |
| RightIndent               | 0 |
| SpaceBefore               | 0 |
| SpaceAfter                | 0 |
| Justification             | LeftAlign |
| SingleWordJustification   | FullyJustified |
| AutoLeading               | 120 |
| DropCapLines              | 0 |
| DropCapCharacters         | 0 |
| KeepLinesTogether         | false |
| KeepAllLinesTogether      | false |

| AttributeName               | Value |
| --------------------------- | ------------- |
| KeepWithNext                | 0 |
| KeepFirstLines              | 2 |
| KeepLastLines               | 2 |
| StartParagraph              | Anywhere |
| Composer                    | HL Composer |
| MinimumWordSpacing          | 80 |
| MaximumWordSpacing          | 133 |
| DesiredWordSpacing          | 100 |
| MinimumLetterSpacing        | 0 |
| MaximumLetterSpacing        | 0 |
| DesiredLetterSpacing        | 0 |
| MinimumGlyphScaling         | 100 |
| MaximumGlyphScaling         | 100 |
| DesiredGlyphScaling         | 100 |
| RuleAbove                   | false |
| RuleAboveOverprint          | false |
| RuleAboveLineWeight         | 1 |
| RuleAboveTint               | ­1 |
| RuleAboveOffset             | 0 |
| RuleAboveLeftIndent         | 0 |
| RuleAboveRightIndent        | 0 |
| RuleAboveWidth              | ColumnWidth |
| RuleAboveGapTint            | ­1 |
| RuleAboveGapOverprint       | false |
| RuleBelow                   | false |
| RuleBelowLineWeight         | 1 |
| RuleBelowTint               | ­1 |
| RuleBelowOffset             | 0 |
| RuleBelowLeftIndent         | 0 |
| RuleBelowRightIndent        | 0 |
| RuleBelowWidth              | ColumnWidth |
| RuleBelowGapTint            | ­1 |
| HyphenateCapitalizedWords   | true |
| Hyphenation                 | true |
| HyphenateBeforeLast         | 2 |
| HyphenateAfterFirst         | 2 |
| HyphenateWordsLongerThan    | 5 |
| HyphenateLadderLimit        | 3 |
| HyphenationZone             | 36 |

| AttributeName               | Value |
| --------------------------- | ----------------------------------------- |
| HyphenWeight                | 5 |
| AppliedParagraphStyle       | ParagraphStyle/$ID/NormalParagraphStyle |
| AppliedCharacterStyle       | CharacterStyle/$ID/[No CharacterStyle] |
| FontStyle                   | Regular |
| PointSize                   | 12 |
| KerningMethod               | $ID/Metrics |
| Tracking                    | 0 |
| Capitalization              | Normal |
| Position                    | Normal |
| Underline                   | false |
| StrikeThru                  | false |
| Ligatures                   | true |
| NoBreak                     | false |
| HorizontalScale             | 100 |
| VerticalScale               | 100 |
| BaselineShift               | 0 |
| Skew                        | 0 |
| FillTint                    | ­1 |
| StrokeTint                  | ­1 |
| StrokeWeight                | 1 |
| OverprintStroke             | false |
| OverprintFill               | false |
| OTFFigureStyle              | Default |
| OTFOrdinal                  | false |
| OTFFraction                 | false |
| OTFDiscretionaryLigature    | false |
| OTFTitling                  | false |
| OTFContextualAlternate      | true |
| OTFSwash                    | false |
| UnderlineTint               | ­1 |
| UnderlineGapTint            | ­1 |
| UnderlineOverprint          | false |
| UnderlineGapOverprint       | false |
| UnderlineOffset             | ­9999 |
| UnderlineWeight             | ­9999 |
| StrikeThroughTint           | ­1 |
| StrikeThroughGapTint        | ­1 |
| StrikeThroughOverprint      | false |
| StrikeThroughGapOverprint   | false |

| AttributeName               | Value |
| --------------------------- | ---------------------- |
| StrikeThroughOffset         | ­9999 |
| StrikeThroughWeight         | ­9999 |
| FillColor                   | Color/Black |
| StrokeColor                 | Swatch/None |
| AppliedLanguage             | $ID/English: USA |
| LastLineIndent              | 0 |
| HyphenateLastWord           | true |
| OTFSlashedZero              | false |
| OTFHistorical               | false |
| OTFStylisticSets            | 0 |
| GradientFillLength          | ­1 |
| GradientFillAngle           | 0 |
| GradientStrokeLength        | ­1 |
| GradientStrokeAngle         | 0 |
| GradientFillStart           | 0 0 |
| GradientStrokeStart         | 0 0 |
| RuleBelowOverprint          | false |
| RuleBelowGapOverprint       | false |
| DropcapDetail               | 0 |
| HyphenateAcrossColumns      | true |
| KeepRuleAboveInFrame        | false |
| IgnoreEdgeAlignment         | false |
| OTFMark                     | true |
| OTFLocale                   | true |
| PositionalForm              | None |
| ParagraphDirection          | LeftToRightDirection |
| ParagraphJustification      | DefaultJustification |
| MiterLimit                  | 4 |
| StrokeAlignment             | OutsideAlignment |
| EndJoin                     | MiterEndJoin |
| OTFOverlapSwash             | false |
| OTFStylisticAlternate       | false |
| OTFJustificationAlternate   | false |
| OTFStretchedAlternate       | false |
| CharacterDirection          | DefaultDirection |
| KeyboardDirection           | DefaultDirection |
| DigitsType                  | DefaultDigits |
| Kashidas                    | DefaultKashidas |
| DiacriticPosition           | OpentypePosition |

| AttributeName           | Value |
| ----------------------- | ------------------- |
| XOffsetDiacritic        | 0 |
| YOffsetDiacritic        | 0 |
| ParagraphBreakType      | Anywhere |
| PageNumberType          | AutoPageNumber |
| AppliedNamedGrid        | n |
| CharacterAlignment      | AlignEmCenter |
| Tsume                   | 0 |
| LeadingAki              | ­1 |
| TrailingAki             | ­1 |
| CharacterRotation       | 0 |
| Jidori                  | 0 |
| ShataiMagnification     | 0 |
| ShataiDegreeAngle       | 4500 |
| ShataiAdjustRotation    | false |
| ShataiAdjustTsume       | true |
| Tatechuyoko             | false |
| TatechuyokoXOffset      | 0 |
| TatechuyokoYOffset      | 0 |
| KentenTint              | ­1 |
| KentenStrokeTint        | ­1 |
| KentenWeight            | ­1 |
| KentenOverprintFill     | Auto |
| KentenOverprintStroke   | Auto |
| KentenKind              | None |
| KentenPlacement         | 0 |
| KentenAlignment         | AlignKentenCenter |
| KentenPosition          | AboveRight |
| KentenFontSize          | ­1 |
| KentenXScale            | 100 |
| KentenYScale            | 100 |
| KentenCustomCharacter   |  |
| KentenCharacterSet      | CharacterInput |
| RubyTint                | ­1 |
| RubyWeight              | ­1 |
| RubyOverprintFill       | Auto |
| RubyOverprintStroke     | Auto |
| RubyStrokeTint          | ­1 |
| RubyFontSize            | ­1 |
| RubyOpenTypePro         | true |

| AttributeName                | Value |
| ---------------------------- | ---------------------- |
| RubyXScale                   | 100 |
| RubyYScale                   | 100 |
| RubyType                     | PerCharacterRuby |
| RubyAlignment                | RubyJIS |
| RubyPosition                 | AboveRight |
| RubyXOffset                  | 0 |
| RubyYOffset                  | 0 |
| RubyParentSpacing            | RubyParent121Aki |
| RubyAutoAlign                | true |
| RubyOverhang                 | false |
| RubyAutoScaling              | false |
| RubyParentScalingPercent     | 66 |
| RubyParentOverhangAmount     | RubyOverhangOneRuby |
| Warichu                      | false |
| WarichuSize                  | 50 |
| WarichuLines                 | 2 |
| WarichuLineSpacing           | 0 |
| WarichuAlignment             | Auto |
| WarichuCharsAfterBreak       | 2 |
| WarichuCharsBeforeBreak      | 2 |
| OTFProportionalMetrics       | false |
| OTFHVKana                    | false |
| OTFRomanItalics              | false |
| ScaleAffectsLineHeight       | false |
| CjkGridTracking              | false |
| GlyphForm                    | None |
| GridAlignFirstLineOnly       | false |
| GridAlignment                | None |
| GridGyoudori                 | 0 |
| AutoTcy                      | 0 |
| AutoTcyIncludeRoman          | false |
| KinsokuType                  | KinsokuPushInFirst |
| KinsokuHangType              | None |
| BunriKinshi                  | true |
| Rensuuji                     | true |
| RotateSingleByteCharacters   | false |
| LeadingModel                 | LeadingModelAkiBelow |
| RubyAutoTcyDigits            | 0 |
| RubyAutoTcyIncludeRoman      | false |

| AttributeName                  | Value |
| ------------------------------ | -------------- |
| RubyAutoTcyAutoScale           | true |
| TreatIdeographicSpaceAsSpace   | false |
| AllowArbitraryHyphenation      | false |
| ParagraphGyoudori              | false |
| BulletsAndNumberingListType    | NoList |
| NumberingExpression            | ^#.^t |
| BulletsTextAfter               | ^t |
| NumberingLevel                 | 1 |
| NumberingContinue              | true |
| NumberingStartAt               | 1 |
| NumberingApplyRestartPolicy    | true |
| BulletsAlignment               | LeftAlign |
| NumberingAlignment             | LeftAlign |
| SpanSplitColumnCount           | All |
| SpanColumnType                 | SingleColumn |
| SplitColumnsInsideGutter       | 6 |
| SplitColumnsOutsideGutter      | 6 |
| KeepWithPrevious               | false |

Table 115. Text Defaults Properties Represented as Elements

| ElementName             | Value |
| ----------------------- | ----------------------- |
| BalanceRaggedLines      | NoBalancing |
| RuleAboveColor          | Text Color |
| RuleAboveGapColor       | Swatch/None |
| RuleAboveType           | StrokeStyle/$ID/Solid |
| RuleBelowColor          | Text Color |
| RuleBelowGapColor       | Swatch/None |
| RuleBelowType           | StrokeStyle/$ID/Solid |
| AppliedFont             | Minion Pro |
| Leading                 | Auto |
| UnderlineColor          | Text Color |
| UnderlineGapColor       | Swatch/None |
| UnderlineType           | StrokeStyle/$ID/Solid |
| StrikeThroughColor      | Text Color |
| StrikeThroughGapColor   | Swatch/None |
| StrikeThroughType       | StrokeStyle/$ID/Solid |
| KentenFillColor         | Text Color |
| KentenStrokeColor       | Text Color |

| ElementName                | Value |
| -------------------------- | ----------------------------------------------------------- |
| KentenFont                 | $ID/ |
| KentenFontStyle            | Nothing |
| RubyFill                   | Text Color |
| RubyStroke                 | Text Color |
| RubyFont                   | $ID/ |
| RubyFontStyle              | Nothing |
| KinsokuSet                 | Nothing |
| Mojikumi                   | Nothing |
| BulletChar                 | BulletCharacterType=UnicodeOnly BulletCharacterValue=8226 |
| BulletsFont                | $ID/ |
| BulletsFontStyle           | Nothing |
| BulletsCharacterStyle      | CharacterStyle/$ID/[No CharacterStyle] |
| NumberingCharacterStyle    | CharacterStyle/$ID/[No CharacterStyle] |
| AppliedNumberingList       | /$ID/[Default] |
| NumberingFormat            | 1, 2, 3, 4... |
| NumberingRestartPolicies   | RestartPolicy=AnyPreviousLevel LowerLevel=0 UpperLevel=0 |

## 1.1.24 Anchored Object Defaults

The <AnchoredObjectDefault> element defines the default formatting and behavior of anchored objects in the document.

Table 116. Anchored Object Defaults Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ----------------------------------------- |
| AnchorContent            | Unassigned |
| InitialAnchorHeight      | 72 |
| InitialAnchorWidth       | 72 |
| AnchoredParagraphStyle   | ParagraphStyle/$ID/[No paragraph style] |
| AnchoredObjectStyle      | ObjectStyle/$ID/[None] |

## 1.1.25 Anchored Object Settings

The <AnchoredObjectSetting> element defines the default anchored objects settings used in the document.

Table 117. Anchored Object Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | ------------------- |
| AnchoredPosition           | InlinePosition |
| SpineRelative              | false |
| LockPosition               | false |
| PinPosition                | true |
| AnchorPoint                | BottomRightAnchor |
| HorizontalAlignment        | LeftAlign |
| HorizontalReferencePoint   | TextFrame |
| VerticalAlignment          | TopAlign |
| VerticalReferencePoint     | LineBaseline |
| AnchorXoffset              | 0 |
| AnchorYoffset              | 0 |
| AnchorSpaceAbove           | 0 |

## 1.1.26 BaselineFrameGrid Options

The <BaselineFrameGridOption> element defines the default anchored objects settings used in the document.

Table 118. Basic Frame Grid Options Properties Represented as Attributes

| AttributeName                        | Value |
| ------------------------------------ | ------------ |
| UseCustomBaselineFrameGrid           | false |
| StartingOffsetForBaselineFrameGrid   | 0 |
| BaselineFrameGridRelativeOption      | TopOfInset |
| BaselineFrameGridIncrement           | 12 |

Table 119. BaselineFrameGrid Options Represented as Elements

| ElementName              | Value |
| ------------------------ | ----------- |
| BaselineFrameGridColor   | LightBlue |

## 1.1.27 FootnoteOptions

The <FootnoteOption> element defines the default FootnoteOptions used in the document.

Table 120. FootnoteOptions Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| StartAt           | 1 |
| Prefix            |  |

| AttributeName                        | Value |
| ------------------------------------ | ----------------------------------------- |
| Suffix                               |  |
| FootnoteTextStyle                    | ParagraphStyle/$ID/NormalParagraphStyle |
| FootnoteMarkerStyle                  | CharacterStyle/$ID/[No CharacterStyle] |
| SeparatorText                        | &#x9; |
| SpaceBetween                         | 0 |
| Spacer                               | 0 |
| FootnoteFirstBaselineOffset          | LeadingOffset |
| FootnoteMinimumFirstBaselineOffset   | 0 |
| EosPlacement                         | false |
| NoSplitting                          | false |
| RuleOn                               | true |
| RuleLineWeight                       | 1 |
| RuleTint                             | 100 |
| RuleGapTint                          | 100 |
| RuleGapOverprint                     | false |
| RuleOverprint                        | false |
| RuleLeftIndent                       | 0 |
| RuleWidth                            | 72 |
| RuleOffset                           | 0 |
| ContinuingRuleOn                     | true |
| ContinuingRuleLineWeight             | 1 |
| ContinuingRuleTint                   | 100 |
| ContinuingRuleGapTint                | 100 |
| ContinuingRuleOverprint              | false |
| ContinuingRuleGapOverprint           | false |
| ContinuingRuleLeftIndent             | 0 |
| ContinuingRuleWidth                  | 288 |
| ContinuingRuleOffset                 | 0 |

Table 121. FootnoteOptions Properties Represented as Elements

| ElementName              | Value |
| ------------------------ | ----------------------- |
| FootnoteNumberingStyle   | Arabic |
| RestartNumbering         | DontRestart |
| ShowPrefixSuffix         | NoPrefixSuffix |
| MarkerPositioning        | SuperscriptMarker |
| RuleType                 | StrokeStyle/$ID/Solid |
| RuleColor                | Color/Black |
| RuleGapColor             | Swatch/None |

| ElementName              | Value |
| ------------------------ | ----------------------- |
| ContinuingRuleType       | StrokeStyle/$ID/Solid |
| ContinuingRuleColor      | Color/Black |
| ContinuingRuleGapColor   | Swatch/None |

## 1.1.28 TextWrapPreferences

The <TextWrapPreference> element defines the default TextWrapPreferences used in the document. The <TextWrapPreference> element contains a <ContourOption> element.

Table 122. TextWrapPreferences Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------- |
| Inverse                 | false |
| ApplyToMasterPageOnly   | false |
| TextWrapSide            | BothSides |
| TextWrapMode            | None |

Table 123. TextWrapPreferences Properties Represented as Elements

| ElementName      | Value |
| ---------------- | ------------------------------- |
| TextWrapOffset   | Top=0 Left=0 Bottom=0 Right=0 |

Table 124. Contour Option Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------- |
| ContourType          | SameAsClipping |
| IncludeInsideEdges   | false |
| ContourPathName      | $ID/ |

## 1.1.29 Document Preferences

The <DocumentPreference> element defines the default document preferences.

Table 125. DocumentPreference Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | --------- |
| PageHeight               | 792 |
| PageWidth                | 612 |
| PagesPerDocument         | 1 |
| FacingPages              | true |
| DocumentBleedTopOffset   | 0 |

| AttributeName                       | Value |
| ----------------------------------- | ------------- |
| DocumentBleedBottomOffset           | 0 |
| DocumentBleedInsideOrLeftOffset     | 0 |
| DocumentBleedOutsideOrRightOffset   | 0 |
| DocumentBleedUniformSize            | true |
| SlugTopOffset                       | 0 |
| SlugBottomOffset                    | 0 |
| SlugInsideOrLeftOffset              | 0 |
| SlugRightOrOutsideOffset            | 0 |
| DocumentSlugUniformSize             | false |
| PreserveLayoutWhenShuffling         | true |
| AllowPageShuffle                    | true |
| OverprintBlack                      | true |
| PageBinding                         | LeftToRight |
| ColumnDirection                     | Horizontal |
| ColumnGuideLocked                   | true |
| MasterTextFrame                     | false |
| SnippetImportUsesOriginalLocation   | false |
| Intent                              | PrintIntent |

Table 126. Document Preferences Properties Represented as Elements

| ElementName        | Value |
| ------------------ | --------- |
| ColumnGuideColor   | Violet |
| MarginGuideColor   | Magenta |

## 1.1.30 MarginPreferences

The <MarginPreference> element defines the default MarginPreferences used in the document.

Table 127. MarginPreferences Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------ |
| ColumnCount       | 1 |
| ColumnGutter      | 12 |
| Top               | 36 |
| Bottom            | 36 |
| Left              | 36 |
| Right             | 36 |
| ColumnDirection   | Horizontal |

## 1.1.31 Page Item Defaults

The <PageItemDefault> element defines the default formatting used for page items.

Table 128. Page Item Defaults Properties Represented as Attributes

| AttributeName               | Value |
| --------------------------- | ----------------------------------------- |
| AppliedGraphicObjectStyle   | ObjectStyle/$ID/[Normal Graphics Frame] |
| AppliedTextObjectStyle      | ObjectStyle/$ID/[Normal TextFrame] |
| AppliedGridObjectStyle      | ObjectStyle/$ID/[Normal Grid] |
| FillColor                   | Swatch/None |
| FillTint                    | ­1 |
| StrokeWeight                | 1 |
| MiterLimit                  | 4 |
| EndCap                      | ButtEndCap |
| EndJoin                     | MiterEndJoin |
| StrokeType                  | StrokeStyle/$ID/Solid |
| LeftLineEnd                 | None |
| RightLineEnd                | None |
| StrokeColor                 | Swatch/None |
| StrokeTint                  | ­1 |
| TopLeftCornerOption         | None |
| TopRightCornerOption        | None |
| BottomLeftCornerOption      | None |
| BottomRightCornerOption     | None |
| TopLeftCornerRadius         | 12 |
| TopRightCornerRadius        | 12 |
| BottomLeftCornerRadius      | 12 |
| BottomRightCornerRadius     | 12 |
| GradientFillAngle           | 0 |
| GradientStrokeAngle         | 0 |
| GapColor                    | Swatch/None |
| GapTint                     | ­1 |
| StrokeAlignment             | CenterAlignment |
| Nonprinting                 | false |

## 1.1.32 Frame Fitting Options

The <FrameFittingOption> element defines the default frame fitting options used in the document.

Table 129. Frame Fitting Properties Represented as Attributes

| AttributeName         | Value |
| --------------------- | --------------- |
| LeftCrop              | 0 |
| TopCrop               | 0 |
| RightCrop             | 0 |
| BottomCrop            | 0 |
| FittingOnEmptyFrame   | None |
| FittingAlignment      | TopLeftAnchor |
| AutoFit               | false |

## 1.1.33 Button Preferences

The <ButtonPreference> element defines the default button name used in the document.

Table 130. Button Preferences Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Name              |  |

## 1.1.34 Conditional Text Preferences

The <ConditionalTextPreference> element defines the defaults for conditional text used in the document.

Table 131. Conditional Text Preferences Properties Represented as Attributes

| AttributeName             | Value |
| ------------------------- | ---------------- |
| ShowConditionIndicators   | ShowIndicators |
| ActiveConditionSet        | n |

## 1.1.35 XML Tag

The <XMLTag> element defines the default XML tag used in the document.

Table 132. XML Tag Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Name              | Root |

Table 133. XMLTag Properties Represented as Elements

| AttributeName     | Value |
| ----------------- | ----------------------- |
| TagColor type     | enumeration>LightBlue |

## 1.1.36 Layer

The <Layer> element defines the default layer used in the document.

Table 134. Layer Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| Name              | Layer 1 |
| Visible           | true |
| Locked            | false |
| IgnoreWrap        | false |
| ShowGuides        | true |
| LockGuides        | false |
| UI                | true |
| Expendable        | true |
| Printable         | true |

Table 135. Layer Properties Represented as Elements

| AttributeName     | Value |
| ----------------- | ----------- |
| LayerColor type   | LightBlue |

## 1.1.37 Master Spread

The <MasterSpread> element defines the default master spread of the document. The <MasterSpread> element contains two <Page> elements, which, in turn, contain <MarginPreference> and <GridDataInformation> elements.

Table 136. Master Spread Properties Represented as Attributes

| AttributeName             | Value |
| ------------------------- | -------------------- |
| ItemTransform             | 1 0 0 1 0 0 |
| Name                      | A­Master |
| NamePrefix                | A |
| BaseName                  | Master |
| ShowMasterItems           | true |
| PageCount                 | 2 |
| OverriddenPageItemProps   |  |
| PageColor                 | UseMasterPageColor |

The two <Page> elements are identical.

Table 137. Page Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | -------------------------------------- |
| Name                | A |
| AppliedTrapPreset   | TrapPreset/$ID/kDefaultTrapStyleName |
| AppliedMaster       | n |
| OverrideList        |  |
| TabOrder            |  |
| GridStartingPoint   | TopOutside |
| UseMasterGrid       | true |
| PageColor           | UseMasterPageColor |

Each <Page> element contains a <MarginPreference> element.

Table 138. MarginPreferences Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ------------ |
| ColumnCount        | 1 |
| ColumnGutter       | 12 |
| Top                | 36 |
| Bottom             | 36 |
| Left               | 36 |
| Right              | 36 |
| ColumnDirection    | Horizontal |
| ColumnsPositions   | 0 540 |

Each <Page> element contains a <GridDataInformation> element.

Table 139. Grid Data Information Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------------- |
| FontStyle            | Regular |
| PointSize            | 12 |
| CharacterAki         | 0 |
| LineAki              | 9 |
| HorizontalScale      | 100 |
| VerticalScale        | 100 |
| LineAlignment        | LeftOrTopLineJustify |
| GridAlignment        | AlignEmCenter |
| CharacterAlignment   | AlignEmCenter |

Table 140. Grid Data Information Properties Represented as Elements

| AttributeName     | Value |
| ----------------- | ------------ |
| AppliedFont       | Minion Pro |

Table 141. Timing Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| UnassignedDynamicTargets   |  |

## 1.1.38 Page

The <Page> element defines the default page used in the document.

Table 142. Page Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | -------------------------------------- |
| Name                | A |
| AppliedTrapPreset   | TrapPreset/$ID/kDefaultTrapStyleName |
| AppliedMaster       | n |
| OverrideList        |  |
| TabOrder            |  |
| GridStartingPoint   | TopOutside |
| UseMasterGrid       | true |

Each <Page> element contains a <MarginPreference> element.

Table 143. MarginPreferences Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ------------ |
| ColumnCount        | 1 |
| ColumnGutter       | 12 |
| Top                | 36 |
| Bottom             | 36 |
| Left               | 36 |
| Right              | 36 |
| ColumnDirection    | Horizontal |
| ColumnsPositions   | 0 540 |

Each <Page> element contains a <GridDataInformation> element.

Table 144. Grid Data Information Properties Represented as Attributes

| AttributeName        | Value |
| -------------------- | ---------------------- |
| FontStyle            | Regular |
| PointSize            | 12 |
| CharacterAki         | 0 |
| LineAki              | 9 |
| HorizontalScale      | 100 |
| VerticalScale        | 100 |
| LineAlignment        | LeftOrTopLineJustify |
| GridAlignment        | AlignEmCenter |
| CharacterAlignment   | AlignEmCenter |

Table 145. Grid Data Information Properties Represented as Elements

| ElementName     | Value |
| --------------- | ------------ |
| AppliedFont     | Minion Pro |

## 1.1.39 Spread

The <Spread> element defines the default spread used in the document. The <Spread> element contains a < FlattenerPreference > element. The <Spread> element contains a <Page> element.

Table 146. Spread Properties Represented as Attributes

| AttributeName             | Value |
| ------------------------- | --------------- |
| PageTransitionType        | None |
| PageTransitionDirection   | NotApplicable |
| PageTransitionDuration    | Medium |
| FlattenerOverride         | Default |
| ShowMasterItems           | true |
| PageCount                 | 1 |
| BindingLocation           | 0 |
| AllowPageShuffle          | true |
| ItemTransform             | 1 0 0 1 0 0 |

Table 147. FlattenerPreference Properties Represented as Attributes

| AttributeName                 | Value |
| ----------------------------- | --------- |
| LineArtAndTextResolution      | 300 |
| GradientAndMeshResolution     | 150 |
| ClipComplexRegions            | false |
| ConvertAllStrokesToOutlines   | false |

| AttributeName              | Value |
| -------------------------- | --------- |
| ConvertAllTextToOutlines   | false |

## Table 148. FlattenerPreference Properties Represented as Elements

| ElementName           | Value |
| --------------------- | --------- |
| RasterVectorBalance   | 50 |

Table 149. Page Properties Represented as Attributes

| AttributeName       | Value |
| ------------------- | -------------------------------------- |
| Name                | A |
| AppliedTrapPreset   | TrapPreset/$ID/kDefaultTrapStyleName |
| AppliedMaster       | n |
| OverrideList        |  |
| TabOrder            |  |
| GridStartingPoint   | TopOutside |
| UseMasterGrid       | true |

Each <Page> element contains a <MarginPreference> element.

Table 150. MarginPreferences Properties Represented as Attributes

| AttributeName      | Value |
| ------------------ | ------------ |
| ColumnCount        | 1 |
| ColumnGutter       | 12 |
| Top                | 36 |
| Bottom             | 36 |
| Left               | 36 |
| Right              | 36 |
| ColumnDirection    | Horizontal |
| ColumnsPositions   | 0 540 |

Each <Page> element contains a <GridDataInformation> element.

Table 151. Grid Data Information Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| FontStyle         | Regular |
| PointSize         | 12 |
| CharacterAki      | 0 |
| LineAki           | 9 |
| HorizontalScale   | 100 |

| AttributeName        | Value |
| -------------------- | ---------------------- |
| VerticalScale        | 100 |
| LineAlignment        | LeftOrTopLineJustify |
| GridAlignment        | AlignEmCenter |
| CharacterAlignment   | AlignEmCenter |

Table 152. Grid Data Information Properties Represented as Elements

| AttributeName     | Value |
| ----------------- | ------------ |
| AppliedFont       | Minion Pro |

Table 153. Timing Settings Properties Represented as Attributes

| AttributeName              | Value |
| -------------------------- | --------- |
| UnassignedDynamicTargets   |  |

## 1.1.40 Section

The <Section> element defines the default section used in the document.

Table 154. Section Properties Represented as Attributes

| AttributeName          | Value |
| ---------------------- | --------- |
| Length                 | 1 |
| Name                   |  |
| PageNumberStyle        | Arabic |
| ContinueNumbering      | true |
| IncludeSectionPrefix   | false |
| Marker                 |  |
| PageStart              | ube |
| SectionPrefix          |  |

## 1.1.41 XmlStory

The <XmlStory> element defines the default XML story (unplaced XML text elements) of the document. The <XmlStory> element contains a <StoryPreference> element and a <ParagraphStyleRange> element.

Table 155. Xml Story Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------- |
| AppliedTOCStyle   | n |
| TrackChanges      | false |

| AttributeName      | Value |
| ------------------ | --------- |
| StoryTitle         | $ID/ |
| AppliedNamedGrid   | n |

Table 156. StoryPreferences Properties Represented as Attributes

| AttributeName            | Value |
| ------------------------ | ---------------------- |
| OpticalMarginAlignment   | false |
| OpticalMarginSize        | 12 |
| FrameType                | TextFrameType |
| StoryOrientation         | Horizontal |
| StoryDirection           | LeftToRightDirection |

Table 157. Paragraph Style Range Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------------------------------------- |
| AppliedParagraphStyle   | ParagraphStyle/$ID/NormalParagraphStyle |

The <ParagraphStyleRange> element contains a <CharacterStyleRange> element.

Table 158. CharacterStyleRange Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | ----------------------------------------- |
| AppliedCharacterStyle   | CharacterStyle/$ID/[No CharacterStyle] |

Table 159. CharacterStyleRange Properties Represented as Elements

| ElementName     | Value |
| --------------- | ----------------------- |
| XMLElement      | MarkupTag=XMLTag/Root |
| Content         | ï¿ |

Table 160. InCopyExportOption Properties Represented as Attributes

| AttributeName           | Value |
| ----------------------- | --------- |
| IncludeGraphicProxies   | true |
| IncludeAllResources     | true |

## 1.1.42 IndexingSortOptions

The <IndexingSortOptions> elements defines the default indexing sort options for the document. The default document contains eight <IndexSortOptions> elements with the following names: $ID/kIndexGroup\_Symbol , $ID/kIndexGroup\_Alphabet , $ID/kIndexGroup\_Numeric , $ID/ kWRIndexGroup\_GreekAlphabet , $ID/kWRIndexGroup\_CyrillicAlphabet , $ID/kIndexGroup\_ Kana , $ID/kIndexGroup\_Chinese , $ID/kIndexGroup\_Korean ArabicAlphabet, HebrewAlphabet .

## $ID/kIndexGroup\_Symbol

## Table 161. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------------------ |
| Name              | $ID/kIndexGroup_Symbol |
| Include           | true |
| Priority          | 0 |
| HeaderType        | Nothing |

## $ID/kIndexGroup\_Alphabet

## Table 162. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | -------------------------- |
| Name              | $ID/kIndexGroup_Alphabet |
| Include           | true |
| Priority          | 1 |
| HeaderType        | BasicLatin |

## $ID/kIndexGroup\_Numeric

## Table 163. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------------------- |
| Name              | $ID/kIndexGroup_Numeric |
| Include           | false |
| Priority          | 2 |
| HeaderType        | Nothing |

## $ID/kWRIndexGroup\_GreekAlphabet

Table 164. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------------------------------- |
| Name              | $ID/kWRIndexGroup_GreekAlphabet |
| Include           | false |
| Priority          | 3 |
| HeaderType        | Nothing |

## $ID/kWRIndexGroup\_CyrillicAlphabet

## Table 165. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------------------------------ |
| Name              | $ID/kWRIndexGroup_CyrillicAlphabet |
| Include           | false |
| Priority          | 4 |
| HeaderType        | Russian |

## $ID/kIndexGroup\_Kana

## Table 166. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------------------- |
| Name              | $ID/kIndexGroup_Kana |
| Include           | false |
| Priority          | 5 |
| HeaderType        | HiraganaAll |

## $ID/kIndexGroup\_Chinese

Table 167. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------------------- |
| Name              | $ID/kIndexGroup_Chinese |
| Include           | false |
| Priority          | 6 |
| HeaderType        | ChinesePinyin |

## $ID/kIndexGroup\_Korean

Table 168. Indexing Sort Options Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------------------ |
| Name              | $ID/kIndexGroup_Korean |
| Include           | false |
| Priority          | 7 |
| HeaderType        | KoreanConsonant |

## 1.1.43 Bullets

A series of <ABullet> elements define the default bullets for the document. These elements are named dABullet0 , dABullet1 , dABullet2 , dABullet3 , and dABullet4 .

## dABullet0

Table 169. Bullet Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| CharacterType     | UnicodeOnly |
| CharacterValue    | 8226 |

## Bullet Properties Represented as Elements

| ElementName        | Value |
| ------------------ | --------- |
| BulletsFont        | $ID/ |
| BulletsFontStyle   | $ID/ |

## dABullet1

## Table 170. Bullet Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| CharacterType     | UnicodeOnly |
| CharacterValue    | 42 |

Table 171. Bullet Properties Represented as Elements

| ElementName        | Value |
| ------------------ | --------- |
| BulletsFont        | $ID/ |
| BulletsFontStyle   | $ID/ |

## dABullet2

Table 172. Bullet Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ------------- |
| CharacterType     | UnicodeOnly |
| CharacterValue    | 9674 |

## Table 173. Bullet Properties Represented as Elements

| ElementName        | Value |
| ------------------ | --------- |
| BulletsFont        | $ID/ |
| BulletsFontStyle   | $ID/ |

## dABullet3

## Table 174. Bullet Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ----------------- |
| CharacterType     | UnicodeWithFont |
| CharacterValue    | 187 |

## Table 175. Bullet Properties Represented as Elements

| ElementName        | Value |
| ------------------ | ------------- |
| BulletsFont        | Myriad Pro |
| BulletsFontStyle   | $ID/Regular |

## dABullet4

## Table 176. Bullet Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | --------------- |
| CharacterType     | GlyphWithFont |
| CharacterValue    | 503 |

## Table 177. Bullet Properties Represented as Elements

| ElementName        | Value |
| ------------------ | ------------- |
| BulletsFont        | Minion Pro |
| BulletsFontStyle   | $ID/Regular |

## 1.1.44 Assignment

The <Assignment> element defines the default assignment used in the document.

## Table 178. Assignment Properties Represented as Attributes

| AttributeName     | Value |
| ----------------- | ---------------------- |
| Name              | $ID/UnassignedInCopy |
| UserName          | $ID/ |

| AttributeName             | Value |
| ------------------------- | ----------------- |
| ExportOptions             | AssignedSpreads |
| IncludeLinksWhenPackage   | true |
| FilePath                  | $ID/ |

Table 179. Assignment Properties Represented as Elements

| ElementName     | Value |
| --------------- | --------- |
| FrameColor      | Nothing |


## 1.1 Defaults Example Files

We've provided a set of example files demonstrating further details of InDesign's IDML defaults. the following sections explain the purpose of each file.

## BlankFile.idml

Provides defaults for optional attributes for various document settings. Overlaps with the defaults file but does have some unique items that are not contained in the defaults file.

## PageItems.idml

Provides defaults for optional attributes for page item elements.

## Text.idml

Provides defaults for optional attributes for elements related to text, tables, table of contents, index, hyperlinks, variables, cross-references, InCopy stories and assignments. Non-roman text features are not included here and should be looked for in Misc.idml.

## RID.idml

Provides defaults for optional attributes related to Rich Interactive Documents such as amimations, for AnimationSetting, TimingSetting, NavigationPoint, various Behavior.

## Misc.idml

Provides defaults related to composite fonts, kinsoku table, mojikumi table, data merge, XML elements, preflight rules etc.