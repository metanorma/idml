## 10.7 Preferences

IDML files can contain a number of preferences elements that control both document preferences and various default values. In an IDML package, preferences elements are found in the `Preferences.xml` file in the Resources folder.

Many of these elements no effect on the interpretation of the IDML file, but do have an effect on the user interface settings in the In  Design document that results when a user opens the IDML file. <DataMerge> , <LayoutAdjustmentPreference> , <XMLImportPreference> , and <ExportForWebPreference> , are examples of preferences that do not affect the reconstruction of elements (page items or text, for example) in an IDML file. By contrast, some of the preferences, such as <TextDefault> and <AnchoredObjectDefault> can have a very large effect on the formatting of objects specified in the IDML package.

In general, when you construct a page item (in a <Spread> element) or text (in a <Story> element), you can choose to omit many of the formatting options that can be applied to the element. When you do this, In  Design will apply default values to the object as it opens the IDML package. Most of these default values are stored in preferences elements.

This means that you can choose an approach that works best for you. You can achieve complete control by fully-specifying every attribute and element of every element you add to an IDML document, or you can rely on defaults and preferences for common values and specify only a minimum-this can make your IDML file smaller and easier to read. Or you can mix and match these approaches in an IDML file.

When you specify a preference in the IDML file, it will override the corresponding application preference for this document. If you do not specify a preference, InDesign will apply the default value from the IDML defaults file.

**Schema Example 107. Preferences\_File**

```rnc
Preferences_File = element idPkg:Preferences { attribute DOMVersion { "7.0" }, ( DataMerge_Object?& DataMergeOption_Object?& LayoutAdjustmentPreference_Object?& EPubExportPreference_Object?& HTMLExportPreference_Object?& XMLPreference_Object?& XMLImportPreference_Object?& XMLExportPreference_Object?& ExportForWebPreference_Object?& TransparencyPreference_Object?& TransparencyDefaultContainerObject_Object?& TextFramePreference_Object?& TextPreference_Object?& TextDefault_Object?& DictionaryPreference_Object?& StoryPreference_Object?& AnchoredObjectDefault_Object?& AnchoredObjectSetting_Object?& BaselineFrameGridOption_Object?& FootnoteOption_Object?&
TextWrapPreference_Object?& DocumentPreference_Object?& GridPreference_Object?& GuidePreference_Object?& MarginPreference_Object?& PasteboardPreference_Object?& ViewPreference_Object?& PrintPreference_Object?& PrintBookletOption_Object?& PrintBookletPrintPreference_Object?& IndexOptions_Object?& IndexHeaderSetting_Object?& PageItemDefault_Object?& FrameFittingOption_Object?& ButtonPreference_Object?& TinDocumentDataObject_Object?& LayoutGridDataInformation_Object?& StoryGridDataInformation_Object?& CjkGridPreference_Object?& MojikumiUiPreference_Object?& ChapterNumberPreference_Object? ) }
```

## 10.7.1 DataMerge

The <DataMerge> element stores the settings that are be used by the DataMerge feature of InDesign. This preference object does not have any effect on the interpretation of layout elements (page items or stories, for example) in the IDML file.

**Schema Example 108. DataMerge**

```rnc
DataMerge_Object = element DataMerge { attribute DataSourceFileType { DataSourceType_EnumValue }?, attribute DataSourceFile { xsd:string }?, ( DataMergeField_Object* ) }
```

**Table 133**: DataMerge Properties Represented as Attributes

| Name                   | Type                        | Req     | Description |
| ---------------------- | --------------------------- | ------- | -------------------------------------------------------------------------------- |
| DataSourceFile         | string                      | no      | The file path to the data file. |
| DataSourceFileType   | DataSourceType_EnumValue   | no      | The separator type used in the data file. Use CommaSeparated or TabDelimited. |

**Schema Example 109. DataMergeField**

```rnc
DataMergeField_Object = element DataMergeField { attribute Self { xsd:string }, attribute FieldName { xsd:string }? }
```

**Table 134**: DataMergeField Properties Represented as Attributes

| Name        | Type     | Req     | Description |
| ----------- | -------- | ------- | ------------------------ |
| FieldName   | string   | yes     | The name of the field. |

## 10.7.2 DataMergeOption

The <DataMergeOption> element stores the preferences for the Data  Merge feature of In  Design.

**Schema Example 110. DataMergeOption**

```
DataMergeOption_Object = element DataMergeOption { attribute FittingOption { Fitting_EnumValue }?, attribute CenterImage { xsd:boolean }?, attribute LinkImages { xsd:boolean }?, attribute RemoveBlankLines { xsd:boolean }?, attribute CreateNewDocument { xsd:boolean }?, attribute DocumentSize { xsd:int }? }
```

**Table 135**: DataMergeOption Properties Represented as Attributes

| Name                | Type                | Req     | Description |
| ------------------- | ------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| CenterImage         | boolean             | no      | If true, centers the image in the frame; preserves the frame size as well as content size and pro- portions. Note: If the content is larger than the frame, content around the edges is obscured by the bounding box of the frame. |
| CreateNewDocument   | boolean             | no      | If true, creates a new document when records are merged. |
| DocumentSize        | int                 | no      | The maximum number of pages per document. |
| FittingOption       | Fitting_EnumValue   | no      | Instructions for fitting content in a frame. Use None , ContentToFrame , Proportionally , or FillProportionally. |
| LinkImages          | boolean             | no      | If true, links images to the target document. If false, embeds images in the target document. |
| RemoveBlankLines    | boolean             | no      | If true, removes blank lines caused by empty fields. |

## 10.7.3 LayoutAdjustmentPreference

The <LayoutAdjustmentPreference> element stores the settings that are be used by the Layout Adjustment feature of In  Design. This preference object does not have any effect on the interpretation of layout elements (page items or stories, for example) in the IDML file.

**Schema Example 111. LayoutAdjustmentPreference**

```
LayoutAdjustmentPreference_Object = element LayoutAdjustmentPreference { attribute EnableLayoutAdjustment { xsd:boolean }?, attribute SnapZone { xsd:double {minInclusive="0" maxInclusive="12"} }?, attribute AllowGraphicsToResize { xsd:boolean }?, attribute AllowRulerGuidesToMove { xsd:boolean }?, attribute IgnoreRulerGuideAlignments { xsd:boolean }?, attribute IgnoreObjectOrLayerLocks { xsd:boolean }? }
```

**Table 136**: LayoutAdjustmentPreference Properties Represented as Attributes

| Name                       | Type      | Req     | Description |
| ------------------------------ | --------- | ------- | ------------------------------------------------------------------- |
| AllowGraphicsToResize        | boolean   | no      | If true, allows graphics to be resized. |
| AllowRulerGuidesToMove       | boolean   | no      | If true, allows ruler guides to move. |
| EnableLayoutAdjustment       | boolean   | no      | If true, layout adjustment is enabled. |
| IgnoreObjectOrLayerLocks     | boolean   | no      | If true, ignores object or layer locks. |
| IgnoreRulerGuideAlignments   | boolean   | no      | If true, ignores ruler guide alignments. |
| SnapZone                       | double    | no      | The range within which an object snaps to guides. Range: 0 to 12. |

## 10.7.4 EPubExportPreference

**Schema Example 112. EPubExportPreference**

```
EPubExportPreference_Object = element EPubExportPreference { attribute IncludeDocumentMetadata { xsd:boolean }?, attribute EpubPublisher { xsd:string }?, attribute Id { xsd:string }?, attribute ExportOrder { ExportOrder_EnumValue }?, attribute EpubCover { EpubCover_EnumValue }?, attribute CoverImageFile { xsd:string }?, attribute BulletExportOption { BulletListExportOption_EnumValue }?, attribute NumberedListExportOption { NumberedListExportOption_EnumValue }?, attribute LeftMargin { xsd:double }?, attribute RightMargin { xsd:double }?, attribute TopMargin { xsd:double }?, attribute BottomMargin { xsd:double }?, attribute MarginUnit { SpaceUnitType_EnumValue }?, attribute ViewDocumentAfterExport { xsd:boolean }?, attribute ImageExportResolution { ImageResolution_EnumValue }?, attribute CustomImageSizeOption { ImageSizeOption_EnumValue }?, attribute PreserveLayoutAppearence { xsd:boolean }?, attribute ImageAlignment { ImageAlignmentType_EnumValue }?, attribute ImageSpaceBefore { xsd:double {minInclusive="0" maxInclusive="8640"} }?, attribute ImageSpaceAfter { xsd:double {minInclusive="0" maxInclusive="8640"} }?, attribute SpaceUnit { SpaceUnitType_EnumValue }?, attribute ApplyImageAlignmentToAnchoredObjectSettings { xsd:boolean }?, attribute UseImagePageBreak { xsd:boolean }?, attribute ImagePageBreak { ImagePageBreakType_EnumValue }?, attribute ImageConversion { ImageConversion_EnumValue }?, attribute GIFOptionsPalette { GIFOptionsPalette_EnumValue }?, attribute GIFOptionsInterlaced { xsd:boolean }?, attribute JPEGOptionsQuality { JPEGOptionsQuality_EnumValue }?, attribute JPEGOptionsFormat { JPEGOptionsFormat_EnumValue }?, attribute Level { xsd:int }?, attribute IgnoreObjectConversionSettings { xsd:boolean }?, attribute Format { xsd:boolean }?, attribute UseTocStyle { xsd:boolean }?, attribute TocStyleName { xsd:string }?, attribute BreakDocument { xsd:boolean }?, attribute ParagraphStyleName { xsd:string }?, attribute FootnoteFollowParagraph { xsd:boolean }?, attribute StripSoftReturn { xsd:boolean }?, attribute CSSExportOption { StyleSheetExportOption_EnumValue }?, attribute IncludeCSSDefinition { xsd:boolean }?, attribute PreserveLocalOverride { xsd:boolean }?, attribute EmbedFont { xsd:boolean }?, attribute ExternalCSSPath { xsd:string }? }
```

**Table 137**: EPubExportPreference Properties Represented as Attributes

| Name                                              | Type                                    | Req     | Description |
| ----------------------------                      | --------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| IncludeDocumentMetadata                         | boolean                                 | no      | If true, output document metadata into the exported ePub. |
| EpubPublisher                                     | string                                  | no      | The name of the ePub publisher. |
| ExportOrder                                       | ExportOrder_EnumValue                  | no      | The order in which to export the ePub. Can be ArticlePanelOrder , LayoutOrder , or XmlStructureOrder. |
| EpubCover                                         | EpubCover_EnumValue                    | no      | The ePub cover option. Can be ExternalImage , FirstPage , or None. |
| CoverImageFile                                    | string                                  | no      | The file path to the external image (if EpubCover is ExternalImage ). |
| BulletExportOption                              | BulletListExportOption_EnumValue      | no      | Defines the method used to export bullets to the ePub. Can be AsText (convert the bullets to text characters) or UnorderedList (convert the bul- lets to an HTMLunordered list). |
| NumberedListExportOption                        | NumberedListExportOption_EnumValue   | no      | Defines the method used to export numbered lists to the ePub. Can be AsText (convert the numbers to text characters), OrderedList (convert the list to an HTMLordered list), or StaticOrderedList (convert the list to an HTML static ordered list). |
| LeftMargin                                        | double                                  | no      | Left margin of the ePub (in units defined by the MarginUnit attribute). |
| RightMargin                                       | double                                  | no      | Right margin of the ePub (in units defined by the MarginUnit attribute). |
| TopMargin                                         | double                                  | no      | Top margin of the ePub (in units defined by the MarginUnit attribute). |
| BottomMargin                                      | double                                  | no      | Bottom margin of the ePub (in units defined by the MarginUnit attribute). |
| MarginUnit                                        | SpaceUnitType_EnumValue                | no      | The measurement units to use for the margins of the exported ePub. Can be CssEm or CssPixel. |
| ViewDocumentAfterExport                         | boolean                                 | no      | If true, display the exported ePub after the export process is complete. |
| ImageExportResolution                           | ImageResolution_EnumValue              | no      | Sets the resolution of images in the exported ePub. Can be Ppi150 , Ppi300 , Ppi72 , or Ppi96. |
| CustomImageSizeOption                           | ImageSizeOption_EnumValue              | no      | Sets the custom image size. Can be SizeFixed or SizeRelativeToPageWidth. |
| PreserveLayoutAppearence                        | boolean                                 | no      | If true, format image based on layout appearance. |
| ImageAlignment                                    | ImageAlignmentType_EnumValue          | no      | Alignment applied to images. Can be AlignCenter , AlignRight , or AlignLeft. |
| ImageSpaceBefore                                  | double (0 to 8640)                     | no      | Space before applied to images (in units defined by the SpaceUnit attribute). |
| ImageSpaceAfter                                   | double (0 to 8640)                     | no      | Space after applied to images (in units defined by the SpaceUnit attribute). |
| SpaceUnit                                         | SpaceUnitType_EnumValue                | no      | The measurement units to use in the exported ePub. Can be CssEm or CssPixel. |
| ApplyImageAlignmentToAnchoredObjectSettings | boolean                                 | no      | If true, apply image alignment to anchored object settings. |
| UseImagePageBreak                                 | boolean                                 | no      | If true, image page break settings will be used in objects. |
| ImagePageBreak                                    | ImagePageBreakType_EnumValue          | no      | Image page break settings to be used with objects (when UseImagePageBreak is true). Can be PageBreakBefore , PageBreakAfter , or PageBreakBeforeAndAfter. |
| ImageConversion                                   | ImageConversion_EnumValue              | no      | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic , Gif , Jpeg , or Png. |
| GIFOptionsPalette                                 | GIFOptionsPalette_EnumValue           | no      | The color palette for GIF conversion. Note: Not valid when ImageConversion is Jpeg. Can be AdaptivePalette , MacintoshPalette , WebPalette , or WindowsPalette. |
| GIFOptionsInterlaced                            | boolean                                 | no      | If true, use interlaced GIF (valid when ImageConversion is Gif ). |
| JPEGOptionsQuality                              | JPEGOptionsQuality_EnumValue          | no      | The quality of converted JPEG images. Note: Not valid when image conversion is Gif. Can be High , Low , Maximum , or Minimum. |
| JPEGOptionsFormat                                 | JPEGOptionsFormat_EnumValue           | no      | The formatting method for converted JPEG images. Note: Not valid when image conver- sion is Gif. Can be BaselineEncoding or ProgressiveEncoding. |
| Level                                             | int                                     | no      | The PNG compression level (when ImageConversion is Png ). |
| IgnoreObjectConversionSettings                | boolean                                 | no      | If true, ignore object level image conversion settings. |
| Format                                            | boolean                                 | no      | If true, export ePub in XHTMLformat. Other- wise, export using the DTBook format. |
| UseTocStyle                                       | boolean                                 | no      | If true, use InDesign TOC style to generate the ePub TOC. |
| TocStyleName                                      | string                                  | no      | The name of TOC style to use to generate the ePub TOC (when UseTocStyle is true). |
| BreakDocument                                     | boolean                                 | no      | If true, break the InDesign document into smaller pieces when generating the ePub. |
| ParagraphStyleName                              | string                                  | no      | The name of paragraph style to use in break- ing the InDesign document into smaller pieces (when BreakDocument is true). |
| FootnoteFollowParagraph                         | boolean                                 | no      | If true, output footnotes immediately after the paragraph containing the footnote reference. |
| StripSoftReturn                                   | boolean                                 | no      | If true, strip soft returns on export. |
| CSSExportOption                                   | StyleSheetExportOption_EnumValue      | no      | The cascading style sheet export option. Can be EmbeddedCss , ExternalCss , none , or StyleNameOnly. |
| IncludeCSSDefinition                            | boolean                                 | no      | If true, include the CSS definitions in the exported ePub (used when CSSExportOption is EmbeddedCss ). |
| PreserveLocalOverride                           | boolean                                 | no      | If true, export the local style overrides. |
| EmbedFont                                         | boolean                                 | no      | If true, embed fonts in the exported ePub. |
| ExternalCSSPath                                   | string                                  | no      | The path to the external CSS stylesheet (when CSSExportOption is ExternalCss ). |

**IDML Example 77. EPubExportPreference**

```xml
<EPubExportPreference IncludeDocumentMetadata="true" EpubPublisher="" Id="" ExportOrder="LayoutOrder" EpubCover="FirstPage" CoverImageFile="" BulletExportOption="UnorderedList" NumberedListExportOption="OrderedList" LeftMargin="0.5" RightMargin="0.5" TopMargin="0.5" BottomMargin="0.5" MarginUnit="CssEm" ViewDocumentAfterExport="true" ImageExportResolution="Ppi150" CustomImageSizeOption="SizeFixed" PreserveLayoutAppearence="true" ImageAlignment="AlignCenter" ImageSpaceBefore="0" ImageSpaceAfter="0" SpaceUnit="CssEm" ApplyImageAlignmentToAnchoredObjectSettings="false" UseImagePageBreak="false" ImagePageBreak="PageBreakBefore" ImageConversion="Automatic"  GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="false" JPEGOptionsQuality="High" JPEGOptionsFormat="ProgressiveEncoding" Level="5" IgnoreObjectConversionSettings="false" Format="true" UseTocStyle="false" TocStyleName="$ID/DefaultTOCStyleName" BreakDocument="false" ParagraphStyleName="$ID/NormalParagraphStyle" FootnoteFollowParagraph="false" StripSoftReturn="false" CSSExportOption="EmbeddedCSS" IncludeCSSDefinition="true" PreserveLocalOverride="true" EmbedFont="true" ExternalCSSPath="template.css"/>
```

## 10.7.5 HTMLExportPreference

**Schema Example 113. HTMLExportPreference**

