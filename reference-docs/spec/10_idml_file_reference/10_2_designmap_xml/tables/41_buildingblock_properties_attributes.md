| Name                      | Type                             | Req     | Description |
| ------------------------- | -------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AppliedCharacterStyle   | string                           | no      | Areference to the CharacterStyle applied to the cross reference format (as the value of the Self attribute of the <CharacterStyle>). A reference to the CharacterStyle applied to the text variable (as the value of the Self attribute of the <CharacterStyle>). |
| AppliedDelimiter          | string                           | no      | The delimiter character of the building block. |
| BlockType                 | BuildingBlockTypes_EnumValue   | no      | The type of the building block. Can be CustomStringBuildingBlock, FileNameBuildingBlock, ChapterNumberBuildingBlock, PageNumberBuildingBlock, FullParagraphBuildingBlock, ParagraphNumberBuildingBlock, ParagraphTextBuildingBlock, or BookmarkNameBuildingBlock. |
| CustomText                | string                           | no      | The text of the building block. Valid only when the BlockType is CustomStringBuilding Block. |

| Name               | Type      | Req     | Description |
| ------------------ | --------- | ------- | --------------------------------------------------------------------------- |
| IncludeDelimiter   | boolean   | no      | If true, include the delimiter character in the building block instances. |
