| Name                     | Type                     | Req     | Description |
| ------------------------ | ------------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| ContinueNumbering        | boolean                  | no      | If true, continue page numbering from the pre- vious section in the document. |
| IncludeSectionPrefix   | boolean                  | no      | If true, include the value of the SectionPrefix attribute in the nameo of the section. |
| Length                   | int                      | no      | The number of pages in the section. |
| Marker                   | string                   | no      | The marker character for the section. |
| Name                     | string                   | no      | The name of the section. |
| PageNumberStart          | int                      | no      | The starting page number of the section. Range: 1 to 999999. |
| PageNumberStyle          | PageNumber_EnumStyle   | no      | The page numbering style applied to the section. Can be UpperRoman, LowerRoman, UpperLetters, LowerLetters, Arabic, Kanji, DoubleLeadingZeros, TripleLeadingZeros, ArabicAlifBaTah, ArabicAbjad, HebrewBiblical, or HebrewNonStandard. |
| PageStart                | string                   | no      | Areference to the page that starts the section (as the value of the Self attribute of the <Page> element). |
| SectionPrefix            | string                   | no      | The prefix for the section. |
| AlternateLayoutLength   | int                           | no      | The number of pages in the alternate layout sec- tion. |
| AlternateLayout           | string                        | no      | The alternate layout name for a set of pages. |
| Pagination                | PaginationOption_EnumValue   | no      | The pagination option for this section for adding and removing pages in HTML5. |
| PaginationMaster          | string                        | no      | The master to apply when pages are added in HTML5. |
