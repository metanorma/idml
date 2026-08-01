| Name | Type | Req | Description |
| ---------------------------- | --------------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| IncludeDocumentMetadata | boolean | no | If true, output document metadata into the exported ePub. |
| EpubPublisher | string | no | The name of the ePub publisher. |
| ExportOrder | ExportOrder_EnumValue | no | The order in which to export the ePub. Can be ArticlePanelOrder, LayoutOrder, or XmlStructureOrder. |
| EpubCover | EpubCover_EnumValue | no | The ePub cover option. Can be ExternalImage, FirstPage, or None. |
| CoverImageFile | string | no | The file path to the external image (if EpubCover is ExternalImage). |
| BulletExportOption | BulletListExportOption_EnumValue | no | Defines the method used to export bullets to the ePub. Can be AsText (convert the bullets to text characters) or UnorderedList (convert the bullets to an HTML unordered list). |
| NumberedListExportOption | NumberedListExportOption_EnumValue | no | Defines the method used to export numbered lists to the ePub. Can be AsText (convert the numbers to text characters), OrderedList (convert the list to an HTML ordered list), or StaticOrderedList (convert the list to an HTML static ordered list). |
| LeftMargin | double | no | Left margin of the ePub (in units defined by the MarginUnit attribute). |
| RightMargin | double | no | Right margin of the ePub (in units defined by the MarginUnit attribute). |
| TopMargin | double | no | Top margin of the ePub (in units defined by the MarginUnit attribute). |
| BottomMargin | double | no | Bottom margin of the ePub (in units defined by the MarginUnit attribute). |
| MarginUnit | SpaceUnitType_EnumValue | no | The measurement units to use for the margins of the exported ePub. Can be CssEm or CssPixel. |
| ViewDocumentAfterExport | boolean | no | If true, display the exported ePub after the export process is complete. |
| ImageExportResolution | ImageResolution_EnumValue | no | Sets the resolution of images in the exported ePub. Can be Ppi150, Ppi300, Ppi72, or Ppi96. |
| CustomImageSizeOption | ImageSizeOption_EnumValue | no | Sets the custom image size. Can be SizeFixed or SizeRelativeToPageWidth. |
| PreserveLayoutAppearence | boolean | no | If true, format image based on layout appearance. |
| ImageAlignment | ImageAlignmentType_EnumValue | no | Alignment applied to images. Can be AlignCenter, AlignRight, or AlignLeft. |
| ImageSpaceBefore | double (0 to 8640) | no | Space before applied to images (in units defined by the SpaceUnit attribute). |
| ImageSpaceAfter | double (0 to 8640) | no | Space after applied to images (in units defined by the SpaceUnit attribute). |
| SpaceUnit | SpaceUnitType_EnumValue | no | The measurement units to use in the exported ePub. Can be CssEm or CssPixel. |
| ApplyImageAlignmentToAnchoredObjectSettings | boolean | no | If true, apply image alignment to anchored object settings. |
| UseImagePageBreak | boolean | no | If true, image page break settings will be used in objects. |
| ImagePageBreak | ImagePageBreakType_EnumValue | no | Image page break settings to be used with objects (when UseImagePageBreak is true). Can be PageBreakBefore, PageBreakAfter, or PageBreakBeforeAndAfter. |
| ImageConversion | ImageConversion_EnumValue | no | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic, Gif, Jpeg, or Png. |
| GIFOptionsPalette | GIFOptionsPalette_EnumValue | no | The color palette for GIF conversion. Note: Not valid when ImageConversion is Jpeg. Can be AdaptivePalette, MacintoshPalette, WebPalette, or WindowsPalette. |
| GIFOptionsInterlaced | boolean | no | If true, use interlaced GIF (valid when ImageConversion is Gif). |
| JPEGOptionsQuality | JPEGOptionsQuality_EnumValue | no | The quality of converted JPEG images. Note: Not valid when image conversion is Gif. Can be High, Low, Maximum, or Minimum. |
| JPEGOptionsFormat | JPEGOptionsFormat_EnumValue | no | The formatting method for converted JPEG images. Note: Not valid when image conversion is Gif. Can be BaselineEncoding or ProgressiveEncoding. |
| Level | int | no | The PNG compression level (when ImageConversion is Png). |
| IgnoreObjectConversionSettings | boolean | no | If true, ignore object level image conversion settings. |
| Format | boolean | no | If true, export ePub in XHTML format. Otherwise, export using the DTBook format. |
| UseTocStyle | boolean | no | If true, use InDesign TOC style to generate the ePub TOC. |
| TocStyleName | string | no | The name of TOC style to use to generate the ePub TOC (when UseTocStyle is true). |
| BreakDocument | boolean | no | If true, break the InDesign document into smaller pieces when generating the ePub. |
| ParagraphStyleName | string | no | The name of paragraph style to use in breaking the InDesign document into smaller pieces (when BreakDocument is true). |
| FootnoteFollowParagraph | boolean | no | If true, output footnotes immediately after the paragraph containing the footnote reference. |
| StripSoftReturn | boolean | no | If true, strip soft returns on export. |
| CSSExportOption | StyleSheetExportOption_EnumValue | no | The cascading style sheet export option. Can be EmbeddedCss, ExternalCss, none, or StyleNameOnly. |
| IncludeCSSDefinition | boolean | no | If true, include the CSS definitions in the exported ePub (used when CSSExportOption is EmbeddedCss). |
| PreserveLocalOverride | boolean | no | If true, export the local style overrides. |
| EmbedFont | boolean | no | If true, embed fonts in the exported ePub. |
| ExternalCSSPath | string | no | The path to the external CSS stylesheet (when CSSExportOption is ExternalCss). |
