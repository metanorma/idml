## Appendix E. Update List of IDML 8.0

This appendix describes changes to the structure of IDML files and the IDML schema made for Adobe InDesign CS6. These changes appear as new objects (XML elements in the IDML file) and new properties (attributes, in the XML of the IDML file itself) on existing objects. The overall structure of the IDML document (that is, the contents of the IDML zip archive) has not changed, and remains as documented in section 8, "IDML Document Structure" above.

## 1.1 New Elements

## 1.1.1 LinkedPageItemOption

The LinkedPageItemOption element has been added as a child element to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element (see "TextFrames" on page 127), <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> element (see "Multi-State Object" on page 149). This element is the link options for a linked Page Item.

## 1.1.2 HtmlItem

The HtmlItem element has been added as a child element to the <Oval> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <Polygon> element and <Group> element. This element is the embedded HTML item.

## 1.1.3 ParaStyleMapping

The ParaStyleMapping element has been added as child element to the <Application> element, <Document> element (see "designmap.xml" on page 44) and <Story script> element. This element is a para style mapping.

## 1.1.4 CharStyleMapping

The CharStyleMapping element has been added as child element to the <Application> element, <Document> element (see "designmap.xml" on page 44)S and <Story script> element. This element is a char style mapping.

## 1.1.5 TableStyleMapping

The TableStyleMapping element has been added as child element to the <Application> element, <Document> element (see "designmap.xml" on page 44) and <Story script> element. This element is a table style mapping.

## 1.1.6 CellStyleMapping

The CellStyleMapping element has been added as child element to the <Application> element, <Document> element (see "designmap.xml" on page 44) and <Story script> element. This element is a cell style mapping.

## 1.1.7 CheckBox

The CheckBox element has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.8 ComboBox

The ComboBox element has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.9 ListBox

The ListBox element has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.10 RadioButton

The RadioButtonelement has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.11 TextBox

The TextBox element has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.12 SignatureField

The SignatureField element has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.13 Pumpkin

The Pumpkin element has been added as a child element to the <Spread> element (see "Spreads and Master Spreads" on page 87), <Oval> element and <Rectangle> element (see "Graphics" on page 91).

## 1.1.14 ObjectExportOption

The ObjectExportOption element has been added as a child element to the <TextFrame> element (see "TextFrames" on page 127). This element is the export options of its parent element.

## 1.1.15 SubmitFormBehavior

The SubmitFormBehavior element has been added as a child element to the <Button> element (see "Buttons" on page 141). This element is a behavior object that submits the document.

## 1.1.16 ClearFormBehavior

The ClearFormBehavior element has been added as a child element to the <Button> element (see "Buttons" on page 141). This element is a behavior object that clears the form fields in the document.

## 1.1.17 PrintFormBehavior

The PrintFormBehavior element has been added as a child element to the <Button> element (see "Buttons" on page 141). This element is a behavior object that triggers print for the document.


## 1.2 New Attributes

## 1.2.1 ApplyStyleMappings

The ApplyStyleMappings attribute has been added to the <linkedStoryOption> elements. If this attribute is true, style mappings will be applied during linked story creation or update.

## 1.2.2 AlternateLayoutLength

The AlternateLayoutLength attribute has been added to the <Section> elements (see "Section" on page 69). This attribute is the number of pages in the alternate layout section.

## 1.2.3 AlternateLayout

The AlternateLayout attribute has been added to the <Section> elements (see "Section" on page 69). This attribute is the alternate layout name for a set of pages.

## 1.2.4 Pagination

The Pagination attribute has been added to the <Section> elements (see "Section" on page 69). This attribute is the pagination option for this section for adding and removing pages in HTML5.

## 1.2.5 PaginationMaster

The PaginationMaster attribute has been added to the <Section> elements (see "Section" on page 69). This attribute is the master to apply when pages are added in HTML5.

## 1.2.6 ExternalStyleSheets

The ExternalStyleSheets attribute has been added to the <EPubExportPreference> element and <HTMLExportPreference> element. This attribute is the file path of external cascading style sheets.

## 1.2.7 Javascripts

The Javascripts attribute has been added to the <EPubExportPreference> element and <HTMLExportPreference> element. This attribute is the file path of external javascripts.

## 1.2.8 UseFlexibleColumnWidth

The UseFlexibleColumnWidth attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). If this attribute is true, maintains column width between a min and max range when the TextFrame is resized. If this attribute is false, causes columns to resize when the TextFrame is resized.

Note: When true, resizing the frame can change the number of columns in the frame.

## 1.2.9 TextColumnMaxWidth

The UseFlexibleColumnWidth attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). This attribute is the maximum column width of the columns in the TextFrame. Use 0 to indicate no upper limit.

## 1.2.10 AutoSizeType

The AutoSizeType attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). This attribute is the dimension for auto sizing of TextFrame based on text content.

## 1.2.11 AutoSizingReferencePoint

The AutoSizingReferencePoint attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). This attribute is the reference point for auto sizing of TextFrame based on text content.

## 1.2.12 UseMinimumHeightForAutoSizing

The UseMinimumHeightForAutoSizing attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). If this attribute is true, while auto sizing it is made sure that the TextFrame height is always more than or equal to given minimum height.

## 1.2.13 MinimumHeightForAutoSizing

The MinimumHeightForAutoSizing attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). This attribute is the minimum height of the TextFrame, that should be considered while auto sizing.

## 1.2.14 UseMinimumWidthForAutoSizing