```rnc
HTMLExportPreference_Object = element HTMLExportPreference { attribute ExportSelection { xsd:boolean }?, attribute ExportOrder { ExportOrder_EnumValue }?, attribute BulletExportOption { BulletListExportOption_EnumValue }?, attribute NumberedListExportOption { NumberedListExportOption_EnumValue }?, attribute LeftMargin { xsd:double }?, attribute RightMargin { xsd:double }?, attribute TopMargin { xsd:double }?, attribute BottomMargin { xsd:double }?, attribute MarginUnit { SpaceUnitType_EnumValue }?, attribute ViewDocumentAfterExport { xsd:boolean }?, attribute ImageExportOption { ImageExportOption_EnumValue }?, attribute ImageExportResolution { ImageResolution_EnumValue }?, attribute CustomImageSizeOption { ImageSizeOption_EnumValue }?, attribute PreserveLayoutAppearence { xsd:boolean }?, attribute ImageAlignment { ImageAlignmentType_EnumValue }?, attribute ImageSpaceBefore { xsd:double {minInclusive="0" maxInclusive="8640"} }?, attribute ImageSpaceAfter { xsd:double {minInclusive="0" maxInclusive="8640"} }?, attribute SpaceUnit { SpaceUnitType_EnumValue }?, attribute ApplyImageAlignmentToAnchoredObjectSettings { xsd:boolean }?, attribute ImageConversion { ImageConversion_EnumValue }?, attribute GIFOptionsPalette { GIFOptionsPalette_EnumValue }?, attribute GIFOptionsInterlaced { xsd:boolean }?, attribute JPEGOptionsQuality { JPEGOptionsQuality_EnumValue }?, attribute JPEGOptionsFormat { JPEGOptionsFormat_EnumValue }?, attribute Level { xsd:int }?, attribute IgnoreObjectConversionSettings { xsd:boolean }?, attribute ServerPath { xsd:string }?, attribute ImageExtension { xsd:string }?, attribute CSSExportOption { StyleSheetExportOption_EnumValue }?, attribute IncludeCSSDefinition { xsd:boolean }?, attribute PreserveLocalOverride { xsd:boolean }?, attribute ExternalCSSPath { xsd:string }?, attribute LinkToJavascript { xsd:boolean }?, attribute JavascriptURL { xsd:string }? }
```

**Table 138**: HTMLExportPreference Properties Represented as Attributes

| Name              | Type      | Req     | Description |
| ----------------- | --------- | ------- | -------------------------------- |
| ExportSelection   | boolean   | no      | If true, export the selection. |

| Name                                            | Type                                    | Req     | Description |
| ----------------------------                    | --------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ExportOrder                                     | ExportOrder_EnumValue                  | no      | The order in which to export HTML. Can be ArticlePanelOrder , LayoutOrder , or XmlStructureOrder. |
| BulletExportOption                            | BulletListExportOption_EnumValue      | no      | Defines the method used to export bullets to the HTML. Can be AsText (convert the bullets to text characters) or UnorderedList (convert the bullets to an HTMLunordered list). |
| NumberedListExportOption                      | NumberedListExportOption_EnumValue   | no      | Defines the method used to export numbered lists to HTML. Can be AsText (convert the numbers to text characters), OrderedList (convert the list to an HTMLordered list), or StaticOrderedList (convert the list to an HTML static ordered list). |
| LeftMargin                                      | double                                  | no      | Left margin of the HTML(in units defined by the MarginUnit attribute). |
| RightMargin                                     | double                                  | no      | Right margin of the HTML(in units defined by the MarginUnit attribute). |
| TopMargin                                       | double                                  | no      | Top margin of the HTML(in units defined by the MarginUnit attribute). |
| BottomMargin                                    | double                                  | no      | Bottom margin of the HTML(in units defined by the MarginUnit attribute). |
| MarginUnit                                      | SpaceUnitType_EnumValue                | no      | The measurement units to use for the mar- gins of the exported HTML. Can be CssEm or CssPixel. |
| ViewDocumentAfterExport                       | boolean                                 | no      | If true, display the exported HTMLafter the export process is complete. |
| ImageExportOption                               | ImageExportOption_EnumValue           | no      | Controls the method used to export images. Can be LinkToServer , OptimizedImage , or OriginalImage. |
| ImageExportResolution                         | ImageResolution_EnumValue              | no      | Sets the resolution of images in the exported HTML. Can be Ppi150 , Ppi300 , Ppi72 , or Ppi96. |
| CustomImageSizeOption                         | ImageSizeOption_EnumValue              | no      | Sets the custom image size. Can be SizeFixed or SizeRelativeToPageWidth. |
| PreserveLayoutAppearence                      | boolean                                 | no      | If true, format image based on layout appearance. |
| ImageAlignment                                  | ImageAlignmentType_EnumValue          | no      | Alignment applied to images. Can be AlignCenter , AlignRight , or AlignLeft. |
| ImageSpaceBefore                                | double (0 to 8640)                      | no      | Space before applied to images (in units defined by the SpaceUnit attribute). |
| ImageSpaceAfter                                 | double (0 to 8640)                      | no      | Space after applied to images (in units defined by the SpaceUnit attribute). |
| SpaceUnit                                       | SpaceUnitType_EnumValue                | no      | The measurement units to use in the exported HTML. Can be CssEm or CssPixel. |
| ApplyImageAlignmentToAnchoredObjectSettings | boolean                                 | no      | If true, apply image alignment to anchored object settings. |
| ImageConversion                                 | ImageConversion_EnumValue              | no      | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic , Gif , Jpeg , or Png. |
| GIFOptionsPalette                               | GIFOptionsPalette_EnumValue           | no      | The color palette for GIF conversion. Note: Not valid when ImageConversion is Jpeg. Can be AdaptivePalette , MacintoshPalette , WebPalette , or WindowsPalette. |
| GIFOptionsInterlaced                          | boolean                                 | no      | If true, use interlaced GIF (valid when ImageConversion is Gif ). |
| JPEGOptionsQuality                            | JPEGOptionsQuality_EnumValue          | no      | The quality of converted JPEG images. Note: Not valid when image conversion is Gif. Can be High , Low , Maximum , or Minimum. |
| JPEGOptionsFormat                               | JPEGOptionsFormat_EnumValue           | no      | The formatting method for converted JPEG images. Note: Not valid when image conver- sion is Gif. Can be BaselineEncoding or ProgressiveEncoding. |
| Level                                           | int                                     | no      | The PNG compression level (when ImageConversion is Png ). |
| IgnoreObjectConversionSettings              | boolean                                 | no      | If true, ignore object level image conversion settings. |
| ServerPath                                      | string                                  | no      | The server path for exported images (when ImageExportOption is LinkToServer ). |
| ImageExtension                                  | string                                  | no      | The extension for exported images (when ImageExportOption is LinkToServer ). |
| CSSExportOption                                 | StyleSheetExportOption_EnumValue      | no      | The cascading style sheet export option. Can be EmbeddedCss , ExternalCss , none , or StyleNameOnly. |
| IncludeCSSDefinition                          | boolean                                 | no      | If true, include the CSS definitions in the export- ed HTML(used when CSSExportOption is EmbeddedCss ). |
| PreserveLocalOverride                         | boolean                                 | no      | If true, export the local style overrides. |
| ExternalCSSPath                                 | string                                  | no      | The path to the external CSS stylesheet (when CSSExportOption is ExternalCss ). |
| LinkToJavascript                                | boolean                                 | no      | If true, link to JavaScript on the server. |
| JavascriptURL                                   | string                                  | no      | The path to the server containing the JavaScript associated with the exported HTML(when LinkToJavaScript is true ). |

**IDML Example 78. HTMLExportPreference**

```xml
<HTMLExportPreference ExportSelection="true" ExportOrder="LayoutOrder" BulletExportOption="UnorderedList" NumberedListExportOption="OrderedList" LeftMargin="0" RightMargin="0" TopMargin="0" BottomMargin="0" MarginUnit="CssPixel" ViewDocumentAfterExport="true" ImageExportOption="OptimizedImage" ImageExportResolution="Ppi150" CustomImageSizeOption="SizeFixed" PreserveLayoutAppearence="false" ImageAlignment="AlignCenter" ImageSpaceBefore="0" ImageSpaceAfter="0" SpaceUnit="CssEm" ApplyImageAlignmentToAnchoredObjectSettings="false" ImageConversion="Automatic" GIFOptionsPalette="AdaptivePalette" GIFOptionsInterlaced="false" JPEGOptionsQuality="High" JPEGOptionsFormat="ProgressiveEncoding" Level="5" IgnoreObjectConversionSettings="false" ServerPath="" ImageExtension=".jpg" CSSExportOption="EmbeddedCSS" IncludeCSSDefinition="true" PreserveLocalOverride="true" ExternalCSSPath="" LinkToJavascript="false" JavascriptURL=""/>
```

## 10.7.6 XMLImportPreference

The <XMLImportPreference> element stores the settings that are be used by when importing XML into an In  Design document. This preference object does not have any effect on the interpretation of XML elements in the IDML file.

**Schema Example 114. XMLImportPreference**

```
XMLImportPreference_Object = element XMLImportPreferenc{attributeCreateLinkToXML { xsd:boolean }?, attribute RepeatTextElements { xsd:boolean }?, attribute IgnoreUnmatchedIncoming { xsd:boolean }?, attribute ImportTextIntoTables { xsdboolean }?, attribute IgnoreWhitespac{xsd:boolean }?, attribute RemoveUnmatchedExisting { xsd:boolean }?, attribute ImportToSelected { xsd:boolean }?, attribute ImportStyle { XMLImportStyles_EnumValue }?, attribute AllowTransform { xsd:boolean }?, attribute ImportCALSTables { xsd:boolean }?, element Properties { element TransformFilename { (file_type, xsd:string ) | (enum_type, XMLTransformFile_EnumValue ) }?& element TransformParameters { element NameValuePair { NameValuePair_TypeDef }* }? } ? }
```

**Table 139**: XMLImportPreference Properties Represented as Attributes

Name                       |Type                       | Req     |Description |
| --------------------------|---------                  | ------- | ------------------------------------------------------------------------------------------------------------------ |
| AllowTransform              | boolean                    | no      | If true, transforms the XMLusing an XSLT file. |
| CreateLinkToXML             | boolean                    | no      | If true, creates a link to the imported XMLfile. If false, embeds the file. |
| IgnoreUnmatchedIncoming   | boolean                    | no      | If true, ignores elements that do not match the existing structure. Note: Valid only when import style is merge. |
| IgnoreWhitespace            | boolean                    | no      | If true, leaves existing content in place if the matching XMLContent contains only whitespace characters such as a carriage return or a tab character. Note: Valid only when import style is merge. |
| ImportCALSTables            | boolean                    | no      | If true, imports CALS tables as InDesign tables. |
| ImportStyle                 | XMLImportStyles_EnumValue | no      | The style of incorporating imported XMLcon- tent into the document. Can be AppendImport or MergeImport. |
| ImportTextIntoTables      | boolean                    | no      | If true, imports text into tables if tags match placeholder tables and their cells. Note: Valid only when import style is MergeImport. |
| ImportToSelected            | boolean                    | no      | If true, imports into the selected XMLelement. If false, imports at the root element. |
| RemoveUnmatchedExisting   | boolean                    | no      | If true, deletes existing elements or placeholders in the document that do not have matches in the XMLfile. Note: Valid only when import style is MergeImport. |
| RepeatTextElements        | boolean                    | no      | If true, repeating text elements inherit the for- matting applied to placeholder text. Note: Valid only when import style is MergeImport. |

**Table 140**: XMLImportPreference Properties Represented as Elements

Name                   |Type       | Req     |Description |
| ----------------------|---------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TransformFilename       | string     | no      | If true, allow The name of the XSLT file or StylesheetInXML (when the XSLT file is referred to in the XMLdocument). Note: Valid when allow transform is true. |
| TransformParameters   | ListItem   | no      | Stylesheet parameters as a series of ListItem elements containing name/value pairs. |

## 10.7.7 XMLExport  Preference

The <XMLExportPreference> element stores the settings that are be used by when exporting XML into an In  Design document. This preference object does not have any effect on the interpretation of XML elements in the IDML file.

**Schema Example 115. XMLExport  Preference**

```
XMLExportPreference_Object = element XMLExportPreference { attribute ViewAfterExport { xsd:boolean }?, attribute ExportFromSelected { xsd:boolean }?, attribute FileEncoding { XMLFileEncoding_EnumValue }?, attribute Ruby { xsd:boolean }?, attribute ExcludeDtd { xsd:boolean }?, attribute CopyOriginalImages { xsd:boolean }?, attribute CopyOptimizedImages { xsd:boolean }?, attribute CopyFormattedImages { xsd:boolean }?, attribute ImageConversion { ImageConversion_EnumValue }?, attribute GIFOptionsPalette { GIFOptionsPalette_EnumValue }?, attribute GIFOptionsInterlaced { xsd:boolean }?, attribute JPEGOptionsQuality { JPEGOptionsQuality_EnumValue }?, attribute JPEGOptionsFormat { JPEGOptionsFormat_EnumValue }?, attribute AllowTransform { xsd:boolean }?, attribute CharacterReferences { xsd:boolean }?, attribute ExportUntaggedTablesFormat { XMLExportUntaggedTablesFormat_EnumValue }?, element Properties { element PreferredBrowser { (file_type, xsd:string ) | (enum_type, NothingEnum_EnumValue ) }?& element TransformFilename { (file_type, xsd:string ) | (enum_type, XMLTransformFile_EnumValue ) }? } ? }
```

**Table 141**: XMLExportPreference Properties Represented as Attributes

| Name                           | Type                                          | Req     | Description |
| ------------------------------ | --------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AllowTransform                 | boolean                                       | no      | If true, transforms the XMLusing an XSLT file. |
| CharacterReferences          | boolean                                       | no      | If true, replaces special characters with charac- ter references. |
| CopyFormattedImages          | boolean                                       | no      | If true, copies formatted images to the images subfolder. |
| CopyOptimizedImages          | boolean                                       | no      | If true, copies optimized images to the images subfolder. |
| CopyOriginalImages           | boolean                                       | no      | If true, copies original images to the images subfolder. |
| ExcludeDtd                     | boolean                                       | no      | If true, excludes the DTDfrom the exported XMLContent. |
| ExportFromSelected           | boolean                                       | no      | If true, exports XMLContent from the selected XMLelement. If false, exports the entire docu- ment. |
| ExportUntaggedTablesFormat   | XMLExportUntaggedTablesFormat_EnumValue   | no      | The export format for untagged tables in tagged stories. Can be None or CALS. |
| FileEncoding                   | XMLFileEncoding_EnumValue                    | no      | The file encoding type for exporting XMLcon- tent. Can be UTF8 , UTF16 , or ShiftJIS. |
| GIFOptionsInterlaced         | boolean                                       | no      | If true, generates interlaced GIFs. Note: Not valid when image conversion is JPEG. |
| GIFOptionsPalette              | GIFOptionsPalette_EnumValue                 | no      | The color palette for GIF conversion. Note: Not valid when image conversion is JPEG. Can be AdaptivePalette , MacintoshPalette , WebPalette , or WindowsPalette. |

| Name                   | Type                             | Req     | Description |
| ---------------------- | -------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ImageConversion        | ImageConversion_EnumValue       | no      | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic , JPEG , or GIF. |
| JPEGOptionsFormat      | JPEGOptionsFormat_EnumValue    | no      | The formatting method for converted JPEG images. Note: Not valid when image conver- sion is GIF. Can be BaselineEncoding or ProgressiveEncoding. |
| JPEGOptionsQuality   | JPEGOptionsQuality_EnumValue   | no      | The quality of converted JPEG images. Note: Not valid when image conversion is GIF. Can be Low , Medium , High , or Maximum. |
| Ruby                   | boolean                          | no      | If true, includes Ruby text in the exportedXML content. |
| ViewAfterExport        | boolean                          | no      | If true, displays exported XMLContent in a specified viewer. |

**Table 142**: XMLExport  Preference Properties Represented as Elements

| Name                | Description |
| ------------------- | ---------------------------------------------------------------------- |
| PreferredBrowser    | The preferred browser for viewing XML. |
| TransformFilename   | The name of the XSLT file. Note: Valid when allow transform is true. |

## 10.7.8 XMLPreference

The <XMLPreference> element stores general XML preferences for an In  Design document. This preference object does not have any effect on the interpretation of XML elements in the IDML file.

**Schema Example 116. XMLPreference**

```
XMLPreference_Object = element XMLPreference { attribute DefaultStoryTagName { xsd:string }?, attribute DefaultTableTagName { xsd:string }?, attribute DefaultCellTagName { xsd:string }?, attribute DefaultImageTagName { xsd:string }?, element Properties { element DefaultStoryTagColor { InDesignUIColorType_TypeDef }?& element DefaultTableTagColor { InDesignUIColorType_TypeDef }?& element DefaultCellTagColor { InDesignUIColorType_TypeDef }?& element DefaultImageTagColor { InDesignUIColorType_TypeDef }? } ? }
```

**Table 143**: XMLPreference Properties Represented as Attributes

| Name                   | Type     | Req     | Description |
| ---------------------- | -------- | ------- | ------------------------------------------------------------------------------------------------------------------------------ |
| DefaultCellTagName   | string   | no      | The name of the default tag to use for new table cell elements. Note: Either specifies an existing tag or creates a new tag. |

| Name                    | Type     | Req     | Description |
| ----------------------- | -------- | ------- | ------------------------------------------------------------------------------------------------------------------------- |
| DefaultImageTagName   | string   | no      | The default name for new image elements cre- ated automatically. |
| DefaultStoryTagName   | string   | no      | The name of the default tag to use for new story elements. Note: Either specifies an existing tag or creates a new tag. |
| DefaultTableTagName   | string   | no      | The name of the default tag to use for new table elements. Note: Either specifies an existing tag or creates a new tag. |

**Table 144**: XMLPreference Properties Represented as Elements

| Name                     | Type                    | Req     | Description |
| ------------------------ | ----------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DefaultCellTagColor    | InDesignUIColorType   | no      | The color of the default cell tag, specified either as an array of ListItem elements, each in the range 0 to 255 and representing R, G, and B val- ues, or as a UIColor enumeration. Note: Valid only when default cell tag name value creates a new tag. Does not update the color of an existing tag.. |
| DefaultImageTagColor   | InDesignUIColorType   | no      | The color to give a new image tag, specified either as an array of ListItem elements, each in the range 0 to 255 and representing R, G, and B values, or as a UIColor enumeration. Note: Used only when the tag needs to be created. |
| DefaultStoryTagColor   | InDesignUIColorType   | no      | The color of the default story tag, specified either as an array of ListItem elements, each in the range 0 to 255 and representing R, G, and B val- ues, or as a UIColor enumeration. Note: Valid only when default story tag name value creates a new tag. Does not update the color of an exist- ing tag. |
| DefaultTableTagColor   | InDesignUIColorType   | no      | The color of the default table tag, specified either as an array of ListItem elements, each in the range 0 to 255 and representing R, G, and B val- ues, or as a UIColor enumeration. Note: Valid only when default table tag name value creates a new tag. Does not update the color of an exist- ing tag. |

## 10.7.9 Export  For  Web  Preference

