| Name | Type | Req | Description |
| -------------------------- | --------- | ------- | ------------------------------------------------------------------------------------------------------------------ |
| AllowTransform | boolean | no | If true, transforms the XML using an XSLT file. |
| CreateLinkToXML | boolean | no | If true, creates a link to the imported XML file. If false, embeds the file. |
| IgnoreUnmatchedIncoming | boolean | no | If true, ignores elements that do not match the existing structure. Note: Valid only when import style is merge. |
| IgnoreWhitespace | boolean | no | If true, leaves existing content in place if the matching XML Content contains only whitespace characters such as a carriage return or a tab character. Note: Valid only when import style is merge. |
| ImportCALSTables | boolean | no | If true, imports CALS tables as InDesign tables. |
| ImportStyle | XMLImportStyles_EnumValue | no | The style of incorporating imported XML content into the document. Can be AppendImport or MergeImport. |
| ImportTextIntoTables | boolean | no | If true, imports text into tables if tags match placeholder tables and their cells. Note: Valid only when import style is MergeImport. |
| ImportToSelected | boolean | no | If true, imports into the selected XML element. If false, imports at the root element. |
| RemoveUnmatchedExisting | boolean | no | If true, deletes existing elements or placeholders in the document that do not have matches in the XML file. Note: Valid only when import style is MergeImport. |
| RepeatTextElements | boolean | no | If true, repeating text elements inherit the formatting applied to placeholder text. Note: Valid only when import style is MergeImport. |
