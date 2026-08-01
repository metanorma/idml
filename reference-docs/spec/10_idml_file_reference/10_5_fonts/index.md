## 10.5 Fonts

The fonts and composite fonts used in a document are defined in the Fonts.xml file inside the Resources folder in an IDML package. Even an empty In  Design document contains references to default fonts and composite fonts.

Note: In  Design documents do not support font embedding, and fonts are not embedded in IDML. A font used within a document is represented by a simple reference to one of the fonts defined in the < Fonts > element. If fonts referred to in the IDML package are not installed on the system when you try to import an IDML package in In  Design, missing font warnings will appear.

There are two main elements stored in Fonts.xml : <FontFamily> and <CompositeFont>.

## 10.5.1 Font and Font Family

A font family is a group of similar fonts. For example, the fonts 'Arial Regular', 'Arial Bold', and 'Arial Italic' all belong to the same font family. A <FontFamily> element groups together <Font> elements, and each <Font> element defines a specific font. <FontFamily> and <Font> elements both contain an ID attribute. This attribute can be used as a reference throughout the IDML package.

**Schema Example 91. Font Family**

```
FontFamily_Object = element FontFamily { attribute Self { xsd:string }, attribute Name { xsd:string }?, ( Font_Object* ) }
```

**Schema Example 92. Font**

```
Font_Object = element Font { attribute Self { xsd:string }, attribute FontFamily { xsd:string }?, attribute Name { xsd:string }?, attribute PostScriptName { xsd:string }?, attribute Status { FontStatus_EnumValue }?, attribute FontStyleName { xsd:string }?, attribute FontType { FontTypes_EnumValue }?, attribute WritingScript { xsd:int }?, attribute FullName { xsd:string }?, attribute FullNameNative { xsd:string }?, attribute FontStyleNameNative { xsd:string }?, attribute PlatformName { xsd:string }?, attribute Version { xsd:string }? }
```

The following example shows a <Font> definition for the 'Myriad Pro Bold' font. Note: other fonts belonging to the 'Myriad Pro' font family have been omitted from this example.

**IDML Example 61.Font**

```xml
<FontFamily Self="di77" Name="Myriad Pro"> <Font Self="di77Fontn  Myriad Pro Bold" FontFamily="Myriad Pro" Name="Myriad Pro Bold" PostScriptName="$ID/MyriadProBold" Status="Installed" FontStyleName="Bold" FontType="Open  Type CFF" WritingScript="0" FullName="Myriad Pro Bold" FullNameNative="Myriad Pro Bold" FontStyleNameNative="Bold" PlatformName="$ID/" Version="Version 2.007;PS 002.000;Core 1.0.38;makeotf.lib1.7.9032"/>
</FontFamily>
```

Table 120. Font Properties Represented as Attributes

| Name                    | Type                     | Req     | Description |
| ----------------------- | ------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------- |
| FontFamily              | string                   | yes     | Areference to the font family that contains this font, using the unique ID ( Self attribute) of the <FontFamily> element. |
| FontStyleName           | string                   | yes     | The name of the FontStyle. |
| FontStyleNameNative   | string                   | yes     | The native name of the FontStyle. |
| FontType                | FontTypes_EnumValue    | yes     | The type of font. Can be Type1 , TrueType, CID, ATC, Bitmap, OCF, OpenTypeCFF, OpenTypeCID, OpenTypeTT, or Unknown. |
| FullName                | string                   | yes     | The full font name. |
| FullNameNative          | string                   | yes     | The full native name of the font. |
| Name                    | string                   | yes     | The name of the Font. |
| PlatformName            | string                   | yes     | The platform font name. |
| PostScriptName          | string                   | yes     | The PostScript name of the font. |
| Status                  | FontStatus_EnumValue   | yes     | The status of the font. Can be Installed , NotAvailable , Fauxed , Substituted , or Unknown . |
| Version                 | string                   | yes     | The font version. |
| WritingScript           | int                      | yes     | The writing script: '0' for Roman, '1' for Japa- nese, '2' for Traditional Chinese. |

**Referring to a Font**

Elements in an IDML package can refer to fonts using either the Self attribute or Name attribute of the <Font> element. There are many elements in the package that refer to fonts, including: <CharacterStyle> , <CharacterStyleRange> , <ParagraphStyle> , and <ParagraphStyleRange> .

Many elements use a combination of an <AppliedFont> property to specify the font family, and a <FontStyle> attribute to specify the FontStyle.

The example below shows a <CharacterStyleRange> with a reference to the font 'Arial Italic'. The references here are by name:

**IDML Example 62. Referring to a Font**

```xml
<CharacterStyleRange AppliedCharacterStyle="CharacterStyle\k[No CharacterStyle]" FontStyle="Italic"> <Properties> <AppliedFont type="string">Arial</AppliedFont> </Properties> <Content>This is some text formatted using Arial Italic.</Content> </CharacterStyleRange>
```

## 10.5.2 Composite Font

Composite fonts are part of the feature set of the Japanese version of In  Design, but can exist in any In  Design document. Even if you are not using composite fonts, you still need to be aware of them, and you should expect to encounter them in IDML documents.

A composite font is made up of multiple, separate fonts. For example, the default composite font, '[No composite font]', consists of the following <Composite FontEntry> elements: Kanji, Kana, Punctuation, Symbols, Alphabetic, and Numbers. Each of the <CompositeFontEntry> elements contains an <AppliedFont> property that defines the font it uses.

Schemas for <CompositeFont> and <CompositeFont Entry> are shown below. Note that in addition to Name and Self attributes, a <CompositeFont> contains multiple <CompositeFontEntry> elements, and each <CompositeFontEntry> refers to a <Font> in its AppliedFont property.

Note: Composite fonts in In  Design and IDML are not the same thing as composite fonts in PDF and Post  Script. Composite fonts in PDF and Post  Script are embedded font objects that are made up of glyphs from more than one font. In  Design's composite fonts are based on Japanese fonts, are not embedded, and are made up of glyphs from multiple fonts. In  Design composite fonts are not files on disk or stored within the document; they're temporary sets of characters created in the InDesign user interface.

**Schema Example 93. Composite  Font**

```
CompositeFont_Object = element CompositeFont { attribute Self { xsd:string }, attribute Name { xsd:string }, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? , ( CompositeFontEntry_Object* ) }
```

**Schema Example 94. Composite  Font  Entry**

```
CompositeFontEntry_Object = element CompositeFontEntry { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute FontStyle { xsd:string }?, attribute RelativeSize { xsd:double }?, attribute HorizontalScale { xsd:double }?, attribute VerticalScale { xsd:double }?, attribute CustomCharacters { xsd:string }?, attribute Locked { xsd:boolean }?,
attribute ScaleOption { xsd:boolean }?, attribute BaselineShift { xsd:double }?, element Properties { element AppliedFont { (object_type, xsd:string ) | (string_type, xsd:string ) }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```
