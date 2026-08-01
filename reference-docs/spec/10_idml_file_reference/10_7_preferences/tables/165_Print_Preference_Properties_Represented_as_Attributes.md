| Name | Type | Req | Description |
| ------------------ | --------- | ------- | -------------------------------------------------------------------------------------------------------------------- |
| AllPrinterMarks | boolean | no | If true, prints all printer marks. If false, prints specified printer marks. |
| BitmapPrinting | boolean | no | If true, uses bitmap printing. |
| BitmapResolution | int | no | The resolution for bitmap printing. (Range: 72 to 1200) Note: Valid when bitmap printing is true. |
| BlackAngle | double | no | The angle override for black ink. (Range: 0 to 360) |
| BlackFrequency | double | no | The frequency override for black ink. (Range: 1 to 500) |
| BleedBottom | double | no | The height of the bleed area at the bottom of the page. Note: Valid only when use document bleed to print is true. |

| Name | Type | Req | Description |
| ----------------------- | ----------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BleedChain | boolean | no | If true, forces all bleed area settings to be the same, using the most recent bleed measurement setting. If false, allows bleed top, bleed bottom, bleed inside, and bleed outside to have different measurements. |
| BleedInside | double | no | The width of the bleed area at the inside of the page. Note: Valid only when use document bleed to print is true. (Range: 0 to 432) |
| BleedMarks | boolean | no | If true, print bleed marks. |
| BleedOutside | double | no | The width of the bleed area at the outside of the page. Note: Valid only when use document bleed to print is true. (Range: 0 to 432) |
| BleedTop | double | no | The height of the bleed area at the top of the page. Note: Valid only when use document bleed to print is true. (Range: 0 to 432) |
| Collating | boolean | no | If true, collate printed copies. |
| ColorBars | boolean | no | If true, add small squares of color representing the CMYK inks and tints of gray in 10% increments. |
| ColorOutput | ColorOutputModes_EnumValue | no | The color output mode for composites. Note: Not valid when a device-independent PPD is specified. |
| CompositeAngle | double | no | The screen angle to use when printing composites. (Range: 0 to 360) Note: Valid only for PostScript or PDF files that use custom screening. |
| CompositeFrequency | double | no | The screen frequency to use when printing composites. (Range: 1 to 500) Note: Valid only for PostScript or PDF files that use custom screening. |
| CompositeScreening | string | no | The screening applied to composite printing. |
| Copies | int | no | The number of copies to print. Note: Not valid when printer is PostScript File. |
| CropMarks | boolean | no | Prints crop marks that define where the page should be trimmed. |
| CyanAngle | double | no | The angle override for cyan ink. (Range: 0 to 360) |
| CyanFrequency | double | no | The frequency override for cyan ink. (Range: 1 to 500) |
| DataFormat | DataFormat_EnumValue | no | The format in which to send image data to the printer. |
| DeviceType | int | no | The type of the selected device. |
| DownloadPPDFonts | boolean | no | If true, downloads all fonts listed in the selected PPD. Valid only when font downloading is complete or subset. |
| FlattenerPresetName | string | no | The name of the transparency flattener preset. |

| Name | Type | Req | Description |
| ------------------------- | ----------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Flip | Flip_EnumValue | no | The direction in which to flip the printed image. |
| FontDownloading | FontDownloading_EnumValue | no | Controls how fonts are downloaded to the printer. |
| IgnoreSpreadOverrides | boolean | no | If true, ignores flattener spread overrides. |
| IncludeSlugToPrint | boolean | no | If true, includes the slug area in the printed document. |
| Intent | RenderingIntent_EnumValue | no | The rendering intent. Note: Valid only when use color management is true. |
| MagentaAngle | double | no | The angle override for magenta ink. (Range: 0 to 360) |
| MagentaFrequency | double | no | The frequency override for magenta ink. (Range: 1 to 500) |
| MarkLineWeight | MarkLineWeight_EnumValue | no | The stroke weight (in points) for printer marks. |
| MarkOffset | double | no | The distance to offset the page marks from the edge of the page. |
| Negative | boolean | no | If true, prints the document as a negative. |
| OPIImageReplacement | boolean | no | If true, prints graphics that are either OPI comments stored in imported EPS files or linked using OPI comments. |
| OmitBitmaps | boolean | no | If true, replaces bitmap images with OPI links. |
| OmitEPS | boolean | no | If true, replaces EPS images with OPI links. |
| OmitPDF | boolean | no | If true, replaces PDF images with OPI links. |
| PPDFile | string | no | The name of the PDF file. |
| PageInformationMarks | boolean | no | If true, prints the filename, page number, current date and time, and color separation name. |
| PagePosition | PagePositions_EnumValue | no | The position of the page on the printing medium. Note: Valid only when tile is false. |
| PaperGap | double | no | The space between document pages on the printing medium. |
| PaperHeightRange | list { double, xsd:double } | no | A list of the available paper heights. |
| PaperOffset | double | no | The amount of space to offset the page from the left edge of the imageable area. |
| PaperOffsetRange | list { double, xsd:double } | no | A list of the paper offset ranges. |
| PaperSizeSelector | string | no | The paper size selector. |
| PaperTransverse | boolean | no | If true, uses transverse orientation. |
| PaperWidthRange | list { double, xsd:double } | no | A list of the available paper widths. |

