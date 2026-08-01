## 10.9 XML Elements

This section discusses the way that XML elements in the XML structure of an InDesign document are represented in an IDML document.

## 10.9.1 BackingStory.xml

The `BackingStory.xml` file in an IDML package contains any XML content in the XML structure of the InDesign document that has not been placed in the layout.

**Schema Example 169. BackingStory**

```rnc
BackingStory_File = element idPkg:BackingStory { attribute DOMVersion { "7.0" }, ( XmlStory_Object* ) }
```

The following example shows the <idpkg:BackingStory> element for an IDML package in which all XML content has been placed in the layout (see the MappingStyleToTags example in the 'Stories' section). The XML structure contains one child of the root <XMLElement> element, which has been associated with the <Story> element in the IDML package with the Self attribute ud8 .

**IDML Example 97. BackingStory**

```xml
<id Pkg:BackingStory xmlns:id Pkg="http://ns.adobe.com/Adobe  In Design/idml/1.0/ packaging"> <Xml  StorSelf="u9c"> <ParagraphStyleRange AppliedParagraphStyle= "Paragraph  Style\k Normal  Paragraph  Style"> <CharacterStyleRange AppliedCharacterStyle= "CharacterStyle\k[No CharacterStyle]"> <Content></Content> <XMLElement Self="di2" MarkupTag="XMLTag\c  Root"> <XMLElement Self="di2i3" MarkupTag="XMLTag\c  Story" XMLContent="ud8"/> </XMLElement> </CharacterStyleRange> </ParagraphStyleRange> </XmlStory> </id Pkg:BackingStory>
```

## 10.9.2 XMLStory

An <XMLStory> element represents XML text content that has not yet been placed in a layout. The <XMLStory> element is identical to the <Story> element; refer to 'Stories.' An <XMLStory> element can contain <ParagraphStyleRange> elements, <CharacterStyleRange> elements, <Table> elements, anchored frames, and all of the other elements that can appear in a <Story> element.

## 10.9.3 XMLElement

The <XMLElement> elements in an IDML file represent XML content in the structure of an In  Design document. For an example of an <XMLElement> element in text, see 'Stories.' For an example of an <XMLElement> element associated with a page item, see 'Spreads and Master Spreads.'

**Schema Example 170. XMLElement**

```rnc
XMLElement_Object = element XMLElement { attribute Self { xsd:string }, attribute MarkupTag { xsd:string }?, attribute XMLContent { xsd:string }?, attribute NoTextMarker { xsd:boolean }?, ( XMLAttribute_Object*& XMLElement_Object*& XMLComment_Object*& XMLInstruction_Object*& Table_Object*& Footnote_Object*& Note_Object*& GaijiOwnedItemObject_Object*& TextVariableInstance_Object*& HyperlinkTextDestination_Object*& Change_Object*& HiddenText_Object*& DTD_Object*& Oval_Object*& Rectangle_Object*& GraphicLine_Object*& Polygon_Object*& Group_Object*& TextFrame_Object*& Button_Object*& FormField_Object*& MultiStateObject_Object*& EPSText_Object*& HyperlinkTextSource_Object*& ParagraphStyleRange_Object*& CharacterStyleRange_Object*& Link_Object*& element Content {text}*& element Br {empty}* ) }
```
**Table 185**: XMLElement Properties Represented as Attributes

| Name        | Type     | Req     | Description |
| ----------- | -------- | ------- | --------------------------------------------------------------------------------------------------------- |
| MarkupTag   | string   | no      | Areference to the <XMLTag> of the XMLele- ment (as a reference to the Self attribute of the <XMLTag> ). |

| Name           | Type                         | Req     | Description |
| -------------- | ---------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| XMLContent     | string                       | no      | Areference to the <Story> of the XMLelement (as a reference to the Self attribute of the <Story> ). Only used by the top-levelXML element in a Story. |
| NoTextMarker   | XMLNoTextMarker_ EnumValue   | no      | Used for <Table> and <Cell> elements (these elements do not have associated marker charac- ters in the layout. |

**Schema Example 171. XMLAttribute**

```rnc
XMLAttribute_Object = element XMLAttribute { attribute Self { xsd:string }, attribute Name { xsd:string }, attribute Value { xsd:string } }
```
**Table 186**: XMLAttribute Properties Represented as Attributes

| Name     | Type     | Req     | Description |
| -------- | -------- | ------- | ----------------------------- |
| Name     | string   | yes     | The name of the attribute. |
| Value    | string   | yes     | The value of the attribute. |

**Schema Example 172. XMLInstruction**

```rnc
XMLInstruction_Object = element XMLInstruction { attribute Self { xsd:string }, attribute Target { xsd:string }, attribute Data { xsd:string }? }
```
**Table 187**: XMLInstruction Properties Represented as Attributes

| Name          | Type     | Req     | Description |
| ------------- | -------- | ------- | ----------------------------------------------------------------------------------------------------------------- |
| StoryOffset   | string   | no      | The location of the <XMLInstruction> , as a reference to the Self attribute of a <CharacterStyleRange> element. |
| Target        | string   | yes     | The target of the <XMLInstruction> . |
| Data          | string   | no      | The contents of the <XMLInstruction> . |

**Schema Example 173. XMLComment**

```rnc
XMLComment_Object = element XMLComment { attribute Self { xsd:string }, attribute Value { xsd:string }? }
```

**Table 188**: XMLComment Properties Represented as Attributes

| Name          | Type     | Req     | Description |
| ------------- | -------- | ------- | ----------------------------------------------------------------------------------------------------------------- |
| StoryOffset   | string   | no      | The location of the <XMLInstruction> , as a reference to the Self attribute of a <CharacterStyleRange> element. |
| Value         | string   | no      | The contents of the <XMLComment> . |

**Schema Example 174. DTD**

```
DTD_Object = element DTD { attribute Self { xsd:string }, element Properties { element Contents { (string_type, xsd:string ) | (enum_type, SpecialCharacters_EnumValue ) | (object_type, xsd:string ) }? } ? }
```

**Table 189**: DTD Properties Represented as Attributes

| Name          | Type     | Req     | Description |
| ------------- | -------- | ------- | ----------------------------------------------------------------------------------------------------------------- |
| StoryOffset   | string   | no      | The location of the <XMLInstruction> , as a reference to the Self attribute of a <CharacterStyleRange> element. |

**Table 190**: DTD Properties Represented as Elements

| Name       | Type                                      | Req     | Description |
| ---------- | ----------------------------------------- | ------- | -------------------------- |
| Contents   | string or SpecialCharacters enumeration   | no      | The contents of the DTD. |