The UseMinimumWidthForAutoSizing attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). If this attribute is true, while auto sizing it is made sure that the TextFrame width is always more than or equal to given minimum width.

## 1.2.15 MinimumWidthForAutoSizing

The MinimumWidthForAutoSizing attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). This attribute is the minimum width of the TextFrame, that should be considered while auto sizing.

## 1.2.16 UseNoLineBreaksForAutoSizing

The UseNoLineBreaksForAutoSizing attribute has been added to the <TextFramePreference> element (see "TextFrame  Preference" on page 132). If this attribute is true, line breaks are not introduced after auto sizing.

## 1.2.17 QuoteCharactersRotatedInVertical

The QuoteCharactersRotatedInVertical attribute has been added to the <TextPreference> element (see "Text  Preference" on page 299). If this attribute is true, Japanese composer treats quotes as half width and rotates them in vertical.

## 1.2.18 ParagraphKashidaWidth

The ParagraphKashidaWidth attribute has been added to the <TextDefault> element (see "TextDefault" on page 301), <ParagraphStyle> element (see "Paragraph  Styles" on page 345), <Story> (see "Story Schema" on page 186) element, <ParagraphStyleRange> element (see "Text Range Elements" on page 196), <CharacterStyleRange> element (see "CharacterStyleRange" on page 205). This attribute is the Paragraph kashida width. 0 is none, 1 is short, 2 is medium, 3 is long.

## 1.2.19 CreatePrimaryTextFrame

The CreatePrimaryTextFrame attribute has been added to the <DocumentPreference> element (see "Document  Preference" on page 319). If this attribute is true, the document A-master has primary TextFrames when a new document is created.

## 1.2.20 EnableTextFrameAutoSizingOptions

The EnableTextFrameAutoSizingOptions attribute has been added to the <ObjectStyle> element (see "Object Styles" on page 377). If this attribute is true, the object style will apply auto-sizing TextFrame options.

## 1.2.21 GuideType

The GuideType attribute has been added to the <Guide> element (see "Guides" on page 160). This attribute is the type of the guide.

## 1.2.22 GuideZone

The GuideZone attribute has been added to the <Guide> element (see "Guides" on page 160). This attribute is zone of the guide.

## 1.2.23 LinkResourceId

The LinkResourceId attribute has been added to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element, <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> (see "Multi-State Object" on page 149) element. This attribute is the destination unique id for shared content link.

## 1.2.24 ParentInterfaceChangeCount

The ParentInterfaceChangeCount attribute has been added to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element, <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> element (see "Multi-State Object" on page 149). This attribute is Parent Interface Change Count.

## 1.2.25 TargetInterfaceChangeCount

The TargetInterfaceChangeCount attribute has been added to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported

Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element, <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> element (see "Multi-State Object" on page 149). This attribute is Target Interface Change Count.

## 1.2.26 LastUpdatedInterfaceChangeCount

The LastUpdatedInterfaceChangeCount attribute has been added to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element, <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> element (see "Multi-State Object" on page 149). This attribute is Last Updated Interface Change Count.

## 1.2.27 HorizontalLayoutConstraints

The HorizontalLayoutConstraints attribute has been added to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element, <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> element (see "Multi-State Object" on page 149). This attribute is the left margin, width, and right margin constraints this item is subject to when using the object-based layout rule.

## 1.2.28 VerticalLayoutConstraints

The VerticalLayoutConstraints attribute has been added to the <Oval> element, <Sound > element, <Movie> element, <Graphic> element (see "Spline Item Containing an Imported Graphic" on page 120), <Image> element, <EPS> element, <WMF> element, <PICT> element, <PDF> element, <ImportedPage> element, <Rectangle> element (see "Graphics" on page 91), <GraphicLine> element, <TextFrame> element, <Polygon> element, <Group> element, <EPSText> element, <FormField> element, <Button> element (see "Buttons" on page 141), <MultiStateObject> element (see "Multi-State Object" on page 149). This attribute is the top margin, height, and bottom margin constraints this item is subject to when using the object-based layout rule.

## 1.2.29 CustomLayout

The CustomLayout attribute has been added to the <ObjectExportOption> element. If this attribute is true, custom layout is enabled for object.

## 1.2.30 CustomLayoutType

The CustomLayoutType attribute has been added to the <ObjectExportOption> element. This attribute is the custom Layout settings to be used for object.

## 1.2.31 PrintableInPDF

The PrintableInPDF attribute has been added to the <Button> element (see "Buttons" on page 141). If this attribute is true, the form field/push button is printable in the exported PDF.

## 1.2.32 HiddenUntilTriggered

The HiddenUntilTriggered attribute has been added to the <Button> element (see "Buttons" on page 141). If this attribute is true, the form field/push button is hidden until triggered in the exported PDF.

## 1.2.33 AppliedAlternateLayout

The AppliedAlternateLayout attribute has been added to the <Page> element (see "Pages" on page 156). This attribute is the alternate layout section to which the page belongs.

## 1.2.34 LayoutRule

The LayoutRule attribute has been added to the <Page> element (see "Pages" on page 156). This attribute is the layout rule.

## 1.2.35 SnapshotBlendingMode

The SnapshotBlendingMode attribute has been added to the <Page> element (see "Pages" on page 156). This attribute is the snapshot blending mode.

## 1.2.36 OptionalPage

The OptionalPage attribute has been added to the <Page> element (see "Pages" on page 156). This attribute is the optional page for HTML5 pagination.