The <ExportForWebPreference> element stores the settings that are be used by the Export for Web feature of In  Design. This preference object does not have any effect on the interpretation of layout elements (page items or stories, for example) in the IDML file.

**Schema Example 117. Export  For  Web  Preference**

```
ExportForWebPreference_Object = element ExportForWebPreference { attribute CopyFormattedImages { xsd:boolean }?, attribute CopyOptimizedImages { xsd:boolean }?, attribute CopyOriginalImages { xsd:boolean }?, attribute ImageConversion { ImageConversion_EnumValue }?, attribute GIFOptionsPalette { GIFOptionsPalette_EnumValue }?, attribute GIFOptionsInterlaced { xsd:boolean }?, attribute JPEGOptionsQuality { JPEGOptionsQuality_EnumValue }?, attribute JPEGOptionsFormat { JPEGOptionsFormat_EnumValue }? }
```

**Table 145**: ExportForWebPreference Properties Represented as Attributes

| Name                     | Type                             | Req     | Description |
| ------------------------ | -------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CopyFormattedImages    | boolean                          | no      | If true, copies formatted images to the images subfolder. |
| CopyOptimizedImages    | boolean                          | no      | If true, copies optimized images to the images subfolder. |
| CopyOriginalImages     | boolean                          | no      | If true, copies original images to the images subfolder. |
| GIFOptionsInterlaced   | boolean                          | no      | If true, generates interlaced GIFs. Note: Not valid when image conversion is JPEG. |
| GIFOptionsPalette        | GIFOptionsPalette_EnumValue    | no      | The color palette for GIF conversion. Note: Not valid when image conversion is JPEG. Can be AdaptivePalette , MacintoshPalette, WebPalette, or WindowsPalette. |
| ImageConversion          | ImageConversion_EnumValue       | no      | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic , JPEG , or GIF. |
| JPEGOptionsFormat        | JPEGOptionsFormat_EnumValue    | no      | The formatting method for converted JPEG images. Note: Not valid when image conver- sion is GIF. Can be BaselineEncoding or ProgressiveEncoding. |
| JPEGOptionsQuality     | JPEGOptionsQuality_EnumValue   | no      | The quality of converted JPEG images. Note: Not valid when image conversion is GIF. Can be Low , Medium , High , or Maximum. |

## 10.7.10 Transparency  Preference

The <TransparencyPreference> element stores the default TransparencySettings for the document. Values that you specify here will apply to all transparent objects in the document that do not explicitly define these attributes.

**Schema Example 118. Transparency  Preference**

```
TransparencyPreference_Object = element TransparencyPreference { attribute BlendingSpace { BlendingSpace_EnumValue }?, attribute GlobalLightAngle { xsd:double {minInclusive="180" maxInclusive="180"} }?, attribute GlobalLightAltitude { xsd:double {minInclusive="0" maxInclusive="100"} }? }
```

**Table 146**: TransparencyPreference Properties Represented as Attributes

| Name                    | Type                       | Req     | Description |
| ----------------------- | -------------------------- | ------- | ------------------------------------------------------------------------- |
| BlendingSpace           | BlendingSpace_EnumValue   | no      | The transparency blending space. Can be Low , Default , CMYK , or RGB. |
| GlobalLightAltitude   | double                     | no      | The global light altitude. Range: 0 to 100. |
| GlobalLightAngle        | double                     | no      | The global light angle. Range: -180 to 180. |

**IDML Example 79**: TransparencyPreference

```xml
<TransparencyPreference Self="u71" BlendingSpace="CMYK" GlobalLightAngle="120" GlobalLightAltitude="30"/>
```

## 10.7.11 Transparency  Default  Container  Object

The default TransparencySetting for page items.

**Schema Example 119. Transparency  Default  Container  Object**

```
TransparencyDefaultContainerObject_Object = element TransparencyDefaultContainerObject { ( TransparencySetting_Object?& StrokeTransparencySetting_Object?& FillTransparencySetting_Object?& ContentTransparencySetting_Object? ) }
```

## 10.7.12 StoryPreference

The <StoryPreference> element controls the default StoryPreferences for stories in an In  Design document. Values that you specify here will apply to the StoryPreferences of all stories that do not explicitly define these attributes.

**Schema Example 120. StoryPreference**

```rnc
StoryPreference_Object = element StoryPreference {
attribute OpticalMarginAlignment { xsd:boolean }?,
attribute OpticalMarginSize { xsd:double {minInclusive="0.1"
maxInclusive="1296"} }?,
attribute FrameType { FrameTypes_EnumValue }?,
attribute StoryOrientation { StoryHorizontalOrVertical_EnumValue }?,
attribute StoryDirection { StoryDirectionOptions_EnumValue }?
}
```

**IDML Example 80**: StoryPreference 

```xml
<StoryPreference Self="dStoryPreference1" OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/>
```

**Table 147**: StoryPreference Properties Represented as Attributes

| Name                       | Type                                      | Req     | Description |
| -------------------------- | ----------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------- |
| FrameType                  | FrameTypes_EnumValue                    | no      | The type of TextFrame. Can be TextFrameType or FrameGridType. |
| OpticalMarginAlignment   | boolean                                   | no      | If true, adjust the position of characters at the edges of the frame to provide a better appearance. |
| OpticalMarginSize          | double                                    | no      | The PointSize used as a base for calculating optical margin alginment. (Range: 0.1 to 1296) |
| StoryDirection             | StoryDirectionOptions_EnumValue         | no      | The direction of the story. Can be LeftToRightDirection or RightToLeftDirection. |
| StoryOrientation           | StoryHorizontalOrVertical_EnumValue   | no      | The direction of the text in the story. Can be Horizontal or Vertical. |

## 10.7.13 Text  Preference

The <TextPreference> element stores general text preferences for a document.

**Schema Example 121. Text  Preference**

```rnc
TextPreference_Object = element TextPreference { attribute TypographersQuotes { xsd:boolean }?, attribute HighlightHjViolations { xsd:boolean }?, attribute HighlightKeeps { xsd:boolean }?, attribute HighlightSubstitutedGlyphs { xsd:boolean }?, attribute HighlightCustomSpacing { xsd:boolean }?, attribute HighlightSubstitutedFonts { xsd:boolean }?, attribute UseOpticalSize { xsd:boolean }?, attribute UseParagraphLeading { xsd:boolean }?, attribute SuperscriptSize { xsd:double {minInclusive="1" maxInclusive="200"} }?, attribute SuperscriptPosition { xsd:double {minInclusive="500" maxInclusive="500"} }?, attribute SubscriptSize { xsd:double {minInclusive="1" maxInclusive="200"} }?, attribute SubscriptPosition { xsd:double {minInclusive="500" maxInclusive="500"} }?, attribute SmallCap { xsd:double {minInclusive="1" maxInclusive="200"} }?, attribute LeadingKeyIncrement { xsd:double {minInclusive="0.001" maxInclusive="200"} }?, attribute BaselineShiftKeyIncrement { xsd:double {minInclusive="0.001" maxInclusive="200"} }?, attribute KerningKeyIncrement { xsd:double {minInclusive="1" maxInclusive="100"} }?, attribute ShowInvisibles { xsd:boolean }?, attribute JustifyTextWraps { xsd:boolean }?, attribute AbutTextToTextWrap { xsd:boolean }?, attribute ZOrderTextWrap { xsd:boolean }?, attribute LinkTextFilesWhenImporting { xsd:boolean }?, attribute HighlightKinsoku { xsd:boolean }?, attribute QuoteCharactersRotatedInVertical { xsd:boolean }?, attribute UseNewVerticalScaling { xsd:boolean }?, attribute UseCidMojikumi { xsd:boolean }?, attribute EnableStylePreviewMode { xsd:boolean }?, attribute SmartTextReflow { xsd:boolean }?, attribute AddPages { AddPageOptions_EnumValue }?, attribute LimitToMasterTextFrames { xsd:boolean }?, attribute PreserveFacingPageSpreads { xsd:boolean }?, attribute DeleteEmptyPages { xsd:boolean }? }
```

**Table 148**: TextPreference Properties Represented as Attributes

| Name                   | Type      | Req     | Description |
| ---------------------- | --------- | ------- | -------------------------------------------------------------------------------------------------- |
| AbutTextToTextWrap   | boolean   | no      | If true, moves wrapped text to the next available leading increment below the text wrap objects. |
| AutoPageDeletion       | boolean   | no      | If true, deletes pages when changing content results in empty pages. |
| AutoPageInsertion                   | AutoPageInsertion_EnumValue   | no      | Controls the addition of pages as content chang- es. Can be AtEndOfStory , AtEndOfSection , or AtEndOfDocument. |
| BaselineShiftKeyIncrement         | double                            | no      | The amount that the baseline shift increases each time the user presses the option/alt-shift- up arrow keys or decreases each time the user presses the option/alt-shift-down arrow keys. (Range:.001 to 100) |
| EnableDynamicAutoflow             | boolean                           | no      | If true, enable dynamic autoflow. |
| EnableStylePreviewMode            | boolean                           | no      | If true, highlights character and paragraph styles with colored backgrounds. |
| HighlightCustomSpacing            | boolean                           | no      | If true, highlights custom kerned or tracked characters. |
| HighlightHjViolations             | boolean                           | no      | If true, highlights hyphenation and justification rule violations in the text. |
| HighlightKeeps                      | boolean                           | no      | If true, highlights paragraphs that violate keep options. |
| HighlightKinsoku                    | boolean                           | no      | If true, uses on-screen highlighting to identify kinsoku. |
| HighlightSubstitutedFonts         | boolean                           | no      | If true, highlights missing fonts. |
| HighlightSubstitutedGlyphs        | boolean                           | no      | If true, highlights substituted glyphs. |
| JustifyTextWraps                    | boolean                           | no      | If true, justifies text around text wrap objects. |
| KerningKeyIncrement               | double                            | no      | The amount the kerning value per 1000 ems increases each time the user presses of the option/alt-right arrow keys or decreases each time the user presses the option/alt-left arrow keys. (Range: 1 to 100) |
| LeadingKeyIncrement               | double                            | no      | The amount that leading increases each time the user presses the option/alt-up arrow keys or decreases each time the user presses the option/ alt-down arrow keys. (Range:.001 to 200) |
| LinkTextFilesWhenImporting        | boolean                           | no      | If true, links placed text files and spreadsheet files. If false, embeds the files. |
| PreserveRectoVerso                | boolean                           | no      | If true, preserve right/left page orientation. |
| QuoteCharactersRotatedInVertical   | boolean                           | no      | If true, Japanese composer treats quotes as half width and rotates them in vertical. |
| RestrictToMasterTextFrames        | boolean                           | no      |  |
| ShowInvisibles                      | boolean                           | no      | If true, shows hidden characters. |
| SmallCap                            | double                            | no      | The size of text formatted as small caps, specified as a percentage of the font size. (Range: 1 to 200) |
| SubscriptPosition         | double    | no      | The position of subscript characters, specified as a percentage of the regular leading. (Range: -500 to 500) |
| SubscriptSize             | double    | no      | The size of subscript characters, specified as a percentage of the font size. (Range: 0 to 200) |
| SuperscriptPosition     | double    | no      | The position of superscript characters, speci- fied as a percentageage of the regular leading. (Range: -500 to 500) |
| SuperscriptSize           | double    | no      | The size of superscript characters, specified as a percentageage of the font size. (Range: 0 to 200) |
| TypographersQuotes      | boolean   | no      | If true, converts straight quotes to typographic quotes. |
| UseCidMojikumi            | boolean   | no      | If true, uses the glyph CID to get the mojikumi class of the character. |
| UseNewVerticalScaling   | boolean   | no      | If true, reverses X and Y scaling on Roman char- acters in vertical text. |
| UseOpticalSize            | boolean   | no      | If true, automatically selects the correct optical size. |
| UseParagraphLeading     | boolean   | no      | If true, applies the leading changes made to a text range to the entire paragraph. If false, applies leading changes only to the text range. |
| ZOrderTextWrap            | boolean   | no      | If true, text wrap does not affect text on lay- ers above the layer that contains the text wrap object. If false, text wrap affects text on all vis- ible layers. |

## 10.7.14 Text  Default

The <TextDefault> element controls the default text formatting for an In  Design document. For all text that has been styled with the default '[Basic Paragraph]' style, this formatting is applied as local overrides. Values that you specify here will apply to all text formatted using the '[Basic Paragraph]' style that does not explicitly define these attributes and elements. If you do not define these values, the corresponding values from the IDML defaults file will be used.

**Schema Example 122. Text  Default**

