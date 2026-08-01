| Name | Type | Req | Description |
| ------------------------------ | --------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AllowTransform | boolean | no | If true, transforms the XML using an XSLT file. |
| CharacterReferences | boolean | no | If true, replaces special characters with character references. |
| CopyFormattedImages | boolean | no | If true, copies formatted images to the images subfolder. |
| CopyOptimizedImages | boolean | no | If true, copies optimized images to the images subfolder. |
| CopyOriginalImages | boolean | no | If true, copies original images to the images subfolder. |
| ExcludeDtd | boolean | no | If true, excludes the DTD from the exported XML Content. |
| ExportFromSelected | boolean | no | If true, exports XML Content from the selected XML element. If false, exports the entire document. |
| ExportUntaggedTablesFormat | XMLExportUntaggedTablesFormat_EnumValue | no | The export format for untagged tables in tagged stories. Can be None or CALS. |
| FileEncoding | XMLFileEncoding_EnumValue | no | The file encoding type for exporting XML content. Can be UTF8, UTF16, or ShiftJIS. |
| GIFOptionsInterlaced | boolean | no | If true, generates interlaced GIFs. Note: Not valid when image conversion is JPEG. |
| GIFOptionsPalette | GIFOptionsPalette_EnumValue | no | The color palette for GIF conversion. Note: Not valid when image conversion is JPEG. Can be AdaptivePalette, MacintoshPalette, WebPalette, or WindowsPalette. |

| Name | Type | Req | Description |
| ---------------------- | -------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ImageConversion | ImageConversion_EnumValue | no | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic, JPEG, or GIF. |
| JPEGOptionsFormat | JPEGOptionsFormat_EnumValue | no | The formatting method for converted JPEG images. Note: Not valid when image conversion is GIF. Can be BaselineEncoding or ProgressiveEncoding. |
| JPEGOptionsQuality | JPEGOptionsQuality_EnumValue | no | The quality of converted JPEG images. Note: Not valid when image conversion is GIF. Can be Low, Medium, High, or Maximum. |
| Ruby | boolean | no | If true, includes Ruby text in the exported XML content. |
| ViewAfterExport | boolean | no | If true, displays exported XML Content in a specified viewer. |
