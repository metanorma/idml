| Name | Type | Req | Description |
| -------------------------- | -------------------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ActivePrinterPreset | PrinterPresetTypes_EnumValue or string | no | The current printer preset, as a PrinterPresetTypes enumeration or a reference to the Self attribute of a printer preset. |
| CRD | ColorRenderingDictionary_EnumValue or string | no | The current CRD, as a ColorRenderingDictionary enumeration or a string containing the name of the CRD. |
| ImageablePaperSizeRect | RectangleBoundsType_TypeDef | no | A rectangle defining the imageable area of the paper, as a space-separated list of four values (in the order left, top, right, bottom). |
| MarkType | MarkTypes_EnumValue or string | no | The type of printer marks, either a MarkTypes enumeration or the name of a custom marks file. |
| PPD | PPDValues_EnumValue or string | no | The PPD, specified as a PPDValues enumeration or as the name of the PPD. |
| PageRange | PageRange_EnumValue or string | no | The pages to print, specified either as a PageRange enumeration or a string. To specify a range, separate page numbers in the string with a hyphen (-). To specify separate pages, separate page numbers in the string with a comma (,). |
| PaperHeight | PaperSize_EnumValue or double | no | The paper height, as a PaperSize enumeration or double. Note: Valid only when paper size is custom or scale mode is scale width height. |
| PaperSize | PaperSizes_EnumValue or string | no | The paper height, as a PaperSize enumeration or string (the name of the paper size). |
| PaperSizeRect | RectangleBoundsType_TypeDef | no | A rectangle defining the size of the paper, as a space-separated list of four values (in the order left, top, right, bottom). |
| PaperWidth | PaperSize_EnumValue or double | no | The paper width, as a PaperSize enumeration or double. Note: Valid only when paper size is custom or scale mode is scale width height. |
| Printer | Printer_EnumValue or string | no | The current printer, as a Printer enumeration or string (name of the printer). |
| Profile | Profile_EnumValue or string | no | The color profile, as a Profile enumeration or string (the name of the profile). |
| Screening | Screening_EnumValue or string | | The ink screening settings for composite gray output in PostScript or PDF format. |
