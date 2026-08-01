| Name | Type | Req | Description |
| ------------------------ | -------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CopyFormattedImages | boolean | no | If true, copies formatted images to the images subfolder. |
| CopyOptimizedImages | boolean | no | If true, copies optimized images to the images subfolder. |
| CopyOriginalImages | boolean | no | If true, copies original images to the images subfolder. |
| GIFOptionsInterlaced | boolean | no | If true, generates interlaced GIFs. Note: Not valid when image conversion is JPEG. |
| GIFOptionsPalette | GIFOptionsPalette_EnumValue | no | The color palette for GIF conversion. Note: Not valid when image conversion is JPEG. Can be AdaptivePalette, MacintoshPalette, WebPalette, or WindowsPalette. |
| ImageConversion | ImageConversion_EnumValue | no | The file format to use for converted images. Note: Valid only when copy optimized images and/or copy formatted images is true. Can be Automatic, JPEG, or GIF. |
| JPEGOptionsFormat | JPEGOptionsFormat_EnumValue | no | The formatting method for converted JPEG images. Note: Not valid when image conversion is GIF. Can be BaselineEncoding or ProgressiveEncoding. |
| JPEGOptionsQuality | JPEGOptionsQuality_EnumValue | no | The quality of converted JPEG images. Note: Not valid when image conversion is GIF. Can be Low, Medium, High, or Maximum. |
