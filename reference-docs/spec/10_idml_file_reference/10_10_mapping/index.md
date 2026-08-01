## 10.10 Mapping

The <XMLExportMap> and <XMLImportMap> elements define the tag to style and style to tag mappings in an IDML document. For more on mapping XML tags to paragraph and character styles, refer to the In  Design online help.

**Schema Example 175. XMLExportMap**

```rnc
XMLExportMap_Object = element XMLExportMap { attribute Self { xsd:string }, attribute MarkupTag { xsd:string }, attribute MappedStyle { xsd:string }, attribute IncludeMasterPageStories { xsd:boolean }?, attribute IncludePasteboardStories { xsd:boolean }?, attribute IncludeEmptyStories { xsd:boolean }? }
```

**Table 191**: XMLExportMap Properties Represented as Attributes

| Name                         | Type      | Req     | Description |
| ---------------------------- | --------- | ------- | -------------------------------------------------------------------------------------------------------------------------- |
| MarkupTag                    | string    | yes     | Areference to an <XMLTag> element in the IDML package (as a reference to its Self attri- bute). |
| MappedStyle                  | string    | yes     | Areference to a <ParagraphStyle> or <CharacterStyle> element in the IDML package (as a reference to its Self attribute). |
| IncludeMasterPageStories   | boolean   | no      | If true, map stories that appear only on master spreads. |
| IncludePasteboardStories   | boolean   | no      | If true, map stories that appear only on the pasteboard. |
| IncludeEmptyStories        | boolean   | no      | If true, map the stories that have no content. |

**IDML Example 98. XMLExportMap**

```xml
<XMLExportMap Self="dicd" MarkupTag="XMLTag\cheading_1" MappedStyle="ParagraphStyle\cheading 1" IncludeMasterPageIncludePasteboardStories="false" IncludeEmptyStories="false"/> 
```

**Schema Example 176. XMLImportMap** 

```rnc
XMLImportMap_Object = element XMLImportMap { attribute Self { xsd:string }, attribute MarkupTag { xsd:string }, attribute MappedStyle { xsd:string } }
```

**Table 192**: XMLImportMap Properties Represented as Attributes

| Name          | Type     | Req     | Description |
| ------------- | -------- | ------- | ---------------------------------------------------------------------------------------------------------------------------- |
| MarkupTag     | string   | yes     | Areference to an <XMLTag> element in the IDML package (as a reference to its Self attri- bute). |
| MappedStyle   | string   | yes     | Areference to a <ParagraphStyle> or <CharacterStyle> element in the IDML pack- age (as a reference to its Self attribute). |

**IDML Example 99. XMLImportMap**

```xml
<XMLImportMap Self="dicd" MarkupTag="XMLTag\cheading_1" MappedStyle="ParagraphStyle\cheading 1"/>
```