```
TextDefault_Object = element TextDefault { attribute FontStyle { xsd:string }?, attribute PointSize { xsd:double }?, attribute KerningMethod { xsd:string }?, attribute Tracking { xsd:double }?, attribute Capitalization { Capitalization_EnumValue }?, attribute Position { Position_EnumValue }?, attribute Underline { xsd:boolean }?, attribute StrikeThru { xsd:boolean }?, attribute Ligatures { xsd:boolean }?, attribute NoBreak { xsd:boolean }?, attribute HorizontalScale { xsd:double }?, attribute VerticalScale { xsd:double }?, attribute BaselineShift { xsd:double }?, attribute Skew { xsd:double }?, attribute FillTint { xsd:double }?, attribute StrokeTint { xsd:double }?, attribute StrokeWeight { xsd:double }?, attribute OverprintStroke { xsd:boolean }?, attribute OverprintFill { xsd:boolean }?, attribute OTFFigureStyle { OTFFigureStyle_EnumValue }?, attribute OTFOrdinal { xsd:boolean }?, attribute OTFFraction { xsd:boolean }?, attribute OTFDiscretionaryLigature { xsd:boolean }?, attribute OTFTitling { xsd:boolean }?, attribute OTFContextualAlternate { xsd:boolean }?, attribute OTFSwash { xsd:boolean }?, attribute UnderlineTint { xsd:double }?, attribute UnderlineGapTint { xsd:double }?, attribute UnderlineOverprint { xsd:boolean }?, attribute UnderlineGapOverprint { xsd:boolean }?, attribute UnderlineOffset { xsd:double }?, attribute UnderlineWeight { xsd:double }?, attribute StrikeThroughTint { xsd:double }?, attribute StrikeThroughGapTint { xsd:double }?, attribute StrikeThroughOverprint { xsd:boolean }?, attribute StrikeThroughGapOverprint { xsd:boolean }?, attribute StrikeThroughOffset { xsd:double }?, attribute StrikeThroughWeight { xsd:double }?, attribute FillColor { xsd:string }?, attribute StrokeColor { xsd:string }?, attribute AppliedLanguage { xsd:string }?, attribute ParagraphKashidaWidth { xsd:double }?, attribute FirstLineIndent { xsd:double }?, attribute LeftIndent { xsd:double }?, attribute RightIndent { xsd:double }?, attribute SpaceBefore { xsd:double }?, attribute SpaceAfter { xsd:double }?, attribute Justification { Justification_EnumValue }?, attribute SingleWordJustification { SingleWordJustification_EnumValue }?, attribute AutoLeading { xsd:double }?, attribute DropCapLines { xsd:short {minInclusive="0" maxInclusive="25"} }?, attribute DropCapCharacters { xsd:short {minInclusive="0" maxInclusive="150"} }?, attribute KeepLinesTogether { xsd:boolean }?, attribute KeepAllLinesTogether { xsd:boolean }?, attribute KeepWithNext { xsd:short {minInclusive="0" maxInclusive="5"} }?, attribute KeepFirstLines { xsd:short {minInclusive="1" maxInclusive="50"} }?, attribute KeepLastLines { xsd:short {minInclusive="1" maxInclusive="50"} }?, attribute StartParagraph { StartParagraph_EnumValue }?, attribute Composer { xsd:string }?, attribute MinimumWordSpacing { xsd:double }?, attribute MaximumWordSpacing { xsd:double }?, attribute DesiredWordSpacing { xsd:double }?, attribute MinimumLetterSpacing { xsd:double }?, attribute MaximumLetterSpacing { xsd:double }?, attribute DesiredLetterSpacing { xsd:double }?, attribute MinimumGlyphScaling { xsd:double }?, attribute MaximumGlyphScaling { xsd:double }?, attribute DesiredGlyphScaling { xsd:double }?, attribute RuleAbove { xsd:boolean }?, attribute RuleAboveOverprint { xsd:boolean }?, attribute RuleAboveLineWeight { xsd:double }?, attribute RuleAboveTint { xsd:double }?, attribute RuleAboveOffset { xsd:double }?, attribute RuleAboveLeftIndent { xsd:double }?, attribute RuleAboveRightIndent { xsd:double }?, attribute RuleAboveWidth { RuleWidth_EnumValue }?, attribute RuleAboveGapTint { xsd:double }?, attribute RuleAboveGapOverprint { xsd:boolean }?, attribute RuleBelow { xsd:boolean }?, attribute RuleBelowLineWeight { xsd:double }?, attribute RuleBelowTint { xsd:double }?, attribute RuleBelowOffset { xsd:double }?, attribute RuleBelowLeftIndent { xsd:double }?, attribute RuleBelowRightIndent { xsd:double }?, attribute RuleBelowWidth { RuleWidth_EnumValue }?, attribute RuleBelowGapTint { xsd:double }?, attribute HyphenateCapitalizedWords { xsd:boolean }?, attribute Hyphenation { xsd:boolean }?, attribute HyphenateBeforeLast { xsd:short {minInclusive="1" maxInclusive="15"} }?, attribute HyphenateAfterFirst { xsd:short {minInclusive="1" maxInclusive="15"} }?, attribute HyphenateWordsLongerThan { xsd:short {minInclusive="3" maxInclusive="25"} }?, attribute HyphenateLadderLimit { xsd:short {minInclusive="0" maxInclusive="25"} }?, attribute HyphenationZone { xsd:double }?, attribute HyphenWeight { xsd:short {minInclusive="0" maxInclusive="10"} }?, attribute AppliedParagraphStyle { xsd:string }?, attribute AppliedCharacterStyle { xsd:string }?, attribute LastLineIndent { xsd:double }?, attribute HyphenateLastWord { xsd:boolean }?, attribute OTFSlashedZero { xsd:boolean }?, attribute OTFHistorical { xsd:boolean }?, attribute OTFStylisticSets { xsd:int }?, attribute GradientFillLength { xsd:double }?, attribute GradientFillAngle { xsd:double }?, attribute GradientStrokeLength { xsd:double }?, attribute GradientStrokeAngle { xsd:double }?, attribute GradientFillStart { UnitPointType_TypeDef }?, attribute GradientStrokeStart { UnitPointType_TypeDef }?, attribute KeepWithPrevious { xsd:boolean }?, attribute SpanColumnType { SpanColumnTypeOptions_EnumValue }?, attribute SplitColumnInsideGutter { xsd:double }?, attribute SplitColumnOutsideGutter { xsd:double }?, attribute SpanColumnMinSpaceBefore { xsd:double }?, attribute SpanColumnMinSpaceAfter { xsd:double }?, attribute RuleBelowOverprint { xsd:boolean }?, attribute RuleBelowGapOverprint { xsd:boolean }?, attribute DropcapDetail { xsd:int }?, attribute HyphenateAcrossColumns { xsd:boolean }?, attribute KeepRuleAboveInFrame { xsd:boolean }?, attribute IgnoreEdgeAlignment { xsd:boolean }?, attribute OTFMark { xsd:boolean }?, attribute OTFLocale { xsd:boolean }?, attribute PositionalForm { PositionalForms_EnumValue }?, attribute ParagraphDirection { ParagraphDirectionOptions_EnumValue }?, attribute ParagraphJustification { ParagraphJustificationOptions_EnumValue }?, attribute MiterLimit { xsd:double {minInclusive="0" maxInclusive="1000"} }?, attribute StrokeAlignment { TextStrokeAlign_EnumValue }?, attribute EndJoin { OutlineJoin_EnumValue }?, attribute OTFOverlapSwash { xsd:boolean }?, attribute OTFStylisticAlternate { xsd:boolean }?, attribute OTFJustificationAlternate { xsd:boolean }?, attribute OTFStretchedAlternate { xsd:boolean }?, attribute CharacterDirection { CharacterDirectionOptions_EnumValue }?, attribute KeyboardDirection { CharacterDirectionOptions_EnumValue }?, attribute DigitsType { DigitsTypeOptions_EnumValue }?, attribute Kashidas { KashidasOptions_EnumValue }?, attribute DiacriticPosition { DiacriticPositionOptions_EnumValue }?, attribute XOffsetDiacritic { xsd:double }?, attribute YOffsetDiacritic { xsd:double }?, attribute ParagraphBreakType { ParagraphBreakTypes_EnumValue }?, attribute PageNumberType { PageNumberTypes_EnumValue }?, attribute AppliedNamedGrid { xsd:string }?, attribute GridAlignFirstLineOnly { xsd:boolean }?, attribute GridAlignment { GridAlignment_EnumValue }?, attribute GridGyoudori { xsd:short }?, attribute AutoTcy { xsd:short }?, attribute AutoTcyIncludeRoman { xsd:boolean }?, attribute KinsokuType { KinsokuType_EnumValue }?, attribute KinsokuHangType { KinsokuHangTypes_EnumValue }?, attribute BunriKinshi { xsd:boolean }?, attribute Rensuuji { xsd:boolean }?, attribute RotateSingleByteCharacters { xsd:boolean }?, attribute LeadingModel { LeadingModel_EnumValue }?, attribute CharacterAlignment { CharacterAlignment_EnumValue }?, attribute Tsume { xsd:double }?, attribute LeadingAki { xsd:double }?, attribute TrailingAki { xsd:double }?, attribute CharacterRotation { xsd:double }?, attribute Jidori { xsd:short }?, attribute ShataiMagnification { xsd:double }?, attribute ShataiDegreeAngle { xsd:double }?, attribute ShataiAdjustRotation { xsd:boolean }?, attribute ShataiAdjustTsume { xsd:boolean }?, attribute Tatechuyoko { xsd:boolean }?, attribute TatechuyokoXOffset { xsd:double }?, attribute TatechuyokoYOffset { xsd:double }?, attribute KentenTint { xsd:double }?, attribute KentenStrokeTint { xsd:double }?, attribute KentenWeight { xsd:double }?, attribute KentenOverprintFill { AdornmentOverprint_EnumValue }?, attribute KentenOverprintStroke { AdornmentOverprint_EnumValue }?, attribute KentenKind { KentenCharacter_EnumValue }?, attribute KentenPlacement { xsd:double }?, attribute KentenAlignment { KentenAlignment_EnumValue }?, attribute KentenPosition { RubyKentenPosition_EnumValue }?, attribute KentenFontSize { xsd:double }?, attribute KentenXScale { xsd:double }?, attribute KentenYScale { xsd:double }?, attribute KentenCustomCharacter { xsd:string }?, attribute KentenCharacterSet { KentenCharacterSet_EnumValue }?, attribute RubyTint { xsd:double }?, attribute RubyWeight { xsd:double }?, attribute RubyOverprintFill { AdornmentOverprint_EnumValue }?, attribute RubyOverprintStroke { AdornmentOverprint_EnumValue }?, attribute RubyStrokeTint { xsd:double }?, attribute RubyFontSize { xsd:double }?, attribute RubyOpenTypePro { xsd:boolean }?, attribute RubyXScale { xsd:double }?, attribute RubyYScale { xsd:double }?, attribute RubyType { RubyTypes_EnumValue }?, attribute RubyAlignment { RubyAlignments_EnumValue }?, attribute RubyPosition { RubyKentenPosition_EnumValue }?, attribute RubyXOffset { xsd:double }?, attribute RubyYOffset { xsd:double }?, attribute RubyParentSpacing { RubyParentSpacing_EnumValue }?, attribute RubyAutoAlign { xsd:boolean }?, attribute RubyOverhang { xsd:boolean }?, attribute RubyAutoScaling { xsd:boolean }?, attribute RubyParentScalingPercent { xsd:double }?, attribute RubyParentOverhangAmount { RubyOverhang_EnumValue }?, attribute Warichu { xsd:boolean }?, attribute WarichuSize { xsd:double }?, attribute WarichuLines { xsd:short }?, attribute WarichuLineSpacing { xsd:double }?, attribute WarichuAlignment { WarichuAlignment_EnumValue }?, attribute WarichuCharsAfterBreak { xsd:short }?, attribute WarichuCharsBeforeBreak { xsd:short }?, attribute OTFProportionalMetrics { xsd:boolean }?, attribute OTFHVKana { xsd:boolean }?, attribute OTFRomanItalics { xsd:boolean }?, attribute ScaleAffectsLineHeight { xsd:boolean }?, attribute CjkGridTracking { xsd:boolean }?, attribute GlyphForm { AlternateGlyphForms_EnumValue }?, attribute ParagraphGyoudori { xsd:boolean }?, attribute RubyAutoTcyDigits { xsd:short }?, attribute RubyAutoTcyIncludeRoman { xsd:boolean }?, attribute RubyAutoTcyAutoScale { xsd:boolean }?, attribute TreatIdeographicSpaceAsSpace { xsd:boolean }?, attribute AllowArbitraryHyphenation { xsd:boolean }?, attribute BulletsAndNumberingListType { ListType_EnumValue }?, attribute NumberingExpression { xsd:string }?, attribute BulletsTextAfter { xsd:string }?, attribute NumberingLevel { xsd:int }?, attribute NumberingContinue { xsd:boolean }?, attribute NumberingStartAt { xsd:int }?, attribute NumberingApplyRestartPolicy { xsd:boolean }?, attribute BulletsAlignment { ListAlignment_EnumValue }?, attribute NumberingAlignment { ListAlignment_EnumValue }?, element Properties { element AppliedFont { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element Leading { (unit_type, xsd:double ) | (enum_type, Leading_EnumValue ) }?& element UnderlineColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element UnderlineGapColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element UnderlineType { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element StrikeThroughColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element StrikeThroughGapColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element StrikeThroughType { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element BalanceRaggedLines { (bool_type, xsd:boolean ) | (enum_type, BalanceLinesStyle_EnumValue ) }?& element RuleAboveColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleAboveGapColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleAboveType { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleBelowColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleBelowGapColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleBelowType { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element SpanSplitColumnCount { (short_type, xsd:short {minInclusive="1" maxInclusive="40"} ) | (enum_type, SpanColumnCountOptions_EnumValue ) }?& element AllLineStyles { list_type, element ListItem { record_type, ( element AppliedCharacterStyle { object_type, xsd:string }& element LineCount { long_type, xsd:int }& element RepeatLast { long_type, xsd:int }) }* }?& element AllGREPStyles { list_type, element ListItem { record_type, ( element AppliedCharacterStyle { object_type, xsd:string }& element GrepExpression { string_type, xsd:string }) }* }?& element AllNestedStyles { list_type, element ListItem { record_type, ( element AppliedCharacterStyle { object_type, xsd:string }& element Delimiter { (string_type, xsd:string ) | (enum_type, NestedStyleDelimiters_EnumValue ) }& element Repetition { long_type, xsd:int }& element Inclusive { bool_type, xsd:boolean }) }* }?& element TabList { list_type, element ListItem { record_type, ( element Alignment { enum_type, TabStopAlignment_EnumValue }& element AlignmentCharacter { string_type, xsd:string }& element Leader { string_type, xsd:string }& element Position { unit_type, xsd:double }) }* }?& element KinsokuSet { (object_type, xsd:string ) | (enum_type, KinsokuSet_EnumValue ) | (string_type, xsd:string ) }?& element Mojikumi { (object_type, xsd:string ) | (string_type, xsd:string ) | (enum_type, MojikumiTableDefaults_EnumValue ) }?& element KentenFillColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element KentenStrokeColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element KentenFont { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element KentenFontStyle { (string_type, xsd:string ) | (enum_type, NothingEnum_EnumValue ) }?& element RubyFill { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RubyStroke { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RubyFont { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RubyFontStyle { (string_type, xsd:string ) | (enum_type, NothingEnum_EnumValue ) }?& element BulletChar { attribute BulletCharacterType { BulletCharacterType_EnumValue }, attribute BulletCharacterValue { xsd:int } }?& element BulletsFont { (object_type, xsd:string ) | (string_type, xsd:string ) | (enum_type, AutoEnum_EnumValue ) }?& element BulletsFontStyle { (string_type, xsd:string ) | (enum_type, NothingEnum_EnumValue ) | (enum_type, AutoEnum_EnumValue ) }?& element BulletsCharacterStyle { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element NumberingCharacterStyle { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element AppliedNumberingList { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element NumberingFormat { (enum_type, NumberingStyle_EnumValue ) | (string_type, xsd:string ) }?& element NumberingRestartPolicies { attribute RestartPolicy { RestartPolicy_EnumValue }, attribute LowerLevel { xsd:int }, attribute UpperLevel { xsd:int } }? } ? }
```

The <TextDefaults> element shares all of its attributes and elements with other text objects. Refer to 'Common Text Elements.'

## 10.7.15 DictionaryPreference

The <DictionaryPreference> element defines the language dictionaries used for spelling and hyphenation in a document.

**Schema Example 123. DictionaryPreference**

```
DictionaryPreference_Object = element DictionaryPreference { attribute Composition { ComposeUsing_EnumValue }?, attribute MergeUserDictionary { xsd:boolean }?, attribute RecomposeWhenChanged { xsd:boolean }? }
```

## 10.7.16 AnchoredObjectDefault

The <AnchoredObjectDefault> element controls the default formatting applied to anchored objects in an In  Design document. Values that you specify here will apply to all anchored objects that do not explicitly define these attributes.

**Schema Example 124. AnchoredObjectDefault**

```
AnchoredObjectDefault_Object = element AnchoredObjectDefault { attribute AnchorContent { ContentType_EnumValue }?, attribute InitialAnchorHeight { xsd:double }?, attribute InitialAnchorWidth { xsd:double }?, attribute AnchoredParagraphStyle { xsd:string }?, attribute AnchoredObjectStyle { xsd:string }? }
```

**IDML Example 81**: AnchoredObjectDefault

<AnchoredObjectDefault Self="dAnchoredObjectDefault1" AnchorContent="Unassigned" InitialAnchorHeight="72" InitialAnchorWidth="72" AnchoredParagraphStyle="ParagraphStyle\k[No paragraph style]" AnchoredObjectStyle="ObjectStyle\k[None]"/>

**Table 149**: AnchoredObjectDefault Properties Represented as Attributes

| Name                       | Type                      | Req     | Description |
| -------------------------- | ------------------------- | ------- | ----------------------------------------------------------------------------------------------------- |
| AnchorContent              | ContentType_EnumValue   | no      | The initial FrameType of a new anchored object. Can be Unassigned , GraphicType , or TextType. |
| AnchoredObjectStyle      | string                    | no      | The initial object style of a new anchored object. |
| AnchoredParagraphStyle   | string                    | no      | The initial paragraph style of a new anchored object. Note: Valid when anchor content is TextType. |
| InitialAnchorHeight      | double                    | no      | The initial height of a new anchored object. |
| InitialAnchorWidth       | double                    | no      | The initial width of a new anchored object. |

## 10.7.17 AnchoredObjectSetting

The <AnchoredObjectSetting> element controls the default positioning for anchored objects in an In  Design document. Values that you specify here will apply to all anchored objects that do not explicitly define these attributes.

**Schema Example 125. AnchoredObjectSetting**

```rnc
AnchoredObjectSetting_Object = element AnchoredObjectSetting { attribute AnchoredPosition { AnchorPosition_EnumValue }?, attribute SpineRelative { xsd:boolean }?, attribute LockPosition { xsd:boolean }?, attribute PinPosition { xsd:boolean }?, attribute AnchorPoint { AnchorPoint_EnumValue }?, attribute HorizontalAlignment { HorizontalAlignment_EnumValue }?, attribute HorizontalReferencePoint { AnchoredRelativeTo_EnumValue }?, attribute VerticalAlignment { VerticalAlignment_EnumValue }?, attribute VerticalReferencePoint { VerticallyRelativeTo_EnumValue }?, attribute AnchorXoffset { xsd:double }?, attribute AnchorYoffset { xsd:double }?, attribute AnchorSpaceAbove { xsd:double }? }
```

**IDML Example 82**: AnchoredObjectSetting

```xml
<AnchoredObjectSetting Self="dAnchoredObjectSetting1" AnchoredPosition="Inline Position" SpineRelative="false" LockPosition="false" PinPosition="true" AnchorPoint="BottomRightAnchor" HorizontalAlignment="Left Align" HorizontalReferencePoint="TextFrame" VerticalAlignment="TopAlign" VerticalReferencePoint="Line Baseline" AnchorXoffset="0" AnchorYoffset="0" AnchorSpaceAbove="0"/>
```

**Table 150**: AnchoredObjectSetting Properties Represented as Attributes

| Name                         | Type                                 | Req     | Description |
| ---------------------------- | ------------------------------------ | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AnchorPoint                  | AnchorPoint_EnumValue              | no      | The point in the anchored object to position. Can be TopLeftAnchor , TopCenterAnchor , TopRightAnchor , LeftCenterAnchor, CenterAnchor, RightCenterAnchor, BottomLeftAnchor, BottomCenterAnchor, or BottomRightAnchor. |
| AnchorSpaceAbove             | double                               | no      | The space above an above-line anchored object. |
| AnchorXoffset                | double                               | no      | The horizontal (x) offset of the anchored object. |
| AnchorYoffset                | double                               | no      | The vertical (y) offset of the anchored object. |
| AnchoredPosition             | AnchorPosition_EnumValue            | no      | The position of the anchored object relative to the anchor. Can be InlinePosition , AboveLine , Anchored. |
| HorizontalAlignment        | HorizontalAlignment_EnumValue    | no      | When anchored position is above line, the posi- tion of the anchored object is relative to the text area. When anchored position is custom, the horizontal alignment of the anchored object is set by the horizontal reference point. Note: Not valid when anchored position is InlinePosition. Can be RightAlign , LeftAlign, CenterAlign, TextAlign |
| HorizontalReferencePoint   | AnchoredRelativeTo_EnumValue       | no      | The horizontal reference point on the page. Can be ColumnEdge, TextFrame, PageMargins, PageEdge, AnchorLocation |
| LockPosition                 | boolean                              | no      | If true, prevents manual positioning of the anchored object. |
| PinPosition                  | boolean                              | no      | If true, pins the position of the anchored object within the TextFrame top and bottom. |
| SpineRelative              |boolean                            | no    | If true, the position of the anchored object is relative to the binding spine of the page or spread. |
| VerticalAlignment          | VerticalAlignment_EnumValue      | no      | The vertical alignment of the anchored object reference point with the vertical reference point on the page. Can be TopAlign, BottomAlign, or CenterAlign. |
| VerticalReferencePoint     | VerticallyRelativeTo_EnumValue   | no      | The vertical reference point on the page. Can be ColumnEdge , TextFrame , PageMargins , PageEdge , LineBaseline , LineXheight , LineAscent , Capheight , TopOfLeading. |

## 10.7.18 BaselineFrameGridOption

The <BaselineFrameGridOption> element controls the default formatting of BaselineFrameGrids in an In  Design document. Values that you specify here will apply to all BaselineFrameGrids that do not explicitly define these attributes.

**Schema Example 126. BaselineFrameGridOption**

```rnc
BaselineFrameGridOption\_Object = element BaselineFrameGridOption { attribute UseCustomBaselineFrameGrid { xsd:boolean }?,attribute StartingOffsetForBaselineFrameGrid { xsd:double {minInclusive="0" maxInclusive="8640"} }?, attribute BaselineFrameGridRelativeOption { BaselineFrameGridRelativeOption_EnumValue }?, attribute BaselineFrameGridIncrement { xsd:double {minInclusive="1" maxInclusive="8640"} }?, element Properties { element BaselineFrameGridColor { InDesignUIColorType_TypeDef }? } ? } 
```

**IDML Example 83. BaselineFrameGridOption**

```xml
<BaselineFrameGridOption Self="u83" UseCustomBaselineFrameGrid="false" StartingOffsetForBaselineFrameGrid="0" BaselineFrameGridRelativeOption="TopOfInset" BaselineFrameGridIncrement="12">
  <Properties>
    <BaselineFrameGridColor type="enumeration">LightBlue</BaselineFrameGridColor>
  </Properties>
</BaselineFrameGridOption>
```

**Table 151**: BaselineFrameGridOption Properties Represented as Attributes

| Name                                     | Type                                            | Req     | Description |
| ---------------------------------------- | ----------------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------- |
| BaselineFrameGridIncrement             | double                                          | no      | The distance between grid lines. Range 1 to 8640. |
| BaselineFrameGridRelativeOption      | BaselineFrameGridRelativeOption_EnumValue   | no      | The object from which to offset the custom base- line grid. Can be TopOfPage , TopOfMargin , TopOfFrame, or TopOfInset. |
| StartingOffsetForBaselineFrameGrid   | double                                          | no      | The amount to offset the baseline grid. Range 1 to 8640. |
| UseCustomBaselineFrameGrid             | boolean                                         | no      | If true, uses a custom BaselineFrameGrid. |

