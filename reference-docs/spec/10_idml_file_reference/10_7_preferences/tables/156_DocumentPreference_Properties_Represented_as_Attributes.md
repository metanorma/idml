| Name | Type | Req | Description |
| --------------------------------------- | ------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AllowPageShuffle | boolean | no | If true, guarantees that all new spreads added to the document contain a maximum of two pages. If false, allows pages to be added or moved into existing spreads. For override information, see preserve layout when shuffling. |
| ColumnDirection | HorizontalOrVertical_EnumValue | yes | The direction of text in the column |
| ColumnGuideLocked | boolean | no | If true, locks column guides. |
| DocumentBleedBottomOffset | double | no | The amount to offset the bottom document bleed. Note: To set the bleed bottom offset, document bleed uniform size must be false. |
| DocumentBleedInsideOrLeftOffset | double | no | The amount to offset the inside or left document bleed. Note: To set the bleed inside or left offset, document bleed uniform size must be false. |
| DocumentBleedOutsideOrRightOffset | double | no | The amount to offset the outside or right document bleed. Note: To set the bleed outside or right offset, document bleed uniform size must be false. |
| DocumentBleedTopOffset | double | no | The amount to offset the top document bleed. |
| DocumentBleedUniformSize | boolean | no | If true, uses the document bleed top offset value for bleed offset measurements on all sides of the document. The default setting is true. |
| DocumentSlugUniformSize | boolean | no | If true, uses the slug top offset value for slug measurements on all sides of the document. The default value is false. |
| FacingPages | boolean | no | If true, the document has facing pages. |
| Intent | DocumentIntentOptions_EnumValue | no | Can be PrintIntent or WebIntent. |
| MasterTextFrame | boolean | no | If true, the document A-master has auto text frames. |
| OverprintBlack | boolean | no | If true, overprints black when saving the document. |
| PageBinding | PageBindingOptions_EnumValue | yes | The page binding. Use Default, RightToLeft, or LeftToRight. |
| PageHeight | double | no | The height of the page. |
| PageWidth | double | no | The width of the page. |
| PagesPerDocument | int | no | The number of pages in the document. (Range: 1 to 9999) |
| PreserveLayoutWhenShuffling | boolean | no | If true, preserves the layout of spreads that contained more than two pages when allow page shuffle was turned on. If false, changes multi-page spreads to two-page spreads if the spreads were created or changed since allow page shuffle was turned on. |
| SlugBottomOffset | double | no | The amount to offset the bottom slug. Note: To set the slug bottom offset, document slug uniform size must be false. |
| SlugInsideOrLeftOffset | double | no | The amount to offset the inside or left slug. Note: To set the slug inside or left offset, document slug uniform size must be false. |
| SlugRightOrOutsideOffset | double | no | The amount to offset the outside or right slug. Note: To set the slug right or outside offset, document slug uniform size must be false. |
| SlugTopOffset | double | no | The amount to offset the top slug. |
| SnippetImportUsesOriginalLocation | boolean | no | If true, causes UI-based snippet import to use original location for page items. |
| CreatePrimaryTextFrame | boolean | no | If true, the document A-master has primary TextFrames when a new document is created. |