| Name | Type | Req | Description |
| ------------------------ | ------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| PostScriptLevel | PostScriptLevels_EnumValue | no | The PostScript level of the printer. |
| PreserveColorNumbers | boolean | no | If true, preserves uncalibrated color numbers. |
| PrintBlack | boolean | no | If true, prints the black ink. Note: Valid only when trapping is off. |
| PrintBlankPages | boolean | no | If true, prints blank pages. Note: Valid only when trapping is off. |
| PrintCyan | boolean | no | If true, prints the cyan ink. Note: Valid only when trapping is off. |
| PrintFile | string | no | The PostScript file to print to. Note: Valid only when the current printer is defined as postscript file. |
| PrintGuidesGrids | boolean | no | If true, prints visible guides and baseline grids. Note: Valid only when trapping is off. |
| PrintLayers | PrintLayerOptions_EnumValue | no | The layers to print. |
| PrintMagenta | boolean | no | If true, prints the magenta ink. Note: Valid only when trapping is off. |
| PrintMasterPages | boolean | no | If true, prints master pages. |
| PrintNonprinting | boolean | no | If true, prints non-printing objects. Note: Valid only when trapping is off. |
| PrintPageOrientation | PrintPageOrientation_EnumValue | no | The orientation of the printed page. |
| PrintRecord | string | no | Cached data preserving the last print job (maintained for file round trip). |
| PrintResolution | double | no | The resolution of the print job. |
| PrintSpreads | boolean | no | If true, prints each spread with all spread pages on a single sheet. If false, prints spread pages as separate pages. |
| PrintTo | int | no | The index of the selected printer in the list of available printers. |
| PrintToDisk | boolean | no | If true, print the file to disk as PostScript. |
| PrintYellow | boolean | no | If true, prints the yellow ink. Note: Valid only when trapping is off. |
| RegistrationMarks | boolean | no | If true, prints small targets outside the page area for aligning color separations. |
| ReverseOrder | boolean | no | If true, prints pages in reverse order. |
| ScaleHeight | double | no | The amount (as a percentage) that the page height is scaled during printing. (Range: 0 to 1000) Note: Valid only when scale mode is scale width height. |
| ScaleMode | ScaleModes_EnumValue | no | The policy for scaling the page. Note: Valid only when printing from Layout view. |

| Name | Type | Req | Description |
| --------------------------- | --------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ScaleProportional | boolean | no | If true, constrains the proportions of the scaling; uses the most recent value for either scale width or scale height to define both values. Note: Valid only when scale mode is scale width height. |
| ScaleWidth | double | no | The amount (as a percentage) that the page width is scaled during printing. (Range: 0 to 1000) Note: Valid only when scale mode is scale width height. |
| SendImageData | ImageDataTypes_EnumValue | no | The image data sent to the printer or file. |
| SeparationScreening | string | no | The screening to use when printing separations. |
| Sequence | Sequences_EnumValue | no | The sequence of pages to print. |
| SimulateOverprint | boolean | no | If true, simulates the effects of overprinting spot inks with different neutral density values by converting spot colors to process colors for printing. Note: Not valid when the color output mode is defined to leave color profiles unchanged. |
| SourceSpace | SourceSpaces_EnumValue | no | The source of the color management system. Note: Valid only when use color management is true. |
| SpotAngle | double | no | The angle of a spot ink. |
| SpotFrequency | double | no | The screen frequency of a spot ink. |
| TextAsBlack | boolean | no | If true, prints all text as black unless text has the color None or Paper or a color value that equals white. If false, prints colored text, such as blue hyperlinks, in halftone patterns. Note: Valid only when trapping is off. |
| Thumbnails | boolean | no | If true, prints thumbnails. Note: Valid only when trapping is off and tile is false. |
| ThumbnailsPerPage | ThumbsPerPage_EnumValue | no | The number of thumbnails per page. |
| Tile | boolean | no | If true, tiles pages. |
| TilingOverlap | double | no | The amount of tiling overlap. Note: Valid only when tiling is true and tiling type is not manual. |
| TilingType | TilingTypes_EnumValue | no | The tiling type. Note: Valid only when tiling is true. |
| Trapping | Trapping_EnumValue | no | The type of trapping. |
| UseDocumentBleedToPrint | boolean | no | If true, uses the bleed area set for the document. |
| YellowAngle | double | no | The angle override for yellow ink. (Range: 0 to 360) |
| YellowFrequency | double | no | The frequency override for yellow ink. (Range: 1 to 500) |