**Table 152**: BaselineFrameGridOption Properties Represented as Elements

| Name                       | Type                    | Req     | Description |
| -------------------------- | ----------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------- |
| BaselineFrameGridColor   | InDesignUIColorType   | no      | The color of the BaselineFrameGrid, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements. |

## 10.7.19 FootnoteOption

The <FootnoteOption> element controls the default formatting of footnotes in an In  Design document. Values that you specify here will apply to all footnotes that do not explicitly define these attributes and properties.

**Schema Example 127. FootnoteOption**

```
FootnoteOption_Object = element FootnoteOption { attribute StartAt { xsd:int {minInclusive="1" maxInclusive="100000"} }?, attribute Prefix { xsd:string }?, attribute Suffix { xsd:string }?, attribute FootnoteTextStyle { xsd:string }?, attribute FootnoteMarkerStyle { xsd:string }?, attribute SeparatorText { xsd:string }?, attribute SpaceBetween { xsd:double {minInclusive="0" maxInclusive="864"} }?, attribute Spacer { xsd:double {minInclusive="0" maxInclusive="864"} }?, attribute FootnoteFirstBaselineOffset { FootnoteFirstBaseline_EnumValue }?, attribute FootnoteMinimumFirstBaselineOffset { xsd:double {minInclusive="0" maxInclusive="103680"} }?, attribute EosPlacement { xsd:boolean }?, attribute NoSplitting { xsd:boolean }?, attribute RuleOn { xsd:boolean }?, attribute RuleLineWeight { xsd:double {minInclusive="0" maxInclusive="1000"} }?, attribute RuleTint { xsd:double {minInclusive="0" maxInclusive="100"} }?, attribute RuleGapTint { xsd:double {minInclusive="0" maxInclusive="100"} }?, attribute RuleGapOverprint { xsd:boolean }?, attribute RuleOverprint { xsd:boolean }?, attribute RuleLeftIndent { xsd:double {minInclusive="103680" maxInclusive="103680"} }?, attribute RuleWidth { xsd:double {minInclusive="0" maxInclusive="103680"} }?, attribute RuleOffset { xsd:double {minInclusive="15552" maxInclusive="15552"} }?, attribute ContinuingRuleOn { xsd:boolean }?, attribute ContinuingRuleLineWeight { xsd:double {minInclusive="0" maxInclusive="1000"} }?, attribute ContinuingRuleTint { xsd:double {minInclusive="0" maxInclusive="100"} }?, attribute ContinuingRuleGapTint { xsd:double {minInclusive="0" maxInclusive="100"} }?, attribute ContinuingRuleOverprint { xsd:boolean }?, attribute ContinuingRuleGapOverprint { xsd:boolean }?, attribute ContinuingRuleLeftIndent { xsd:double {minInclusive="103680" maxInclusive="103680"} }?, attribute ContinuingRuleWidth { xsd:double {minInclusive="0" maxInclusive="103680"} }?, attribute ContinuingRuleOffset { xsd:double {minInclusive="15552" maxInclusive="15552"} }?, element Properties { element FootnoteNumberingStyle { (enum_type, FootnoteNumberingStyle_EnumValue ) | (string_type, xsd:string ) }?& element RestartNumbering { (enum_type, FootnoteRestarting_EnumValue ) | (string_type, xsd:string ) }?& element ShowPrefixSuffix { (enum_type, FootnotePrefixSuffix_EnumValue ) | (string_type, xsd:string ) }?& element MarkerPositioning { (enum_type, FootnoteMarkerPositioning_EnumValue ) | (string_type, xsd:string ) }?& element RuleType { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element RuleGapColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element ContinuingRuleType { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element ContinuingRuleColor { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element ContinuingRuleGapColor { (object_type, xsd:string ) | (string_type, xsd:string ) }? } ? }
```

**Table 153**: FootnoteOption Properties Represented as Attributes

| Name                           | Type      | Req     | Description |
| ------------------------------ | --------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContinuingRuleGapOverprint   | boolean   | no      | If true, overprints the gap color of the rule above continued footnote text. Note: Valid when con- tinuing rule type is not solid. |
| ContinuingRuleGapTint        | double    | no      | The tint (as a percentage) of the gap color of the rule above continued footnote text. (Range: 0 to 100) Note: Valid when continuing rule type is not solid. |
| ContinuingRuleLeftIndent     | double    | no      | The amount to left indent the rule above contin- ued footnote text. Note: Valid when continuing rule on is true. Range: -103680 to 103680. |
| ContinuingRuleLineWeight     | double    | no      | The stroke weight of the rule above continued footnote text. (Range: 0 to 1000) Note: Valid when continuing rule on is true. |
| ContinuingRuleOffset                   | double                                | no      | The vertical offset of the rule above continued footnote text. Note: Valid when continuing rule on is true. Range: -15552 to 15552. |
| ContinuingRuleOn                         | boolean                               | no      | If true, draws a rule above footnote text that continues from a previous column. Note: Valid when no splitting is false or undefined. |
| ContinuingRuleOverprint                | boolean                               | no      | If true, overprints the rule above continued footnote text. Note: Valid when continuing rule on is true. |
| ContinuingRuleTint                     | double                                | no      | The tint (as a percentage) of the rule above con- tinued footnote text. (Range: 0 to 100) Note: Valid when continuing rule type is not solid. |
| ContinuingRuleWidth                    | double                                | no      | The length of the rule above continued footnote text. Note: Valid when continuing rule on is true. Range: 0 to 103680. |
| EosPlacement                             | boolean                               | no      | If true, footnotes at the end of the story are placed just below the text. If false, footnotes at the end of the story are placed at the bottom of the column. |
| FootnoteFirstBaselineOffset            | FootnoteFirstBaseline_EnumValue   | no      | The distance between the top of the foot- note container and the footnote text. Can be AscentOffset , CapHeight , LeadingOffset , EmboxHeight , XHeight , or FixedHeight. |
| FootnoteMarkerStyle                    | string                                | no      | The CharacterStyle to apply to footnote reference numbers in the main text. |
| FootnoteMinimumFirstBaselineOffset   | double                                | no      | The minimum distance between the baseline of the text and the top of the footnote container. Range: 0 to 103680. |
| FootnoteTextStyle                        | string                                | no      | The paragraph style to apply to footnotes. Note: The space before and after the paragraph defined in the paragraph style is ignored for footnotes. To define space above and between footnotes, see spacer and space between. |
| NoSplitting                              | boolean                               | no      | If true, footnotes cannot split across columns. If false, footnotes flow into succeeding columns when the footnote text causes the footnote area to expand upward to reach the footnote refer- ence number in the main text. |
| Prefix                                   | string                                | no      | The prefix text of the footnote. (Limit: 0 to 100 characters) |
| RuleGapOverprint                         | boolean                               | no      | If true, overprints the gap color of the rule above the first footnote in the column. Note: Valid when rule type is not solid. |
| RuleGapTint                              | double                                | no      | The tint (as a percentage) of the gap color of the rule above the first footnote in the column. (Range: 0 to 100) Note: Valid when rule type is not solid. |
| RuleLeftIndent   | double    | no      | The amount to left indent the rule above the first footnote in the column. Note: Valid when rule on is true. Range: -103860 to 103860. |
| RuleLineWeight   | double    | no      | The stroke weight of the rule above the first footnote in the column. (Range: 0 to 1000) Note: Valid when rule on is true. |
| RuleOffset       | double    | no      | The vertical offset of the rule above the first foot- note in the column. Note: Valid when rule on is true. Range -15552 to 15552. |
| RuleOn           | boolean   | no      | If true, draws a rule between the text and the first footnote in the column. |
| RuleOverprint    | boolean   | no      | If true, overprints the rule above the first foot- note in the column. Note: Valid when rule on is true. |
| RuleTint         | double    | no      | The tint (as a percentage) of the rule above the first footnote in the column. (Range: 0 to 100) Note: Valid when rule on is true. |
| RuleWidth        | double    | no      | The length of the rule above the first footnote in the column. Note: Valid when rule on is true. Range: 0 to 103680. |
| Self             | string    | yes     | The unique ID of the object. |
| SeparatorText    | string    | no      | The text to insert between the footnote marker number and the footnote text. (Range: 0 to 100 characters) |
| SpaceBetween     | double    | no      | The amount of vertical space between footnotes. Note: The space before and SpaceAfter defined for the paragraph style applied to the footnote is ignored. For information on the applied para- graph style, see footnote text style. Range: 0 to 864. |
| Spacer           | double    | no      | The minimum amount of vertical space between the bottom of the text column and the first foot- note. Note: The space before amount defined in the paragraph style applied to the footnote is ignored for the first footnote. For information on the AppliedParagraphStyle, see footnote text style. Range: 0 to 864. |
| StartAt          | int       | no      | The number at which to start footnote number- ing. Range: 1 to 100000. |
| Suffix           | string    | no      | The suffix text of the footnote. (Limit: 0 to 100 characters) |

**Table 154**: FootnoteOption Properties Represented as Elements

| Name                       | Type                                                | Req     | Description |
| -------------------------- | --------------------------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContinuingRuleColor      | string                                              | no      | A reference to the swatch (color, gradient, tint, or mixed ink) applied to the stroke of the foot- note continuing rule above. The string can con- tain either an element reference (the value of the Self attribute of the swatch), or the name of the color (for example: Color/Black ). Note: Valid when continuing rule on is true. |
| ContinuingRuleGapColor   | string                                              | no      | The swatch (color, gradient, tint, or mixed ink) applied to the stroke gap of the footnote con- tinuing rule above. The string can contain either an element reference (the value of the Self attribute of the swatch), or the name of the color (for example: Color/Black ). Note: Valid when continuing rule on is true. |
| ContinuingRuleType       | string                                              | no      | The stroke type of the rule above continued footnote text. Note: Valid when continuing rule on is true. |
| FootnoteNumberingStyle   | FootnoteNumberingStyle_EnumValue or string      | no      | The footnote numbering style. |
| MarkerPositioning          | FootnoteMarkerPositioning_EnumValue or string   | no      | The position of footnote reference numbers in the main text. |
| RestartNumbering           | FootnoteRestarting_EnumValue or string          | no      | The point at which to restart footnote numbering. |
| RuleColor                  | string                                              | no      | The swatch (color, gradient, tint, or mixed ink) applied to the stroke of the rule above the first footnote in the column. The string can contain either an element reference (the value of the Self attribute of the swatch), or the name of the color (for example: Color/Black ). Note: Valid when rule on is true. |
| RuleGapColor               | string                                              | no      | The swatch (color, gradient, tint, or mixed ink) applied to the stroke gap of the rule above the first footnote in the column. The string can con- tain either an element reference (the value of the Self attribute of the swatch), or the name of the color (for example: Color/Black ). Note: Valid when rule type is not solid. |
| RuleType                   | string                                              | no      | The stroke type of the rule above the first foot- note in a column. Note: Valid when rule on is true. |
| ShowPrefixSuffix           | FootnotePrefixSuffix_EnumValue or string          | no      | The position of the footnote prefix and/or suffix. |

**IDML Example 84**: FootnoteOptions

```xml
<FootnoteOption Self="d FootnoteOption1" Start  At="1" Prefix="" Suffix="" Footnote Text Style="Paragraph  Style\k Normal  Paragraph Style" Footnote  Marker  Style="CharacterStyle\k[No CharacterStyle]" Separator  Text="&#x9;" Space  Between="0" Spacer="0" Footnote  First Baseline  Offset="Leading Offset" Footnote  Minimum  First Baseline  Offset="0" Eos Placement="false" No  Splitting="false" Rule On="true" Rule  Line  Weight="1" Rule Tint="100" Rule  Gap Tint="100" Rule  Gap Overprint="false" Rule  Overprint="false" Rule Left Indent="0" Rule  Width="72" Rule Offset="0" Continuing  Rule  On="true" Continuing Rule Line Weight="1" Continuing  Rule Tint="100" Continuing  Rule Gap Tint="100" Continuing  Rule Overprint="false" Continuing  Rule Gap Overprint="false" Continuing  Rule Left Indent="0" Continuing  Rule Width="288" Continuing  Rule Offset="0"> <Properties> <FootnoteNumberingStyle type="enumeration">Arabic</FootnoteNumberingStyle> <RestartNumbering type="enumeration">Dont Restart</RestartNumbering> <ShowPrefixSuffix type="enumeration">No Prefix  Suffix</ShowPrefixSuffix> <MarkerPositioning type="enumeration">Superscript Marker</MarkerPositioning> <RuleType type="object">Stroke  Style\k Solid</RuleType> <RuleColor type="object">Color\c  Black</RuleColor> <RuleGapColor type="object">Swatch\c  None</RuleGapColor> <ContinuingRuleType type="object">Stroke  Style\k Solid</ContinuingRuleType> <ContinuingRuleColor type="object">Color\c  Black</ContinuingRuleColor> <ContinuingRuleGapColor type="object">Swatch\c  None</ContinuingRuleGapColor> </Properties> </FootnoteOption>
```

## 10.7.20 TextWrapPreference

The <TextWrapPreference> element controls the default text wrap applied to page items in an InDesign document. Values that you specify here will apply to all text wraps that do not explicitly define these attributes and elements.

**Schema Example 128. TextWrapPreference**

```rnc
TextWrapPreference_Object = element TextWrapPreference { attribute Inverse { xsd:boolean }?, attribute ApplyToMasterPageOnly { xsd:boolean }?, attribute TextWrapSide { TextWrapSideOptions_EnumValue }?, attribute TextWrapMode { TextWrapModes_EnumValue }?, element Properties { element TextWrapOffset { UnitRectangleBoundsType_TypeDef }?& element PathGeometry { element GeometryPathType { GeometryPathType_TypeDef }* }? } ? , ( ContourOption_Object? ) } Schema Example 129. Contour  Option Contour  Option_Object = element Contour  Option { attribute Contour  Type { Contour Options  Types_Enum  Value }?, attribute Include  Inside  Edges { xsd:boolean }?, attribute Contour  Path Name { xsd:string }? }
```

**IDML Example 85**: TextWrapPreference

```xml
<TextWrapPreference Self="d  TextWrapPreference1" Text  Wrap Type="None" Inverse="false" Apply  To Master  Page Only="false" Text  Wrap Side="Both  Sides"> <Properties> <TextWrapOffset Top="0" Left="0" Bottom="0" Right="0"/> </Properties> <ContourOption Self="d TextWrapPreference1Contour  Option1" Contour  Type="Same  As Clipping" Include  Inside Edges="false" Contour  Path Name="$ID/"/> </TextWrapPreference>
```

**Table 155**: Contour  Option Properties Represented as Attributes

| Name                   | Type                              | Req     | Description |
| ---------------------- | --------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContourPathName        | string                            | no      | The name of the alpha channel or Photoshop path to use for the contour option. Valid only when the contour options is photoshop path or alpha channel. |
| ContourType            | ContourOptionsTypes_EnumValue   | no      | The contour type. Can be BoundingBox , PhotoshopPath , DetectEdges , AlphaChannel, GraphicFrame, or SameAsClipping. |
| IncludeInsideEdges   | boolean                           | no      | If true, creates interior clipping paths within the surrounding clipping path. Note: Valid only when clipping type is AlphaChannel or DetectEdges. |

## 10.7.21 Document  Preference

The <DocumentPreference> element contains various preferences for the document. Document preferences define the basic layout of the document. If you omit some or all of the properties set in the <DocumentPreferences> element, In  Design will apply its application default value to the missing property as it opens the IDML file.

**Schema Example 130. Document  Preference**

```
DocumentPreference_Object = element DocumentPreference { attribute PageHeight { xsd:double }?, attribute PageWidth { xsd:double }?, attribute CreatePrimaryTextFrame { xsd:boolean }?, attribute PagesPerDocument { xsd:int }?, attribute FacingPages { xsd:boolean }?, attribute DocumentBleedTopOffset { xsd:double }?, attribute DocumentBleedBottomOffset { xsd:double }?, attribute DocumentBleedInsideOrLeftOffset { xsd:double }?, attribute DocumentBleedOutsideOrRightOffset { xsd:double }?, attribute DocumentBleedUniformSize { xsd:boolean }?, attribute SlugTopOffset { xsd:double }?, attribute SlugBottomOffset { xsd:double }?, attribute SlugInsideOrLeftOffset { xsd:double }?, attribute SlugRightOrOutsideOffset { xsd:double }?, attribute DocumentSlugUniformSize { xsd:boolean }?, attribute PreserveLayoutWhenShuffling { xsd:boolean }?, attribute AllowPageShuffle { xsd:boolean }?, attribute OverprintBlack { xsd:boolean }?, attribute ColumnGuideLocked { xsd:boolean }?, attribute Intent { DocumentIntentOptions_EnumValue }?, attribute PageBinding { PageBindingOptions_EnumValue }?, attribute ColumnDirection { HorizontalOrVertical_EnumValue }?, attribute MasterTextFrame { xsd:boolean }?, attribute SnippetImportUsesOriginalLocation { xsd:boolean }?, element Properties { element ColumnGuideColor { InDesignUIColorType_TypeDef }?& element MarginGuideColor { InDesignUIColorType_TypeDef }? } ? } 
```

**IDML Example 86. Document Preferences**

```xml
<DocumentPreference Self="d Document  Preference1" Page Height="792" Page  Width="612" Pages Per Document="1" Facing  Pages="true" Document  Bleed Top Offset="0" Document  Bleed Bottom  Offset="0" Document  Bleed Inside  Or Left Offset="0" Document  Bleed Outside  Or Right Offset="0" Document  Bleed Uniform  Size="true" Slug Top Offset="0" Slug  Bottom  Offset="0" Slug Inside  Or Left Offset="0" Slug  Right Or Outside  Offset="0" Document  Slug Uniform Size="false" Preserve  Layout  When Shuffling="true" Allow  Page  Shuffle="true" Overprint Black="true" Page  Binding="Left  To Right" Column  Direction="Horizontal" Column  Guide Locked="true" Master  TextFrame="false" Snippet  Import  Uses Original  Location="false"> <Properties> <Column  Guide Color type="enumeration">Violet</Column  Guide Color> <Margin  Guide Color type="enumeration">Magenta</Margin  Guide Color> </Properties> </DocumentPreference>
```

