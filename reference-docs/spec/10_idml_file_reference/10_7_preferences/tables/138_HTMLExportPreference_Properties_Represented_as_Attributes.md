| Name | Type | Req | Description |
| ----------------- | --------- | ------- | -------------------------------- |
| ExportSelection | boolean | no | If true, export the selection. |

| Name | Type | Req | Description |
| ---------------------------- | --------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ExportOrder | ExportOrder_EnumValue | no | The order in which to export HTML. Can be ArticlePanelOrder, LayoutOrder, or XmlStructureOrder. |
| BulletExportOption | BulletListExportOption_EnumValue | no | Defines the method used to export bullets to the HTML. Can be AsText (convert the bullets to text characters) or UnorderedList (convert the bullets to an HTML unordered list). |
| NumberedListExportOption | NumberedListExportOption_EnumValue | no | Defines the method used to export numbered lists to HTML. Can be AsText (convert the numbers to text characters), OrderedList (convert the list to an HTML ordered list), or StaticOrderedList (convert the list to an HTML static ordered list). |
| LeftMargin | double | no | Left margin of the HTML (in units defined by the MarginUnit attribute). |
| RightMargin | double | no | Right margin of the HTML (in units defined by the MarginUnit attribute). |
| TopMargin | double | no | Top margin of the HTML (in units defined by the MarginUnit attribute). |
| BottomMargin | double | no | Bottom margin of the HTML (in units defined by the MarginUnit attribute). |
| MarginUnit | SpaceUnitType_EnumValue | no | The measurement units for the margins of the exported HTML. Can be CssEm or CssPixel. |
| ViewDocumentAfterExport | boolean | no | If true, display the exported HTML after the export process is complete. |
| ImageExportOption | ImageExportOption_EnumValue | no | Controls the method used to export images. Can be LinkToServer, OptimizedImage, or OriginalImage. |
| ImageExportResolution | ImageResolution_EnumValue | no | Sets the resolution of images in the exported HTML. Can be Ppi150, Ppi300, Ppi72, or Ppi96. |
| CustomImageSizeOption | ImageSizeOption_EnumValue | no | Sets the custom image size. Can be SizeFixed or SizeRelativeToPageWidth. |
| PreserveLayoutAppearence | boolean | no | If true, format image based on layout appearance. |
| ImageAlignment | ImageAlignmentType_EnumValue | no | Alignment applied to images. Can be AlignCenter, AlignRight, or AlignLeft. |
| ImageSpaceBefore | double (0 to 8640) | no | Space before applied to images (in units defined by the SpaceUnit attribute). |
| ImageSpaceAfter | double (0 to 8640) | no | Space after applied to images (in units defined by the SpaceUnit attribute). |
| SpaceUnit | SpaceUnitType_EnumValue | no | The measurement units to use in the exported HTML. Can be CssEm or CssPixel. |
| ApplyImageAlignmentToAnchoredObjectSettings | boolean | no | If true, apply image alignment to anchored object settings. |
| ImageConversion | ImageConversion_EnumValue | no | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic, Gif, Jpeg, or Png. |
| GIFOptionsPalette | GIFOptionsPalette_EnumValue | no | The color palette for GIF conversion. Note: Not valid when ImageConversion is Jpeg. Can be AdaptivePalette, MacintoshPalette, WebPalette, or WindowsPalette. |
| GIFOptionsInterlaced | boolean | no | If true, use interlaced GIF (valid when ImageConversion is Gif). |
| JPEGOptionsQuality | JPEGOptionsQuality_EnumValue | no | The quality of converted JPEG images. Note: Not valid when image conversion is Gif. Can be High, Low, Maximum, or Minimum. |
| JPEGOptionsFormat | JPEGOptionsFormat_EnumValue | no | The formatting method for converted JPEG images. Note: Not valid when image conversion is Gif. Can be BaselineEncoding or ProgressiveEncoding. |
| Level | int | no | The PNG compression level (when ImageConversion is Png). |
| IgnoreObjectConversionSettings | boolean | no | If true, ignore object level image conversion settings. |
| ServerPath | string | no | The server path for exported images (when ImageExportOption is LinkToServer). |
| ImageExtension | string | no | The extension for exported images (when ImageExportOption is LinkToServer). |
| CSSExportOption | StyleSheetExportOption_EnumValue | no | The cascading style sheet export option. Can be EmbeddedCss, ExternalCss, none, or StyleNameOnly. |
| IncludeCSSDefinition | boolean | no | If true, include the CSS definitions in the exported HTML (used when CSSExportOption is EmbeddedCss). |
| PreserveLocalOverride | boolean | no | If true, export the local style overrides. |
| ExternalCSSPath | string | no | The path to the external CSS stylesheet (when CSSExportOption is ExternalCss). |
| LinkToJavascript | boolean | no | If true, link to JavaScript on the server. |
| JavascriptURL | string | no | The path to the server containing the JavaScript associated with the exported HTML (when LinkToJavascript is true). |
