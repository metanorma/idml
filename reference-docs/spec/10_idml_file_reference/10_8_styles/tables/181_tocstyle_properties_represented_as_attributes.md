| Name                     | Type                                      | Req     | Description |
| ------------------------ | ----------------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CreateBookmarks          | boolean                                   | no      | If true, creates bookmarks for TOC entries. |
| IncludeBookDocuments   | boolean                                   | no      | If true, includes the entire book in the TOC. If false, includes only the TOC entries in the current document. Note: Valid when the current document is part of a book. |
| IncludeHidden            | boolean                                   | no      | If true, the TOC includes entries from text on hidden layers (this applies to the next TOC gen- erated by a user, not to a TOC that has already been placed in a document). |
| Name                     | string                                    | no      | The name of the TOCStyle. |
| NumberedParagraphs     | NumberedParagraphsOptions_EnumValue         | no      | The format for importing numbered paragraphs into the TOC. Can be IncludeFullParagraph, IncludeNumbersOnly, or ExcludeNumbers. |
| RunIn                    | boolean                                   | no      | If true, the lowest-level TOC entries are placed on the same line as the previous entry. |
| SetStoryDirection        | HorizontalOrVertical_EnumValue             | no      | The table of contents StoryDirection. Can be LeftToRightDirection or RightToLeftDirection. |
| Title                    | string                                    | no      | The TOC title. |
| TitleStyle               | string                                    | no      | The paragraph style applied to the TOC title. |