**Table 156**: DocumentPreference Properties Represented as Attributes

| Name                                    | Type                                 | Req     | Description |
| --------------------------------------- | ------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AllowPageShuffle                        | boolean                              | no      | If true, guarantees that all new spreads added to the document contain a maximum of two pages. If false, allows pages to be added or moved into existing spreads. For override information, see preserve layout when shuffling. |
| ColumnDirection                         | HorizontalOrVertical_EnumValue   | yes     | The direction of text in the column |
| ColumnGuideLocked                       | boolean                              | no      | If true, locks column guides. |
| DocumentBleedBottomOffset             | double                               | no      | The amount to offset the bottom document bleed. Note: To set the bleed bottom offset, doc- ument bleed uniform size must be false. |
| DocumentBleedInsideOrLeftOffset     | double                               | no      | The amount to offset the inside or left document bleed. Note: To set the bleed inside or left offset, document bleed uniform size must be false. |
| DocumentBleedOutsideOrRightOffset   | double                               | no      | The amount to offset the outside or right docu- ment bleed. Note: To set the bleed outside or right offset, document bleed uniform size must be false. |
| DocumentBleedTopOffset                | double                              | no      | The amount to offset the top document bleed. |
| DocumentBleedUniformSize              | boolean                             | no      | If true, uses the document bleed top offset value for bleed offset measurements on all sides of the document. The default setting is true. |
| DocumentSlugUniformSize               | boolean                             | no      | If true, uses the slug top offset value for slug measurements on all sides of the doucment. The default value is false. |
| FacingPages                             | boolean                             | no      | If true, the document has facing pages. |
| Intent                                  | DocumentIntentOptions_EnumValue   | no      | Can be PrintIntent or WebIntent. |
| MasterTextFrame                         | boolean                             | no      | If true, the document A-master has auto text- frames. |
| OverprintBlack                          | boolean                             | no      | If true, overprints black when saving the docu- ment. |
| PageBinding                             | PageBindingOptions_EnumValue      | yes     | The page binding. Use Default , RightToLeft, or LeftToRight. |
| PageHeight                              | double                              | no      | The height of the page. |
| PageWidth                               | double                              | no      | The width of the page. |
| PagesPerDocument                        | int                                 | no      | The number of pages in the document. (Range: 1 to 9999) |
| PreserveLayoutWhenShuffling           | boolean                             | no      | If true, preserves the layout of spreads that con- tained more than two pages when allow page shuffle was turned on. If false, changes multi- page spreads to two-page spreads if the spreads were created or changed since allow page shuffle was turned on. |
| SlugBottomOffset                        | double                              | no      | The amount to offset the bottom slug. Note: To set the slug bottom offset, document slug uni- form size must be false. |
| SlugInsideOrLeftOffset                | double                              | no      | The amount to offset the inside or left slug. Note: To set the slug inside or left offset, document slug uniform size must be false. |
| SlugRightOrOutsideOffset              | double                              | no      | The amount to offset the outside or right slug. Note: To set the slug right or outside offset, doc- ument slug uniform size must be false. |
| SlugTopOffset                           | double                              | no      | The amount to offset the top slug. |
| SnippetImportUsesOriginalLocation   | boolean                             | no      | If true, causes UI-based snippet import to use original location for page items. |
| CreatePrimaryTextFrame                 | boolean                             | no      | If true, the document A-master has primary TextFrames when a new document is created. |

**Table 157**: DocumentPreference Properties Represented as Elements

| Name                          | Type                    | Req     | Description |
| ----------------------------- | ----------------------- | ------- | ------------------------------------------------------------------------------------------------------------------- |
| ColumnGuideColor   | InDesignUIColorType   | no      | The color of the column guides, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements. |
| MarginGuideColor              | InDesignUIColorType   | no      | The color of the margin guides, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements. |

## 10.7.22 Grid  Preference

The <GridPreference> element stores the grid preferences for the document. Document grid preferences for the baseline grid can have an effect on all TextFrames that do not specifically define a BaselineFrameGrid (depending on the state of the Align to Baseline setting of the paragraphs in the TextFrames). For more on this topic, refer to the In  Design online help.

**Schema Example 131. Grid  Preference**

```
GridPreference_Object = element GridPreference { attribute DocumentGridShown { xsd:boolean }?, attribute DocumentGridSnapto { xsd:boolean }?, attribute HorizontalGridlineDivision { xsd:double {minInclusive="0.01" maxInclusive="1000"} }?, attribute VerticalGridlineDivision { xsd:double {minInclusive="0.01" maxInclusive="1000"} }?, attribute HorizontalGridSubdivision { xsd:int {minInclusive="1" maxInclusive="1000"} }?, attribute VerticalGridSubdivision { xsd:int {minInclusive="1" maxInclusive="1000"} }?, attribute GridsInBack { xsd:boolean }?, attribute BaselineGridShown { xsd:boolean }?, attribute BaselineStart { xsd:double {minInclusive="0" maxInclusive="1000"} }?, attribute BaselineDivision { xsd:double {minInclusive="1" maxInclusive="8640"} }?, attribute BaselineViewThreshold { xsd:double {minInclusive="5" maxInclusive="4000"} }?, attribute BaselineGridRelativeOption { BaselineGridRelativeOption_EnumValue }?, element Properties { element GridColor { InDesignUIColorType_TypeDef }?& element BaselineColor { InDesignUIColorType_TypeDef }? } ? }
```

**IDML Example 87**: Grid  Preference

```xml
<GridPreference Self="d  Grid Preference1" Document  Grid Shown="false" Document  Grid Snapto="false" Horizontal  Gridline Division="72" Vertical  Gridline  Division="72" Horizontal  Grid Subdivision="8" Vertical  Grid Subdivision="8" Grids  In Back="true" Baseline  Grid Shown="false" Baseline  Start="36" Baseline Division="12" Baseline  View Threshold="75" Baseline  Grid Relative  Option="Top  Of Page Of Baseline  Grid Relative  Option"> <Properties> <GridColor type="enumeration">Light  Gray</GridColor>> <BaselineColor type="enumeration">Light Blue</BaselineColor>>
</Properties> </GridPreference>
```

**Table 158**: Grid  Preference Properties Represented as Attributes

| Name                           | Type                                      | Req     | Description |
| ------------------------------ | ----------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------- |
| BaselineDivision               | double                                    | no      | The amount of space between baseline grid lines. Range: 1 to 8640. |
| BaselineGridRelativeOption   | BaselineGridRelativeOption_EnumValue   | no      | The zero point for the baseline grid offset. |
| BaselineGridShown              | boolean                                   | no      | If true, displays the baseline grid. |
| BaselineStart                  | double                                    | no      | The amount to offset the baseline grid from the zero point. Range: 0 to 1000. |
| BaselineViewThreshold        | double                                    | no      | The magnification (as a percentage) less than which ruler guides do not appear. (Range: 5 to 4000) |
| DocumentGridShown              | boolean                                   | no      | If true, displays the document grid. |
| DocumentGridSnapto           | boolean                                   | no      | If true, an object snaps to the nearest grid line when the object is created, moved, or resized. |
| GridsInBack                    | boolean                                   | no      | If true, places grids behind all other objects on the spread. |
| HorizontalGridSubdivision    | int                                       | no      | The number of rows into which to subdivide the space between horizontal document grid lines. Range: 1 to 1000. |
| HorizontalGridlineDivision   | double                                    | no      | The amount of space between major horizontal lines in the document grid. Range: 0.01 to 1000. |
| VerticalGridSubdivision      | int                                       | no      | The number of columns into which to subdivide the space between vertical document grid lines. Range: 0.01 to 1000. |
| VerticalGridlineDivision     | double                                    | no      | The amount of space between major vertical lines in the document grid. Range: 0.01 to 1000. |

**Table 159**: GridPreference Properties Represented as Elements

| Name            | Type                    | Req     | Description |
| --------------- | ----------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------ |
| BaselineColor   | InDesignUIColorType   | no      | The color of the baseline grid, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |
| GridColor       | InDesignUIColorType   | no      | The color of the document grid, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |

## 10.7.23 GuidePreference

The <GuidePreference> element stores the guide preferences for the document.

**Schema Example 132. GuidePreference**

```rnc
GuidePreference_Object = element GuidePreference { attribute GuidesInBack { xsd:boolean }?, attribute GuidesShown { xsd:boolean }?, attribute GuidesLocked { xsd:boolean }?, attribute GuidesSnapto { xsd:boolean }?, attribute RulerGuidesViewThreshold { xsd:double }?, element Properties { } ? element RulerGuidesColor { InDesignUIColorType_TypeDef }? } 
```

**IDML Example 88. GuidePreference**

```xml
<GuidePreference Self="u88" GuidesInBack="false" GuidesShown="true" GuidesLocked="false" GuidesSnapto="true" RulerGuidesViewThreshold="5">
  <Properties>
    <RulerGuidesColor type="enumeration">Cyan</RulerGuidesColor>
  </Properties>
</GuidePreference>
```

**Table 160**: GuidePreference Properties Represented as Attributes

| Name                         | Type      | Req     | Description |
| ---------------------------- | --------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| GuidesInBack                 | boolean   | no      | If true, places guides behind all other objects on the spread. |
| GuidesLocked                 | boolean   | no      | If true, guides cannot be moved, added, or deleted. |
| GuidesShown                  | boolean   | no      | If true, displays the guides. |
| GuidesSnapto                 | boolean   | no      | If true, an object within the specified range snaps to the nearest guide when the object is cre- ated, moved, or resized. For range information, see guide snapto zone. |
| RulerGuidesViewThreshold   | double    | no      | The magnification (as a percentage) less than which ruler guides do not appear. (Range: 5 to 4000) |

**Table 161**: GuidePreference Properties Represented as Elements

| Name               | Type                    | Req     | Description |
| ------------------ | ----------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| RulerGuidesColor   | InDesignUIColorType   | no      | The color of the ruler guides, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |

## 10.7.24 MarginPreference

The <MarginPreference> element controls the default margin and column settings for the pages in a spread. Values that you specify here will apply to the MarginPreferences of all pages where you have not explicitly defined these attributes and elements.

**Schema Example 133. MarginPreference**

```
MarginPreference_Object = element MarginPreference { attribute ColumnCount { xsd:int {minInclusive="1" maxInclusive="216"} }?, attribute ColumnGutter { xsd:double {minInclusive="0" maxInclusive="1440"} }?, attribute Top { xsd:double }?, attribute Bottom { xsd:double }?, attribute Left { xsd:double }?, attribute Right { xsd:double }?, attribute ColumnDirection { HorizontalOrVertical_EnumValue }?, attribute ColumnsPositions { list { xsd:double * } }? }
```

## 10.7.25 Pasteboard  Preference

The <PasteboardPreference> element controls the height of the pasteboard (through the Minimum  Space Above And Below attribute) and colors used to display the pasteboard and pasteboard guides.

**Schema Example 134. Pasteboard  Preference**

```
PasteboardPreference_Object = element PasteboardPreference { attribute PasteboardMargins { list { xsd:double ,xsd:double } }?, attribute MinimumSpaceAboveAndBelow { xsd:double }?, element Properties { element PreviewBackgroundColor { InDesignUIColorType_TypeDef }?& element BleedGuideColor { InDesignUIColorType_TypeDef }?& element SlugGuideColor { InDesignUIColorType_TypeDef }? } ? }
```

**Table 162**: PasteboardPreference Properties Represented as Attributes

| Name                          | Type     | Req     | Description |
| ----------------------------- | -------- | ------- | ------------------------------------------- |
| MinimumSpaceAboveAndBelow   | double   | no      | The minimum space above and below a page. |

**Table 163**: PasteboardPreference Properties Represented as Elements

| Name                       | Type                    | Req     | Description |
| -------------------------- | ----------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------- |
| BleedGuideColor            | InDesignUIColorType   | no      | The color of the bleed guides, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |
| PreviewBackgroundColor   | InDesignUIColorType   | no      | The color of the pasteboard background, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |
| SlugGuideColor             | InDesignUIColorType   | no      | The color of the slug guides, as a UIColors enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |

## 10.7.26 View  Preference

The <ViewPreference> element controls the measurement units, ruler origin, and other user interface properties of the document.

Note: Changing the measurement units in the <ViewPreference> element only changes the units displayed and used in the In  Design user interface after you have opened the IDML document. Measurement units inside the XML files in an IDML package are always points.

**Schema Example 135. View  Preference**

```
ViewPreference_Object = element ViewPreference { attribute PointsPerInch { xsd:double {minInclusive="60" maxInclusive="80"} }?, attribute HorizontalCustomPoints { xsd:double {minInclusive="4" maxInclusive="256"} }?, attribute VerticalCustomPoints { xsd:double {minInclusive="4" maxInclusive="256"} }?, attribute StrokeMeasurementUnits { MeasurementUnits_EnumValue }?, attribute GuideSnaptoZone { xsd:int {minInclusive="1" maxInclusive="36"} }?, attribute CursorKeyIncrement { xsd:double {minInclusive="0.001" maxInclusive="100"} }?, attribute HorizontalMeasurementUnits { MeasurementUnits_EnumValue }?, attribute VerticalMeasurementUnits { MeasurementUnits_EnumValue }?, attribute RulerOrigin { RulerOrigin_EnumValue }?, attribute ShowRulers { xsd:boolean }?, attribute ShowFrameEdges { xsd:boolean }?, attribute LineMeasurementUnits { MeasurementUnits_EnumValue }?, attribute TypographicMeasurementUnits { MeasurementUnits_EnumValue }?, attribute TextSizeMeasurementUnits { MeasurementUnits_EnumValue }?, attribute PrintDialogMeasurementUnits { MeasurementUnits_EnumValue }?, attribute ShowNotes { xsd:boolean }? }
```

**Table 164**: ViewPreference Properties Represented as Attributes

| Name                           | Type                          | Req     | Description |
| ------------------------------ | ----------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CursorKeyIncrement           | double                        | no      | The distance to move a specified object when an arrow key is pressed. (Range: 0.001 to 100.) |
| GuideSnaptoZone                | int                           | no      | The range (in pixels) within which an object snaps to guides. (Range: 1 to 36) Note: Snapping occurs only when guides are shown. |
| HorizontalCustomPoints       | double                        | no      | The distance (in points) between major tick marks on the horizontal ruler. (Range: 4 to 256) Valid only when horizontal measurement units is custom. |
| HorizontalMeasurementUnits   | MeasurementUnits_EnumValue   | no      | The measurement unit for the horizontal ruler and other horizontally-measured spaces such as grid columns, horizontal offsets, column gut- ters, or others. Can be Points , Picas , Inches , InchesDecimal , Millimeters , Centimeters , Ciceros , Q , Ha , AmericanPoints , Custom , Agates , U , Bai , or Mil. |

| Name                            | Type                          | Req     | Description |
| ------------------------------- | ----------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LineMeasurementUnits          | MeasurementUnits_EnumValue   | no      | Can be Points , Picas , Inches , InchesDecimal , Millimeters , Centimeters , Ciceros , Q , Ha , AmericanPoints , Custom , Agates , U , Bai , or Mil. |
| PointsPerInch                   | double                        | no      | The number of points per inch, typically 72. (Range: 60 to 80) |
| PrintDialogMeasurementUnits   | MeasurementUnits_EnumValue   | no      | The measurement units used in the Print dialog box. Can be Points , Picas , Inches , InchesDecimal , Millimeters , Centimeters , Ciceros , Q , Ha , AmericanPoints , Custom , Agates , U , Bai , or Mil. |
| RulerOrigin                     | RulerOrigin_EnumValue       | no      | The default zero point at the intersection of the vertical and horizontal rulers and the scope of the horizontal ruler. Can be SpreadOrigin , PageOrigin , SpineOrigin. |
| ShowFrameEdges                  | boolean                       | no      | If true, displays borders of unselected frames and the diagonal lines in empty unselected frames. |
| ShowNotes                       | boolean                       | no      | If true, notes are displayed. |
| ShowRulers                      | boolean                       | no      | If true, displays the horizontal and vertical rulers. |
| TextSizeMeasurementUnits      | MeasurementUnits_EnumValue   | no      | The measurement units used for text size. Can be Points , Picas , Inches , InchesDecimal , Millimeters , Centimeters , Ciceros , Q , Ha , AmericanPoints , Custom , Agates , U , Bai , or Mil. |
| TypographicMeasurementUnits   | MeasurementUnits_EnumValue   | no      | The measurement units used for type format- ting properties (other than text size). Can be Points , Picas , Inches , InchesDecimal , Millimeters , Centimeters , Ciceros , Q , Ha , AmericanPoints , Custom , Agates , U , Bai , or Mil. |
| VerticalCustomPoints          | double                        | no      | The distance (in points) between major tick marks on the vertical ruler. (Range: 4 to 256) Valid only when VerticalMeasurementUnits is custom. |
| VerticalMeasurementUnits      | MeasurementUnits_EnumValue   | no      | The measurement unit for the vertical ruler and other vertically-measured spaces such as grid rows, vertical offsets, row heights, or others. Can be Points , Picas , Inches , InchesDecimal , Millimeters , Centimeters , Ciceros , Q , Ha , AmericanPoints , Custom , Agates , U , Bai , or Mil. |

## 10.7.27 Print  Preference

The <PrintPreference> element stores the printing preferences for the document.

**Schema Example 136. Print  Preference**

PrintPreference\_Object = element PrintPreference {

```
attribute PrintFile { xsd:string }?, attribute Copies { xsd:int }?, attribute Collating { xsd:boolean }?, attribute ReverseOrder { xsd:boolean }?, attribute Sequence { Sequences_EnumValue }?, attribute PrintSpreads { xsd:boolean }?, attribute PrintMasterPages { xsd:boolean }?, attribute PrintNonprinting { xsd:boolean }?, attribute PrintBlankPages { xsd:boolean }?, attribute PrintGuidesGrids { xsd:boolean }?, attribute PaperOffset { xsd:double }?, attribute PaperGap { xsd:double }?, attribute PaperTransverse { xsd:boolean }?, attribute PrintPageOrientation { PrintPageOrientation_EnumValue }?, attribute PagePosition { PagePositions_EnumValue }?, attribute ScaleMode { ScaleModes_EnumValue }?, attribute ScaleWidth { xsd:double }?, attribute ScaleHeight { xsd:double }?, attribute ScaleProportional { xsd:boolean }?, attribute Thumbnails { xsd:boolean }?, attribute ThumbnailsPerPage { ThumbsPerPage_EnumValue }?, attribute Tile { xsd:boolean }?, attribute TilingType { TilingTypes_EnumValue }?, attribute TilingOverlap { xsd:double }?, attribute AllPrinterMarks { xsd:boolean }?, attribute CropMarks { xsd:boolean }?, attribute BleedMarks { xsd:boolean }?, attribute RegistrationMarks { xsd:boolean }?, attribute ColorBars { xsd:boolean }?, attribute PageInformationMarks { xsd:boolean }?, attribute MarkLineWeight { MarkLineWeight_EnumValue }?, attribute MarkOffset { xsd:double }?, attribute UseDocumentBleedToPrint { xsd:boolean }?, attribute BleedTop { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedBottom { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedInside { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedOutside { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute IncludeSlugToPrint { xsd:boolean }?, attribute ColorOutput { ColorOutputModes_EnumValue }?, attribute TextAsBlack { xsd:boolean }?, attribute Trapping { Trapping_EnumValue }?, attribute Flip { Flip_EnumValue }?, attribute Negative { xsd:boolean }?, attribute CompositeAngle { xsd:double }?, attribute CompositeFrequency { xsd:double }?, attribute SimulateOverprint { xsd:boolean }?, attribute PrintCyan { xsd:boolean }?, attribute CyanAngle { xsd:double }?, attribute CyanFrequency { xsd:double }?, attribute PrintMagenta { xsd:boolean }?, attribute MagentaAngle { xsd:double }?, attribute MagentaFrequency { xsd:double }?, attribute PrintYellow { xsd:boolean }?, attribute YellowAngle { xsd:double }?, attribute YellowFrequency { xsd:double }?, attribute PrintBlack { xsd:boolean }?, attribute BlackAngle { xsd:double }?, attribute BlackFrequency { xsd:double }?, attribute SendImageData { ImageDataTypes_EnumValue }?, attribute FontDownloading { FontDownloading_EnumValue }?, attribute DownloadPPDFonts { xsd:boolean }?, attribute PostScriptLevel { PostScriptLevels_EnumValue }?, attribute DataFormat { DataFormat_EnumValue }?, attribute SourceSpace { SourceSpaces_EnumValue }?, attribute Intent { RenderingIntent_EnumValue }?, attribute OPIImageReplacement { xsd:boolean }?, attribute OmitEPS { xsd:boolean }?, attribute OmitPDF { xsd:boolean }?, attribute OmitBitmaps { xsd:boolean }?, attribute FlattenerPresetName { xsd:string }?, attribute IgnoreSpreadOverrides { xsd:boolean }?, attribute BleedChain { xsd:boolean }?, attribute PreserveColorNumbers { xsd:boolean }?, attribute BitmapPrinting { xsd:boolean }?, attribute BitmapResolution { xsd:int {minInclusive="72" maxInclusive="1200"} }?, attribute PrintLayers { PrintLayerOptions_EnumValue }?, attribute DeviceType { xsd:int }?, attribute PrintTo { xsd:int }?, attribute PPDFile { xsd:string }?, attribute PrintToDisk { xsd:boolean }?, attribute PrintRecord { xsd:string }?, attribute PrintResolution { xsd:double }?, attribute PaperSizeSelector { xsd:string }?, attribute PaperHeightRange { list { xsd:double ,xsd:double } }?, attribute PaperWidthRange { list { xsd:double ,xsd:double } }?, attribute PaperOffsetRange { list { xsd:double ,xsd:double } }?, attribute SeparationScreening { xsd:string }?, attribute CompositeScreening { xsd:string }?, attribute SpotAngle { xsd:double }?, attribute SpotFrequency { xsd:double }?, element Properties { element ActivePrinterPreset { (enum_type, PrinterPresetTypes_EnumValue ) | (string_type, xsd:string ) }?& element Printer { (enum_type, Printer_EnumValue ) | (string_type, xsd:string ) }?& element PPD { (enum_type, PPDValues_EnumValue ) | (string_type, xsd:string ) }?& element PaperSize { (enum_type, PaperSizes_EnumValue ) | (string_type, xsd:string ) }?& element PaperHeight { (enum_type, PaperSize_EnumValue ) | (unit_type, xsd:double ) }?& element PaperWidth { (enum_type, PaperSize_EnumValue ) | (unit_type, xsd:double ) }?& element MarkType { (enum_type, MarkTypes_EnumValue ) | (string_type, xsd:string ) }?& element Screening { (enum_type, Screeening_EnumValue ) | (string_type, xsd:string ) }?& element Profile { (enum_type, Profile_EnumValue ) | (string_type, xsd:string ) }?& element CRD { (enum_type, ColorRenderingDictionary_EnumValue ) | (string_type, xsd:string ) }?& element PageRange { (enum_type, PageRange_EnumValue ) | (string_type, xsd:string ) }?& element PaperSizeRect { RectangleBoundsType_TypeDef }?& element ImageablePaperSizeRect { RectangleBoundsType_TypeDef }? } ? }
```

**Table 165**: Print  Preference Properties Represented as Attributes

| Name               | Type      | Req     | Description |
| ------------------ | --------- | ------- | -------------------------------------------------------------------------------------------------------------------- |
| AllPrinterMarks    | boolean   | no      | If true, prints all printer marks. If false, prints specified printer marks. |
| BitmapPrinting     | boolean   | no      | If true, uses bitmap printing. |
| BitmapResolution   | int       | no      | The resolution for bitmap printing. (Range: 72 to 1200) Note: Valid when bitmap printing is true. |
| BlackAngle         | double    | no      | The angle override for black ink. (Range: 0 to 360) |
| BlackFrequency     | double    | no      | The frequency override for black ink. (Range: 1 to 500) |
| BleedBottom        | double    | no      | The height of the bleed area at the bottom of the page. Note: Valid only when use document bleed to print is true. |

| Name                    | Type                          | Req     | Description |
| ----------------------- | ----------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BleedChain              | boolean                       | no      | If true, forces all bleed area settings to be the same, using the most recent bleed measurement setting. If false, allows bleed top, bleed bottom, bleed inside, and bleed outside to have different measurements. |
| BleedInside             | double                        | no      | The width of the bleed area at the inside of the page. Note: Valid only when use document bleed to print is true. (Range: 0 to 432) |
| BleedMarks              | boolean                       | no      | If true, print bleed marks. |
| BleedOutside            | double                        | no      | The width of the bleed area at the outside of the page. Note: Valid only when use document bleed to print is true. (Range: 0 to 432) |
| BleedTop                | double                        | no      | The height of the bleed area at the top of the page. Note: Valid only when use document bleed to print is true. (Range: 0 to 432) |
| Collating               | boolean                       | no      | If true, collate printed copies. |
| ColorBars               | boolean                       | no      | If true, add small squares of color representing the CMYKinks and tints of gray in 10% incre- ments. |
| ColorOutput             | ColorOutputModes_EnumValue   | no      | The color output mode for composites. Note: Not valid when a device-independent PPD is specified. |
| CompositeAngle          | double                        | no      | The screen angle to use when printing compos- ites. (Range: 0 to 360) Note: Valid only for Post- Script or PDF files that use custom screening. |
| Composite Frequency    | double                        | no      | The screen frequency to use when printing com- posites. (Range: 1 to 500) Note: Valid only for PostScript or PDF files that use custom screen- ing. |
| Composite Screening    | string                        | no      | The screening applied to composite printing. |
| Copies                  | int                           | no      | The number of copies to print. Note: Not valid when printer is PostScript File. |
| CropMarks               | boolean                       | no      | Prints crop marks that define where the page should be trimmed. |
| CyanAngle               | double                        | no      | The angle override for cyan ink. (Range: 0 to 360) |
| CyanFrequency           | double                        | no      | The frequency override for cyan ink. (Range: 1 to 500) |
| DataFormat              | DataFormat_Enum Value        | no      | The format in which to send image data to the printer. |
| DeviceType              | int                           | no      | The type of the selected device. |
| DownloadPPDFonts        | boolean                       | no      | If true, downloads all fonts listed in the selected PPD. Valid only when font downloading is com- plete or subset. |
| FlattenerPreset Name   | string                        | no      | The name of the transparency flattener preset. |

| Name                      | Type                          | Req     | Description |
| ------------------------- | ----------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Flip                      | Flip_EnumValue                | no      | The direction in which to flip the printed image. |
| FontDownloading           | FontDownloading_EnumValue    | no      | Controls how fonts are downloaded to the printer. |
| IgnoreSpread Overrides   | boolean                       | no      | If true, ignores flattener spread overrides. |
| IncludeSlugTo Print      | boolean                       | no      | If true, includes the slug area in the printed document. |
| Intent                    | RenderingIntent_EnumValue    | no      | The rendering intent. Note: Valid only when use color management is true. |
| MagentaAngle              | double                        | no      | The angle override for magenta ink. (Range: 0 to 360) |
| MagentaFrequency          | double                        | no      | The frequency override for magenta ink. (Range: 1 to 500) |
| MarkLineWeight            | MarkLineWeight_EnumValue     | no      | The stroke weight (in points) for printer marks. |
| MarkOffset                | double                        | no      | The distance to offset the page marks from the edge of the page. |
| Negative                  | boolean                       | no      | If true, prints the document as a negative. |
| OPIImage Replacement     | boolean                       | no      | If true, prints graphics that are either OPI com- ments stored in imported EPS files or linked using OPI comments. For information on link- ing files using OPI comments, see omit EPS, omit PDF, or omit bitmaps. |
| OmitBitmaps               | boolean                       | no      | If true, replaces bitmap images with OPI links. |
| OmitEPS                   | boolean                       | no      | If true, replaces EPS images with OPI links. |
| OmitPDF                   | boolean                       | no      | If true, replaces PDF images with OPI links. |
| PPDFile                   | string                        | no      | The name of the PDF file. |
| PageInformation Marks    | boolean                       | no      | If true, prints the filename, page number, cur- rent date and time, and color separation name. |
| PagePosition              | PagePositions_EnumValue      | no      | The position of the page on the printing medi- um. Note: Valid only when tile is false. |
| PaperGap                  | double                        | no      | The space between document pages on the print- ing medium. |
| PaperHeightRange          | list { double ,xsd:double }   | no      | Alist of the available paper heights. |
| PaperOffset               | double                        | no      | The amount of space to offset the page from the left edge of the imageable area. |
| PaperOffsetRange          | list { double ,xsd:double }   | no      | Alist of the paper offset ranges. |
| PaperSizeSelector         | string                        | no      | The paper size selector. |
| PaperTransverse           | boolean                       | no      | If true, uses transverse orientation. |
| PaperWidthRange           | list { double ,xsd:double }   | no      | Alist of the available paper widths. |

| Name                     | Type                                 | Req     | Description |
| ------------------------ | ------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PostScriptLevel          | PostScriptLevels_EnumValue          | no      | The PostScript level of the printer. |
| PreserveColor Numbers   | boolean                              | no      | If true, preserves uncalibrated color numbers. |
| PrintBlack               | boolean                              | no      | If true, prints the black ink. Note: Valid only when trapping is off. |
| PrintBlankPages          | boolean                              | no      | If true, prints blank pages. Note: Valid only when trapping is off. |
| PrintCyan                | boolean                              | no      | If true, prints the cyan ink. Note: Valid only when trapping is off. |
| PrintFile                | string                               | no      | The PostScript file to print to. Note: Valid only when the current printer is defined as postscript file. |
| PrintGuidesGrids         | boolean                              | no      | If true, prints visible guides and baseline grids. Note: Valid only when trapping is off. |
| PrintLayers              | PrintLayer Options_EnumValue        | no      | The layers to print. |
| PrintMagenta             | boolean                              | no      | If true, prints the magenta ink. Note: Valid only when trapping is off. |
| PrintMasterPages         | boolean                              | no      | If true, prints master pages. |
| PrintNonprinting         | boolean                              | no      | If true, prints non-printing objects. Note: Valid only when trapping is off. |
| PrintPage Orientation   | PrintPage Orientation_Enum Value   | no      | The orientation of the printed page. |
| PrintRecord              | string                               | no      | Cached data preserving the last print job (main- tained for file round trip). |
| PrintResolution          | double                               | no      | The resolution of the print job. |
| PrintSpreads             | boolean                              | no      | If true, prints each spread with all spread pages on a single sheet. If false, prints spread pages as separate pages. |
| PrintTo                  | int                                  | no      | The index of the selected printer in the list of available printers. |
| PrintToDisk              | boolean                              | no      | If true, print the file to disk as PostScript. |
| PrintYellow              | boolean                              | no      | If true, prints the yellow ink. Note: Valid only when trapping is off. |
| RegistrationMarks        | boolean                              | no      | If true, prints small targets outside the page area for aligning color separations. |
| ReverseOrder             | boolean                              | no      | If true, prints pages in reverse order. |
| ScaleHeight              | double                               | no      | The amount (as a percentage) that the page height is scaled during printing. (Range: 0 to 1000) Note: Valid only when scale mode is scale width height. |
| ScaleMode                | ScaleModes_Enum Value               | no      | The policy for scaling the page. Note: Valid only when printing from Layout view. |

| Name                        | Type                        | Req     | Description |
| --------------------------- | --------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ScaleProportional           | boolean                     | no      | If true, constrains the proportions of the scaling; uses the most recent value for either scale width or scale height to define both values. Note: Valid only when scale mode is scale width height. |
| ScaleWidth                  | double                      | no      | The amount (as a percentage) that the page width is scaled during printing. (Range: 0 to 1000) Note: Valid only when scale mode is scale width height. |
| SendImageData               | ImageDataTypes_EnumValue   | no      | The image data sent to the printer or file. |
| Separation Screening       | string                      | no      | The screening to use when printing separations. |
| Sequence                    | Sequences_Enum Value       | no      | The sequence of pages to print. |
| SimulateOverprint           | boolean                     | no      | If true, simulates the effects of overprinting spot inks with different neutral density values by converting spot colors to process colors for printing. Note: Not valid when the color output mode is defined to leave color profiles unchanged. |
| SourceSpace                 | SourceSpaces_EnumValue     | no      | The source of the color management system. Note: Valid only when use color management is true. |
| SpotAngle                   | double                      | no      | The angle of a spot ink. |
| SpotFrequency               | double                      | no      | The screen frequency of a spot ink. |
| TextAsBlack                 | boolean                     | no      | If true, prints all text as black unless text has the color None or Paper or a color value that equals white. If false, prints colored text, such as blue hyperlinks, in halftone patterns. Note: Valid only when trapping is off. |
| Thumbnails                  | boolean                     | no      | If true, prints thumbnails. Note: Valid only when trapping is off and tile is false. |
| ThumbnailsPerPage           | ThumbsPerPage_EnumValue    | no      | The number of thumbnails per page. |
| Tile                        | boolean                     | no      | If true, tiles pages. |
| TilingOverlap               | double                      | no      | The amount of tiling overlap. Note: Valid only when tiling is true and tiling type is not manual. |
| TilingType                  | TilingTypes_Enum Value     | no      | The tiling type. Note: Valid only when tiling is true. |
| Trapping                    | Trapping_Enum Value        | no      | The type of trapping. |
| UseDocumentBleed ToPrint   | boolean                     | no      | If true, uses the bleed area set for the document. |
| YellowAngle                 | double                      | no      | The angle override for yellow ink. (Range: 0 to 360) |
| YellowFrequency             | double                      | no      | The frequency override for yellow ink. (Range: 1 to 500) |

**Table 166**: Print  Preference Properties Represented as Elements

| Name                       | Type                                               | Req     | Description |
| -------------------------- | -------------------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ActivePrinter Preset      | PrinterPreset Types_EnumValue or string           | no      | The current printer preset, as a Printer PresetTypes enumeration or a reference to the Self attribute of a printer preset. |
| CRD                        | ColorRendering Dictionary_Enum Value or string   | no      | The current CRD, as a ColorRendering Dictionary enumeration or a string containing the name of the CRD. |
| ImageablePaper SizeRect   | RectangleBounds Type_TypeDef                      | no      | Arectangle defining the imageable area of the paper, as a space-separated list of four values (in the order left, top, right, bottom). |
| MarkType                   | MarkTypes_Enum Value or string                    | no      | The type of printer marks, either a MarkTypes enumeration or the name of a custom marks file. |
| PPD                        | PPDValues_Enum Value or string                    | no      | The PPD, specified as a PPDValues enumeration or as the name of the PPD. |
| PageRange                  | PageRange_Enum Value or string                    | no      | The pages to print, specified either as a Page Range enumeration or a string. To specify a range, separate page numbers in the string with a hyphen (-). To specify separate pages, separate page numbers in the string with a comma (,). |
| PaperHeight                | PaperSize_Enum Value or double                    | no      | The paper height, as a PaperSize enumeration or double. Note: Valid only when paper size is custom or scale mode is scale width height. |
| PaperSize                  | PaperSizes_Enum Value or string                   | no      | The paper height, as a PaperSize enumeration or string (the name of the paper size). |
| PaperSizeRect              | RectangleBounds Type_TypeDef                      | no      | Arectangle defining the size of the paper, as a space-separated list of four values (in the order left, top, right, bottom). |
| PaperWidth                 | PaperSize_Enum Value or double                    | no      | The paper width, as a PaperSize enumeration or double. Note: Valid only when paper size is custom or scale mode is scale width height. |
| Printer                    | Printer_EnumValue or string                        | no      | The current printer, as a Printer enumeration or string (name of the printer). |
| Profile                    | Profile_EnumValue or string                        | no      | The color profile, as a Profile enumeration or string (the name of the profile). |
| Screening                  | Screening_Enum Value or string                    |         | The ink screening settings for composite gray output in PostScript or PDF format. |

## 10.7.28 Print  Booklet  Option

The <PrintBookletOption> defines the layout options for the booklet created when you use the Print Booklet feature. The printing options for the booklet are defined by the <PrintBookletPrintPreference> element.

**Schema Example 137. Print  Booklet  Option**

```
PrintBookletOption_Object = element PrintBookletOption { attribute BookletType { BookletTypeOptions_EnumValue }?, attribute SpaceBetweenPages { xsd:double {minInclusive="0" maxInclusive="288"} }?, attribute BleedBetweenPages { xsd:double {minInclusive="0" maxInclusive="144"} }?, attribute Creep { xsd:double {minInclusive="144" maxInclusive="144"} }?, attribute SignatureSize { SignatureSizeOptions_EnumValue }?, attribute TopMargin { xsd:double {minInclusive="0" maxInclusive="288"} }?, attribute BottomMargin { xsd:double {minInclusive="0" maxInclusive="288"} }?, attribute LeftMargin { xsd:double {minInclusive="0" maxInclusive="288"} }?, attribute RightMargin { xsd:double {minInclusive="0" maxInclusive="288"} }?, attribute AutoAdjustMargins { xsd:boolean }?, attribute MarginsUniformSize { xsd:boolean }?, attribute PrintBlankPrinterSpreads { xsd:boolean }?, element Properties { element PageRange { (enum_type, PageRange_EnumValue ) | (string_type, xsd:string ) }? } ? }
```

## 10.7.29 Print  Booklet  Print  Preference

The printing options for the Print Booklet are defined by the <PrintBookletPrintPreference> element. The <PrintBookletOption> defines the layout options for the booklet.

**Schema Example 138. Print  Booklet  Print  Preference**

```
PrintBookletPrintPreference_Object = element PrintBookletPrintPreference { attribute PrinterList { list { xsd:string * } }?, attribute PPDList { list { xsd:string * } }?, attribute PaperSizeList { list { xsd:string * } }?, attribute ScreeningList { list { xsd:string * } }?, attribute PrintFile { xsd:string }?, attribute Copies { xsd:int }?, attribute Collating { xsd:boolean }?, attribute ReverseOrder { xsd:boolean }?, attribute PrintNonprinting { xsd:boolean }?, attribute PrintBlankPages { xsd:boolean }?, attribute PrintGuidesGrids { xsd:boolean }?, attribute PaperOffset { xsd:double }?, attribute PaperGap { xsd:double }?, attribute PaperTransverse { xsd:boolean }?, attribute PrintPageOrientation { PrintPageOrientation_EnumValue }?, attribute PagePosition { PagePositions_EnumValue }?, attribute ScaleMode { ScaleModes_EnumValue }?, attribute ScaleWidth { xsd:double }?, attribute ScaleHeight { xsd:double }?, attribute ScaleProportional { xsd:boolean }?, attribute PrintLayers { PrintLayerOptions_EnumValue }?, attribute AllPrinterMarks { xsd:boolean }?, attribute CropMarks { xsd:boolean }?, attribute BleedMarks { xsd:boolean }?, attribute RegistrationMarks { xsd:boolean }?, attribute ColorBars { xsd:boolean }?, attribute PageInformationMarks { xsd:boolean }?, attribute MarkLineWeight { MarkLineWeight_EnumValue }?, attribute MarkOffset { xsd:double }?, attribute UseDocumentBleedToPrint { xsd:boolean }?, attribute BleedTop { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedBottom { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedInside { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedOutside { xsd:double {minInclusive="0" maxInclusive="432"} }?, attribute BleedChain { xsd:boolean }?, attribute ColorOutput { ColorOutputModes_EnumValue }?, attribute TextAsBlack { xsd:boolean }?, attribute Trapping { Trapping_EnumValue }?, attribute Flip { Flip_EnumValue }?, attribute Negative { xsd:boolean }?, attribute CompositeAngle { xsd:double }?, attribute CompositeFrequency { xsd:double }?, attribute SimulateOverprint { xsd:boolean }?, attribute PrintCyan { xsd:boolean }?, attribute CyanAngle { xsd:double }?, attribute CyanFrequency { xsd:double }?, attribute PrintMagenta { xsd:boolean }?, attribute MagentaAngle { xsd:double }?, attribute MagentaFrequency { xsd:double }?, attribute PrintYellow { xsd:boolean }?, attribute YellowAngle { xsd:double }?, attribute YellowFrequency { xsd:double }?, attribute PrintBlack { xsd:boolean }?, attribute BlackAngle { xsd:double }?, attribute BlackFrequency { xsd:double }?, attribute SendImageData { ImageDataTypes_EnumValue }?, attribute FontDownloading { FontDownloading_EnumValue }?, attribute DownloadPPDFonts { xsd:boolean }?, attribute PostScriptLevel { PostScriptLevels_EnumValue }?, attribute DataFormat { DataFormat_EnumValue }?, attribute SourceSpace { SourceSpaces_EnumValue }?, attribute Intent { RenderingIntent_EnumValue }?, attribute PreserveColorNumbers { xsd:boolean }?, attribute OPIImageReplacement { xsd:boolean }?, attribute OmitEPS { xsd:boolean }?, attribute OmitPDF { xsd:boolean }?, attribute OmitBitmaps { xsd:boolean }?, attribute FlattenerPresetName { xsd:string }?, attribute IgnoreSpreadOverrides { xsd:boolean }?, attribute BitmapPrinting { xsd:boolean }?, attribute BitmapResolution { xsd:int {minInclusive="72" maxInclusive="1200"} }?, attribute DeviceType { xsd:int }?, attribute PrintTo { xsd:int }?, attribute PPDFile { xsd:string }?, attribute PrintToDisk { xsd:boolean }?, attribute PrintRecord { xsd:string }?, attribute PrintResolution { xsd:double }?, attribute PaperSizeSelector { xsd:string }?, attribute PaperHeightRange { list { xsd:double ,xsd:double } }?, attribute PaperWidthRange { list { xsd:double ,xsd:double } }?, attribute PaperOffsetRange { list { xsd:double ,xsd:double } }?, attribute SeparationScreening { xsd:string }?, attribute CompositeScreening { xsd:string }?, attribute SpotAngle { xsd:double }?, attribute SpotFrequency { xsd:double }?, element Properties { element Printer { (enum_type, Printer_EnumValue ) | (string_type, xsd:string ) }?& element PPD { (enum_type, PPDValues_EnumValue ) | (string_type, xsd:string ) }?& element PaperSize { (enum_type, PaperSizes_EnumValue ) | (string_type, xsd:string ) }?& element PaperHeight { (enum_type, PaperSize_EnumValue ) | (unit_type, xsd:double ) }?& element PaperWidth { (enum_type, PaperSize_EnumValue ) | (unit_type, xsd:double ) }?& element MarkType { (enum_type, MarkTypes_EnumValue ) | (string_type, xsd:string ) }?& element Screening { (enum_type, Screeening_EnumValue ) | (string_type, xsd:string ) }?& element Profile { (enum_type, Profile_EnumValue ) | (string_type, xsd:string ) }?& element CRD { (enum_type, ColorRenderingDictionary_EnumValue ) | (string_type, xsd:string ) }?& element ActivePrinterPreset { (enum_type, PrinterPresetTypes_EnumValue ) | (string_type, xsd:string ) }?& element PaperSizeRect { RectangleBoundsType_TypeDef }?& element ImageablePaperSizeRect { RectangleBoundsType_TypeDef }? } ?
```

}

## 10.7.30 Index  Options

The <IndexOptions> element stores settings for index creation. These options have no effect on indices already included in the IDML document.

**Schema Example 139. Index  Options**

```
IndexOptions_Object = element IndexOptions { attribute Title { xsd:string }?, attribute TitleStyle { xsd:string }?, attribute ReplaceExistingIndex { xsd:boolean }?, attribute IncludeBookDocuments { xsd:boolean }?, attribute IncludeHiddenEntries { xsd:boolean }?, attribute IndexFormat { IndexFormat_EnumValue }?, attribute IncludeSectionHeadings { xsd:boolean }?, attribute IncludeEmptyIndexSections { xsd:boolean }?, attribute Level1Style { xsd:string }?, attribute Level2Style { xsd:string }?, attribute Level3Style { xsd:string }?, attribute Level4Style { xsd:string }?, attribute SectionHeadingStyle { xsd:string }?, attribute PageNumberStyle { xsd:string }?, attribute CrossReferenceStyle { xsd:string }?, attribute CrossReferenceTopicStyle { xsd:string }?, attribute FollowingTopicSeparator { xsd:string }?, attribute BetweenEntriesSeparator { xsd:string }?, attribute PageRangeSeparator { xsd:string }?, attribute BetweenPageNumbersSeparator { xsd:string }?, attribute BeforeCrossReferenceSeparator { xsd:string }?, attribute EntryEndSeparator { xsd:string }? }
```

## 10.7.31 Index  Header  Setting

The <IndexHeaderSetting> element stores the strings used by the headers added to the index during index generation. These options have no effect on indices already included in the IDML document.

**Schema Example 140. Index  Header  Setting**

```
IndexHeaderSetting_Object = element IndexHeaderSetting { attribute HeaderSetName { xsd:string }?, attribute HeaderSetLanguage { xsd:int }?, attribute IndexHeaderSetHandler { xsd:int }?, attribute IndexHeaderSetGroupValue { xsd:int }?, attribute IndexHeaderSetGroupOptionValue { xsd:int }?, element Properties { element ListOfIndexHeaderGroup { element IndexHeaderGroupType { IndexHeaderGroupType_TypeDef }* }? } ? }
```

## 10.7.32 Page  Item  Default

The <PageItemDefault> element controls the default page item formatting for an In  Design document. Values that you specify here will apply to all page items that do not explicitly define these attributes and elements. All of the properties of the <PageItemDefault> element can be found in the 'Common Page Item Properites' section.

**Schema Example 141. Page  Item  Default**

```
PageItemDefault_Object = element PageItemDefault { attribute TopLeftCornerOption { CornerOptions_EnumValue }?, attribute TopRightCornerOption { CornerOptions_EnumValue }?, attribute BottomLeftCornerOption { CornerOptions_EnumValue }?, attribute BottomRightCornerOption { CornerOptions_EnumValue }?, attribute TopLeftCornerRadius { xsd:double }?, attribute TopRightCornerRadius { xsd:double }?, attribute BottomLeftCornerRadius { xsd:double }?, attribute BottomRightCornerRadius { xsd:double }?, attribute AppliedGraphicObjectStyle { xsd:string }?, attribute AppliedTextObjectStyle { xsd:string }?, attribute AppliedGridObjectStyle { xsd:string }?, attribute CornerOption { CornerOptions_EnumValue }?, attribute CornerRadius { xsd:double }?, attribute FillColor { xsd:string }?, attribute FillTint { xsd:double }?, attribute StrokeWeight { xsd:double }?, attribute MiterLimit { xsd:double {minInclusive="1" maxInclusive="500"} }?, attribute EndCap { EndCap_EnumValue }?, attribute EndJoin { EndJoin_EnumValue }?, attribute StrokeType { xsd:string }?, attribute LeftLineEnd { ArrowHead_EnumValue }?, attribute RightLineEnd { ArrowHead_EnumValue }?, attribute StrokeColor { xsd:string }?, attribute StrokeTint { xsd:double }?, attribute GradientFillAngle { xsd:double }?, attribute GradientStrokeAngle { xsd:double }?, attribute OverprintStroke { xsd:boolean }?, attribute OverprintFill { xsd:boolean }?, attribute GapColor { xsd:string }?, attribute GapTint { xsd:double }?, attribute OverprintGap { xsd:boolean }?, attribute StrokeAlignment { StrokeAlignment_EnumValue }?, attribute Nonprinting { xsd:boolean }?, ( TransparencySetting_Object?& StrokeTransparencySetting_Object?& FillTransparencySetting_Object?& ContentTransparencySetting_Object? ) }
```

## 10.7.33 Frame  Fitting  Option

The <FrameFittingOption> element controls the default fitting behavior for all page items in a document. Values that you specify here will apply to all page items that do not explicitly define these attributes and elements. For more on frame fitting options, refer to the In  Design documentation.

**Schema Example 142. Frame  Fitting  Option**

```
FrameFittingOption_Object = element FrameFittingOption { attribute AutoFit { xsd:boolean }?, attribute LeftCrop { xsd:double }?, attribute TopCrop { xsd:double }?, attribute RightCrop { xsd:double }?, attribute BottomCrop { xsd:double }?, attribute FittingOnEmptyFrame { EmptyFrameFittingOptions_EnumValue }?, attribute FittingAlignment { AnchorPoint_EnumValue }? }
```

## 10.7.34 Button  Preference

The <ButtonPreference> element controls the default fitting behavior for all buttons in a document. Values that you specify here will apply to all buttons that do not explicitly define these attributes and elements.

**Schema Example 143. Button  Preference**

```
Button  Preference_Object = element Button  Preference { attribute Name { xsd:string }? }
```

## 10.7.35 Tin  Document  DData  Object

**Schema Example 144. Tin  Document  Data  Object**

```
Tin Document  Data Object_Object = element Tin  Document Data  Object { element Properties { element Gaiji  Ref Maps { text }? } ? }
```

## 10.7.36 Layout  Grid  Data  Information

The <LayoutGridDataInformation> element controls the default layout grid for a document.

**Schema Example 145. Layout  Grid  Data  Information**

```
LayoutGridDataInformation_Object = element LayoutGridDataInformation { attribute FontStyle { xsd:string }?, attribute PointSize { xsd:double }?, attribute CharacterAki { xsd:double }?, attribute LineAki { xsd:double }?, attribute HorizontalScale { xsd:double }?, attribute VerticalScale { xsd:double }?, element Properties { element AppliedFont { (object_type, xsd:string ) | (string_type, xsd:string ) }? } ? }
```

## 10.7.37 Story  Grid  Data  Information

The <StoryGridDataInformation> element controls the default story grid for a document.

**Schema Example 146. Story  Grid  Data  Information**

```
StoryGridDataInformation_Object = element StoryGridDataInformation { attribute FontStyle { xsd:string }?, attribute PointSize { xsd:double }?, attribute CharacterAki { xsd:double }?, attribute LineAki { xsd:double }?, attribute HorizontalScale { xsd:double }?, attribute VerticalScale { xsd:double }?, attribute LineAlignment { LineAlignment_EnumValue }?, attribute GridAlignment { GridAlignment_EnumValue }?, attribute CharacterAlignment { CharacterAlignment_EnumValue }?, attribute GridView { GridViewSettings_EnumValue }?, attribute CharacterCountLocation { CharacterCountLocation_EnumValue }?, attribute CharacterCountSize { xsd:double }?, element Properties { element AppliedFont { (object_type, xsd:string ) | (string_type, xsd:string ) }? } ? }
```

## 10.7.38 Cjk  Grid  Preference

**Schema Example 147. Cjk  Grid  Preference**

```
CjkGridPreference_Object = element CjkGridPreference { attribute ShowAllLayoutGrids { xsd:boolean }?, attribute ShowAllFrameGrids { xsd:boolean }?, attribute MinimumScale { xsd:double }?, attribute SnapToLayoutGrid { xsd:boolean }?, attribute ColorEveryNthCell { xsd:short }?, attribute SingleLineColorMode { xsd:boolean }?, attribute ICFMode { xsd:boolean }?, attribute UseCircularCells { xsd:boolean }?, attribute ShowCharacterCount { xsd:boolean }?, element Properties { element LayoutGridColorIndex { InDesignUIColorType_TypeDef }? } ? }
```

**Table 167**: Cjk  Grid  Preference Properties Represented as Attributes

| Name                    | Type      | Req     | Description |
| ----------------------- | --------- | ------- | ------------------------------------------------------------------------------------------------------------------------------- |
| ColorEveryNthCell       | short     | no      | Applies the grid color to every nth cell, where n is the value of this property. |
| ICFMode                 | boolean   | no      | If true, uses ICF mode for grid cells. If false, uses virtual body mode. |
| MinimumScale            | double    | no      | The view magnification (as a percentage) less than which grids do not appear. (Range: 5 to 4000) |
| ShowAllFrameGrids       | boolean   | no      | If true, displays the frame (story) grids. |
| ShowAllLayout Grids    | boolean   | no      | If true, displays the layout grids. |
| ShowCharacter Count    | boolean   | no      | If true, displays the character count for the frame. |
| SingleLineColor Mode   | boolean   | no      | If true, applies the grid color from the the edge of the line. If false, applies the grid color from the corner of the frame. |
| SnapToLayoutGrid        | boolean   | no      | If true, objects snap to the layout grid. |
| UseCircularCells        | boolean   | no      | If true, cell shape is circular. If false, cell shape is rectangular. |

## **Table 168**: Cjk  Grid  Preference Properties Represented as Elements

| Name                     | Type                    | Req     | Description |
| ------------------------ | ----------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| LayoutGridColor Index   | InDesignUIColor Type   | no      | The color of the layout grid as a UIColor enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |

## 10.7.39 Mojikumi  Ui  Preference

The <MojikumiUiPreference> element controls the user interface for Mojikumi.

**Schema Example 148. Mojikumi  Ui  Preference**

```
Mojikumi  Ui Preference_Object = element Mojikumi  Ui  Preference { attribute Mojikumi  Ui Settings { xsd:short }? }
```

**Table 169**: Mojikumi  Ui  Preference Properties Represented as Attributes

| Name                   | Type     | Req     | Description |
| ---------------------- | -------- | ------- | ------------------------------------------------ |
| MojikumiUi Settings   | short    | no      | User interface settings for Mojikumi features. |

## 10.7.40 Chapter  Number  Preference

The <ChapterNumberPreference> element stores information used by chapter numbering text variables in the document.

**Schema Example 149. Chapter  Number  Preference**

```
Chapter  Number Preference_Object = element Chapter  Number  Preference { attribute Chapter  Number { xsd:int }?, attribute Chapter  Number Source { Chapter  Number Sources_Enum  Value }?, element Properties { element Chapter  Number  Format { (enum_type, Numbering  Style_Enum  Value ) | (string_type, xsd:string ) }? } ? }
```

**Table 170**: Chapter  Number  Preference Properties Represented as Attributes

| Name                    | Type                               | Req     | Description |
| ----------------------- | ---------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------- |
| ChapterNumber           | int                                | no      | Chapter number. |
| ChapterNumber Source   | ChapterNumber Sources_EnumValue   | no      | Source for generating the chapter number. Can be UserDefined , ContinueFromPrevious Document , or SameAsPreviousDocument. |

**Table 171**: Chapter  Number  Preference Properties Represented as Elements

| Name                    | Type                                   | Req     | Description |
| ----------------------- | -------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ChapterNumber Format   | NumberingStyle_EnumValue or string.  | no      | The chapter numbering type, as a NumberingStyle enumeration or as a string. The string corresponds to the options found on the Style pop-up menu in the Document Chapter Numbering section of the Num- bering &Section Options dialog box in InDesign's user interface. Can be UpperRoman , LowerRoman , UpperLetters , LowerLetters , Arabic , Kanji , KatakanaModern , KatakanaTraditional , FormatNone , SingleLeadingZeros , ArabicAlifBaTah , ArabicAbjad , HebrewBiblical , HebrewNonStandard , DoubleLeadingZeros , or TripleLeadingZeros. |
