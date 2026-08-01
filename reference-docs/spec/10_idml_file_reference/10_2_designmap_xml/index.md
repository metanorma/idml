## 10.2 designmap.xml

The designmap.xml file contains a 'road map' to the XML elements that make up the document, and defines a variety of document-level attributes. Some elements, such as hyperlinks and cross references, are collected in the <Document> element; this makes it easier to refer to them from other parts of the IDML file or package.

This section describes the contents of the designmap.xml file in an IDML package file. If you're creating a 'single file' IDML document, you'll use the same elements, and use the same method of referring to elements in the file (generally by the contents of their Self attributes) but won't need to include the cross-file references.

**Schema Example 4. Document**

```rnc
Document_Object = element Document {
    attribute DOMVersion { "7.0" },
    attribute Self { xsd:string },
    attribute ActiveProcess { xsd:string }?,
    attribute TransparencyAttributeDefaultProperty { xsd:string }?,
    attribute StoryList { list { xsd:string * } }?,
    attribute FullName { xsd:string }?,
    attribute Name { xsd:string }?,
    attribute Visible { xsd:boolean }?,
    attribute FilePath { xsd:string }?,
    attribute Modified { xsd:boolean }?,
    attribute Saved { xsd:boolean }?,
    attribute ZeroPoint { UnitPointType_TypeDef }?,
    attribute UnusedSwatches { list { xsd:string * } }?,
    attribute ActiveLayer { xsd:string }?,
    attribute Converted { xsd:boolean }?,
    attribute Recovered { xsd:boolean }?,
    attribute ReadOnly { xsd:boolean }?,
    attribute Id { xsd:int }?,
    attribute CMYKProfileList { list { xsd:string * } }?,
    attribute RGBProfileList { list { xsd:string * } }?,
    attribute CMYKProfile { xsd:string }?,
    attribute RGBProfile { xsd:string }?,
    attribute SolidColorIntent { RenderingIntent_EnumValue }?,
    attribute AfterBlendingIntent { RenderingIntent_EnumValue }?,
    attribute DefaultImageIntent { RenderingIntent_EnumValue }?,
    attribute RGBPolicy { ColorSettingsPolicy_EnumValue }?,
    attribute CMYKPolicy { ColorSettingsPolicy_EnumValue }?,
    attribute AccurateLABSpots { xsd:boolean }?,
    element Properties {
        element InstanceList {
            element IndexInstanceType { IndexInstanceType_TypeDef }*
        }?
        & element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?,
    (
        Language_Object*,
        element idPkg:Graphic { attribute src {"Resources/Graphic.xml"} }?,
        element idPkg:Fonts { attribute src {"Resources/Fonts.xml"} }?,
        KinsokuTable_Object*,
        MojikumiTable_Object*,
        element idPkg:Styles { attribute src {"Resources/Styles.xml"} }?,
        NumberingList_Object*,
        NamedGrid_Object*,
        MotionPreset_Object*,
        Condition_Object*,
        ConditionSet_Object*,
        (
            element idPkg:Preferences { attribute src {"Resources/Preferences.xml"} }?
            & LinkedStoryOption_Object?
            & LinkedPageItemOption_Object?
            & TaggedPDFPreference_Object?
            & MetadataPacketPreference_Object?
            & WatermarkPreference_Object?
            & ConditionalTextPreference_Object?
        ),
        TextVariable_Object*,
        element idPkg:Tags { attribute src {"XML/Tags.xml"} }?,
        Layer_Object*,
        element idPkg:MasterSpread { attribute src {xsd:string {pattern = ".*\.xml"} } }*,
        element idPkg:Spread { attribute src {xsd:string {pattern = ".*\.xml"} } }*,
        Section_Object*,
        DocumentUser_Object*,
        CrossReferenceFormat_Object*,
        Index_Object*,
        element idPkg:BackingStory { attribute src {"XML/BackingStory.xml"} }?,
        element idPkg:Story { attribute src {xsd:string {pattern = ".*\.xml"} } }*,
        HyperlinkPageDestination_Object*,
        HyperlinkURLDestination_Object*,
        HyperlinkExternalPageDestination_Object*,
        HyperlinkPageItemSource_Object*,
        Hyperlink_Object*,
        element idPkg:Mapping { attribute src {"XML/Mapping.xml"} }?,
        Bookmark_Object*,
        (
            PreflightProfile_Object*
            & DataMergeImagePlaceholder_Object*
            & HyphenationException_Object*
            & ParaStyleMapping_Object*
            & CharStyleMapping_Object*
            & TableStyleMapping_Object*
            & CellStyleMapping_Object*
            & IndexingSortOption_Object*
            & ABullet_Object*
            & Assignment_Object*
            & Article_Object*
        )
    )
}
```

****Table 3***:: Document Properties Represented as Attributes

| Name                                     | Type                              | Req     | Description |
| -----------------------                  | --------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AccurateLABSpots                         | boolean                           | no      | If true, uses LAB alternates for spot colors when available. |
| ActiveLayer                              | string                            | no      | The active layer. |
| ActiveProcess                            | string                            | no      | The active preflight process for this document. |
| AfterBlendingIntent                    | RenderingIntent_EnumValue        | no      | The rendering intent for colors that result from transparency interactions on the page after blending. Can be UseColorSettings (Uses the current color settings), Perceptual (Preserves the visual relationship between colors at the expense of actual color values; most suitable for photographic images with high percentages of out-of-gamut colors), Saturation (Produces vivid colors at the expense of color accuracy; most suitable for business graphics such as graphs or charts), RelativeColorimetric (Compares the extreme highlight of the source color space to that of the desination color space and shifts all colors accordingly; out-of-gamut colors are shifted to the closest reproducible col- or in the destination color space), or AbsoluteColorimetric (Maintains color accuracy at the expense of preserving relationships between colors; most suitable for previewing how paper color affects printed colors). |
| CMYKPolicy                               | ColorSettingsPolicy_EnumValue   | no      | The policy for handling colors in a CMYKcolor model, including reading and embedding color profiles, mismatches between embedded color profiles and the working space, and moving colors from one document to another. Can be ColorPolicyOff (Turns off color management for documents whose profiles do not match the working space For imported colors, numeric values override color appearance), Preserve EmbeddedProfiles (Preserves embedded color profiles in newly opened documents), Convert ToWorkingSpace (Converts newly opened documents to the current working space For imported colors, color appearance overrides numeric values), or CombinationOfPreserve AndSafeCmyk (Preserves raw color numbers and ignores embedded color profiles). |
| CMYKProfile                              | string                            | no      | The current CMYKprofile. |
| CMYKProfileList                          | string                            | no      | Alist of valid CMYKprofiles. |
| Converted                                | boolean                           | no      | If true, the Document was converted. |
| DefaultImageIntent                     | RenderingIntent_EnumValue        | no      | The rendering intent for bitmap images. Can be UseColorSettings (Uses the current color settings), Perceptual (Preserves the visual relationship between colors at the expense of actual color values; most suitable for photo- graphic images with high percentages of out- of-gamut colors), Saturation (Produces vivid colors at the expense of color accuracy; most suitable for business graphics such as graphs or charts), RelativeColorimetric (Compares the extreme highlight of the source color space to that of the desination color space and shifts all colors accordingly; out-of-gamut colors are shifted to the closest reproducible color in the destination color space), or AbsoluteColorimetric (Maintains color accuracy at the expense of preserving relationships between colors; most suitable for previewing how paper color affects printed colors). |
| FilePath                                 | string                            | no      | The full path to the file. |
| FullName                                 | string                            | no      | The full path to the Document, including the name of the Document. |
| Id                                       | int                               | no      | The ID of the document. |
| Modified                                 | boolean                           | no      | If true, the Document has been modified since it was last saved. |
| Name                                     | string                            | no      | The name of the Document. |
| RGBPolicy                                | ColorSettingsPolicy_EnumValue   | no      | The policy for handling colors in an RGB color model, including reading and embedding color profiles, handling mismatches between embed- ded color profiles and the working space, and moving colors from one document to another. Can be ColorPolicyOff (Turns off color management for documents whose profiles do not match the working space For imported colors, numeric values override color appear- ance), PreserveEmbeddedProfiles (Preserves embedded color profiles in newly opened docu- ments), ConvertToWorkingSpace (Converts newly opened documents to the current working space For imported colors, color appearance overrides numeric values), or CombinationOf PreserveAndSafeCmyk (Preserves raw color numbers and ignores embedded color profiles). |
| RGBProfile                               | string                            | no      | The current RGB profile. |
| RGBProfileList                           |                                   | no      | Alist of valid RGB profiles. |
| ReadOnly                                 | boolean                           | no      | If true, the Document is read-only. |
| Recovered                                | boolean                           | no      | If true, the Document was recovered. |
| Saved                                    | boolean                           | no      | If true, the Document has not been saved since it was created. |
| SolidColorIntent                         | RenderingIntent_EnumValue        | no      | The rendering intent for all vector art (areas of solid color) in native objects. Can be UseColor Settings (Uses the current color settings), Perceptual (Preserves the visual relation- ship between colors at the expense of actual color values; most suitable for photographic images with high percentages of out-of-gamut colors), Saturation (Produces vivid colors at the expense of color accuracy; most suit- able for business graphics such as graphs or charts), RelativeColorimetric (Compares the extreme highlight of the source color space to that of the desination color space and shifts all colors accordingly; out-of-gamut colors are shifted to the closest reproducible color in the destination color space), or AbsoluteColorimetric (Maintains color accuracy at the expense of preserving relationships between colors; most suitable for previewing how paper color affects printed colors). |
| StoryList                                | string                            | no      | The list of stories in the document, as a sequence of references to the Self attribute of each story, separated by spaces. |
| TransparencyAttributeDefaultProperty | string                            | no      | Transparency defaults for the document. |
| UnusedSwatches                           | string                            | no      | Alist of the swatches that are not being used, as a sequence of references to the Self attribute of each swatch, separated by spaces. |
| Visible                                  | boolean                           | no      | If true, the Document is visible. |
| ZeroPoint                                | UnitPointType_TypeDef            | no      | The ruler origin, specified as page coordinates in the format [x, y]. |

**Table 4.**: Document Properties Represented as Elements

| InstanceList            | IndexInstance Type_TypeDef       | no      | Alist of the index instances that have been placed in the document. |
| ----------------------- | --------------------------------- | ------- | ----------------------------------------------------------------------- |

**IDML Example 7. Document Element Using References to Other Files in the IDML Package**
```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<?aid style="50" type="document" readerVersion="6.0" featureSet="257" product="7.0(329)" ?>
<Document xmlns:idPkg="http://ns.adobe.com/AdobeInDesign/idml/1.0/packaging" 
         DOMVersion="7.0" 
         Self="d" 
         StoryList="ud6 u82" 
         ZeroPoint="0 0" 
         ActiveLayer="ua3" 
         CMYKProfile="U.S. Web Coated (SWOP) v2" 
         RGBProfile="sRGB IEC61966-2.1" 
         SolidColorIntent="UseColorSettings" 
         AfterBlendingIntent="UseColorSettings" 
         DefaultImageIntent="UseColorSettings" 
         RGBPolicy="PreserveEmbeddedProfiles" 
         CMYKPolicy="CombinationOfPreserveAndSafeCmyk" 
         AccurateLABSpots="false">
    <idPkg:Graphic src="Resources/Graphic.xml"/>
    <idPkg:Fonts src="Resources/Fonts.xml"/>
    <idPkg:Styles src="Resources/Styles.xml"/>
    <idPkg:Preferences src="Resources/Preferences.xml"/>
    <idPkg:Tags src="XML/Tags.xml"/>
    <idPkg:MasterSpread src="MasterSpreads/MasterSpread_ua4.xml"/>
    <idPkg:Spread src="Spreads/Spread_uce.xml"/>
    <idPkg:BackingStory src="XML/BackingStory.xml"/>
    <idPkg:Story src="Stories/Story_ud6.xml"/>
</Document>
```

In the above example, the document contains a single story file, `Story\_ud6.xml`, and a single spread file, `Spread\_uce.xml`. All of the other `idPkg:` elements refer to standard files and file locations inside the IDML package file. In the following example, the <Story> and <Spread> elements are contained within the `designmap.xml` file itself.

**IDML Example 8. Document Element in a designmap.xml File**

```xml
<?xml version="1.0" encoding="UTF8" standalone="yes"?> <?aid style="50" type="document" readerVersion="6.0" featureSet="257" product="7.0(330)" ?> <Document DOMVersion="7.0" Self="d" StoryList="ud6" ZeroPoint="0 0" ActiveLayer="ua3" CMYKProfile="U.S. Web Coated (SWOP) v2" RGBProfile="sRGB IEC619662.1" SolidColorIntent="UseColorSettings" AfterBlendingIntent="UseColorSettings" DefaultImageIntent="UseColorSettings" RGBPolicy="PreserveEmbeddedProfiles" CMYKPolicy="CombinationOfPreserveAndSafeCmyk" AccurateLABSpots="false"> <Layer Self="ua3" Name="Layer 1" Visible="true" Locked="false" IgnoreWrap="false" ShowGuides="true" LockGuides="false" UI="true" Expendable="true" Printable="true"> <Properties> <LayerColor type="enumeration">LightBlue</LayerColor> </Properties> </Layer> <MasterSpread Self="ua4" ItemTransform="1 0 0 1 0 0" OverriddenPageItemProps="" Name="AMaster" NamePrefix="A" BaseName="Master" ShowMasterItems="true" PageCount="2"> <Page Self="ua9" GeometricBounds="0 0 792 612" ItemTransform="1 0 0 1 612 396" Name="A" AppliedMaster="n" MasterPageTransform="1 0 0 1 0 0" TabOrder="" GridStartingPoint="TopOutside" UseMasterGrid="true"> <Properties> <PageColor type="enumeration">UseMasterColor</PageColor> </Properties> <MarginPreference ColumnCount="1" ColumnGutter="12" Top="36" Bottom="36" Left="36" Right="36" ColumnDirection="Horizontal" ColumnsPositions="0 540"/> </Page> <Page Self="uaa" GeometricBounds="0 0 792 612" ItemTransform="1 0 0 1 0 396" Name="A" AppliedMaster="n" MasterPageTransform="1 0 0 1 0 0" TabOrder="" GridStartingPoint="TopOutside" UseMasterGrid="true"> <MarginPreference ColumnCount="1" ColumnGutter="12" Top="36" Bottom="36" Left="36" Right="36" ColumnDirection="Horizontal" ColumnsPositions="0 540"/> </Page> </MasterSpread> <Spread Self="uce" FlattenerOverride="Default" AllowPageShuffle="true" ItemTransform="1 0 0 1 0 0" ShowMasterItems="true" PageCount="1" BindingLocation="0"> <Page Self="ud3" GeometricBounds="0 0 792 612" ItemTransform="1 0 0 1 0 396" Name="1" AppliedMaster="ua4" MasterPageTransform="1 0 0 1 0 0" TabOrder="" GridStartingPoint="TopOutside" UseMasterGrid="true"> <Properties> <PageColor type="enumeration">UseMasterColor</PageColor> </Properties> <MarginPreference ColumnCount="1" ColumnGutter="12" Top="36" Bottom="36" Left="36" Right="36" ColumnDirection="Horizontal" ColumnsPositions="0 540"/> </Page> <TextFrame Self="ue8" ParentStory="ud6" PreviousTextFrame="n" NextTextFrame="n" ContentType="TextType" ItemLayer="ua3" ItemTransform="1 0 0 1 0 396"> <Properties> <PathGeometry> <GeometryPath PathOpen="false"> <PathPointArray> <PathPointType Anchor="72 72" LeftDirection="72 72" RightDirection="72 72"/> <PathPointType Anchor="144 72" LeftDirection="144 72" RightDirection="144 72"/> <PathPointType Anchor="144 144" LeftDirection="144 144" RightDirection="144 144"/> <PathPointType Anchor="72 144" LeftDirection="72 144" RightDirection="72 144"/> </PathPointArray> </GeometryPath> </PathGeometry> </Properties> <TextFramePreference TextColumnFixedWidth="72"/> </TextFrame> </Spread> <Story Self="ud6" AppliedTOCStyle="n" TrackChanges="false" StoryTitle="$ID/" AppliedNamedGrid="n"> <StoryPreference OpticalMarginAlignment="false" OpticalMarginSize="12" FrameType="TextFrameType" StoryOrientation="Horizontal" StoryDirection="LeftToRightDirection"/> <ParagraphStyleRange> <CharacterStyleRange> <Content>This is a TextFrame.</Content> </CharacterStyleRange> </ParagraphStyleRange> </Story> </Document>
```

### 10.2.1 Documents and Color Management

The appearance of all swatches (colors, tints, gradients, mixed inks, and mixed ink groups, described in section <hyperlink>'Graphics.xml'</hyperlink>) and imported graphics is determined by the color management profiles applied to the document. The profile does not change the base properties of these objects (e.g., it does not change the CMYK color values of a color defined in the Graphic.xml file inside the IDML package); it only affects the rendering of the color for display or output (printing and export).

**IDML Example 9. Color Management Attributes**

```xml
<Document Self="d" 
         CMYKProfile="U.S. Web Coated (SWOP) v2" 
         RGBProfile="sRGB IEC61966-2.1" 
         SolidColorIntent="UseColorSettings" 
         AfterBlendingIntent="UseColorSettings" 
         DefaultImageIntent="UseColorSettings" 
         RGBPolicy="PreserveEmbeddedProfiles" 
         CMYKPolicy="CombinationOfPreserveAndSafeCmyk" 
         AccurateLABSpots="false">
```

A complete discussion of InDesign's color management features is beyond the scope of this document. For more information, refer to the InDesign documentation.

Note: The colors used for drawing user interface items (guides, grids, layer highlights, etc.) are simply RGB screen values on a given system, and are not color managed.

### 10.2.2 Language

The <Language> elements in an IDML package define the language dictionaries available for the document. You cannot create languages by adding new <Language> elements; they are included for use as references (from, for example, ParagraphStyle elements in the Styles.xml file in the Resources folder of the IDML package), and to maintain round-trip fidelity for InDesign and InCopy documents.

**Schema Example 5. Language**

```rnc
Language_Object = element Language {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    attribute SingleQuotes { xsd:string }?,
    attribute DoubleQuotes { xsd:string }?,
    attribute PrimaryLanguageName { xsd:string }?,
    attribute SublanguageName { xsd:string }?,
    attribute Id { xsd:int }?,
    attribute HyphenationVendor { xsd:string }?,
    attribute SpellingVendor { xsd:string }?,
    element Properties {
        element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

****Table 5***:: Language Properties Represented as Attributes

| Name           | Type     | Req     | Description                                |  |
| -------------- | -------- | ------- | ------------------------------------------ | ------------------------------------------ |
| DoubleQuotes   | string   | no      | The double quotes pair for the language.  |  |

| Name                    | Type     | Req     | Description |
| ----------------------- | -------- | ------- | ------------------------------------------ |
| HyphenationVendor       | string   | no      | The hyphenation rules source. |
| Id                      | int      | no      | The unique ID of the Language. |
| Name                    | string   | yes     | The name of the Language. |
| PrimaryLanguage Name   | string   | no      | The name of the language. |
| SingleQuotes            | string   | no      | The single quotes pair for the language. |
| SpellingVendor          | string   | no      | The spell-checking source. |
| SublanguageName         | string   | no      | The sub-language name of the language. |

### 10.2.3 KinsokuTable

**Schema Example 6. KinsokuTable**

```rnc
KinsokuTable_Object = element KinsokuTable {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    attribute CantBeginLineChars { xsd:string }?,
    attribute CantEndLineChars { xsd:string }?,
    attribute HangingPunctuationChars { xsd:string }?,
    attribute CantBeSeparatedChars { xsd:string }?,
    element Properties {
        element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

**Table 6**: KinsokuTable Properties Represented as Attributes

| Name                        | Type     | Req     | Description |
| --------------------------- | -------- | ------- | -------------------------------------------------------------- |
| CantBeginLine Chars        | String   | no      | The characters in the kinsoku set that cannot begin a line. |
| CantEndLineChars            | String   | no      | The characters in the kinsoku set that cannot be end a line. |
| HangingPunctua tionChars   | String   | no      | The hanging punctuation characters in the kin- soku set. |
| CantBeSeparated Chars      | String   | no      | The characters in the kinsoku set that cannot be separated. |

### 10.2.4 MojikumiTable

```rnc
MojikumiTable_Object = element MojikumiTable {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    attribute BasedOnMojikumiSet { MojikumiTableDefaults_EnumValue }?,
    element Properties {
        element OverrideMojikumiAkiList {
            element OverrideMojikumiAkiType { OverrideMojikumiAkiType_TypeDef }*
        }?
        & element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

**Table 7**: MojikumiTable Properties Represented as Attributes

| Name                    | Type                               | Req     | Description |
| ----------------------- | ---------------------------------  | ------- | ------------------------------------------------------------------ |
| BasedOnMojikumi Set    | MojikumiTable Defaults_EnumValue | no      | The existing mojikumi set on which to base the new mojikumi set. |

**Table 8**: MojikumiTable Properties Represented as Elements

| Name                | Type                | Req     | Description |
| ------------------- | ------------------- | ------- | --------------------------------- |
| OverrideMojikumi   | OverrideMojikumi   | no      | The mojikumi overrides for aki. |
| AkiList             | AkiType_TypeDef     |         |  |

### 10.2.5 NumberingList

**Schema Example 7. NumberingList**

```rnc
NumberingList_Object = element NumberingList {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    attribute ContinueNumbersAcrossStories { xsd:boolean }?,
    attribute ContinueNumbersAcrossDocuments { xsd:boolean }?,
    element Properties {
        element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

**Table 9**: NumberingList Properties Represented as Attributes

| Name                             | Type                              | Req     | Description |
| -----------------------          | --------------------------------- | ------- | ---------------------------------------------------------- |
| ContinueNumbersAcrossStories   | boolean                           | no      | If true, numbering continues across stories. |
| ContinueNumbersAcrossDocuments | boolean                           | no      | If true, numbering continues across documents in a book. |

### 10.2.6 NamedGrid

**Schema Example 8. NamedGrid**

```rnc
NamedGrid_Object = element NamedGrid {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    element Properties {
        element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?,
    ( GridDataInformation_Object? )
}
```

**Table 10**: NamedGrid Properties Represented as Attributes

| Name     | Type     | Req     | Description |
| -------- | -------- | ------- | ----------------------------- |
| Name     | string   | yes     | The name of the named grid. |

### 10.2.7 Grid Data Information

Default grid properties. Applies to named, layout, and frame (story) grids.

**Schema Example 9. GridDataInformation**

```rnc
GridDataInformation_Object = element GridDataInformation {
    attribute FontStyle { xsd:string }?,
    attribute PointSize { xsd:double }?,
    attribute CharacterAki { xsd:double }?,
    attribute LineAki { xsd:double }?,
    attribute HorizontalScale { xsd:double }?,
    attribute VerticalScale { xsd:double }?,
    attribute LineAlignment { LineAlignment_EnumValue }?,
    attribute GridAlignment { GridAlignment_EnumValue }?,
    attribute CharacterAlignment { CharacterAlignment_EnumValue }?,
    attribute GridView { GridViewSettings_EnumValue }?,
    attribute CharacterCountLocation { CharacterCountLocation_EnumValue }?,
    attribute CharacterCountSize { xsd:double }?,
    element Properties {
        element AppliedFont { 
            (object_type, xsd:string ) | (string_type, xsd:string )
        }?
    }?
}
```

**Table 11**: GridDataInformation Properties Represented as Attributes

| Name                     | Type                                 | Req     | Description |
| -----------------------  | ---------------------------------    | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CharacterAki             | double                               | no      | The amount of white space between characters. |
| CharacterAlignment     | CharacterAlignment_EnumValue       | no      | The alignment of small characters to the largest character in the line. Can be AlignBaseline, AlignEmTop, AlignEmCenter, AlignEm Bottom, AlignICFTop, or AlignICFBottom. |
| CharacterCountLocation | CharacterCountLocation_Enum Value | no      | The character count location. Can be None, TopAlign, LeftAlign, BottomAlign, or RightAlign. |
| CharacterCountSize     | double                               | no      | The character size for the character count display. |
| FontStyle                | string                               | no      | The name of the FontStyle. |
| GridAlignment            | GridAlignment_EnumValue              | no      | The alignment to the frame grid or baseline grid. Can be None, AlignBaseline, AlignEmTop, AlignEmCenter, AlignEmBottom, AlignICFTop, or AlignICFBottom. |
| GridView                 | GridViewSettings_EnumValue           | no      | The grid view setting. Can be GridViewEnum, ZnViewEnum, AlignViewEnum, or GridAndZnViewEnum. |
| HorizontalScale          | double                               | no      | The horizontal scaling applied to characters within the grid. |
| LineAlignment            | LineAlignment_EnumValue             | no      | The alignment of the lines of the grid. Can be LeftOrTopLineAlign, CenterLineAlign, RightOrBottomLineAlign, LeftOrTopLineJustify, CenterLineJustify, RightOrBottomLineJustify, or FullLineJustify. |
| LineAki                  | double                               | no      | The amount of white space between lines. |
| PointSize                | double                               | no      | The PointSize of characters in the grid. |
| VerticalScale            | double                               | no      | The vertical scaling applied to the grid. |

**Table 12**: GridDataInformation Properties Represented as Elements

| Name     | Type     | Req     | Description |
| -------- | -------- | ------- | ----------------------------------------------------------------------------------------------------------------- |
| Font     | string   | no      | The font applied to the grid, as the name of the font or as a reference to the Self attribute of a font object. |

### 10.2.8 Motion Preset

InDesign includes a number of motion presets-default animation settings that can be applied to page items in an InDesign document. For more on motion presets, refer to the InDesign online documentation.

**Schema Example 10. MotionPreset**

```rnc
MotionPreset_Object = element MotionPreset {
    attribute Self { xsd:string },
    attribute Name { xsd:string }?,
    attribute EditLocked { xsd:boolean }?,
    attribute DeleteLocked { xsd:boolean }?,
    attribute NameLocked { xsd:boolean }?,
    element Properties {
        element Contents { xsd:string }?
        & element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

**Table 13**: MotionPreset Properties Represented as Attributes

| Name                    | Type                              | Req     | Description |
| ----------------------- | --------------------------------- | ------- | ---------------------------------------------------------- |
| DeleteLocked            | boolean                           | no      | If true, the motion preset cannot be deleted. |
| EditLocked              | boolean                           | no      | If true, the motion preset cannot be edited. |
| Name                    | string                            | no      | The name of the motion preset. |
| NameLocked              | boolean                           | no      | If true, the name of the motion preset cannot be edited. |

**Table 14**: MotionPreset Properties Represented as Elements

| Name       | Type     | Req     | Description |
| ---------- | -------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Contents   | string   | no      | The motion preset definition. This is theXML representation of the motion preset as defined by Adobe Flash, packaged inside a CDATA section. More details can be found at the URL http:// www.adobe.com/devnet/flash/learning_guide/ animation/. Developers should entity encode and use the contents of the motion presetXML file in the folder presets/motion presets that cor- responds to the specific motion preset that they are adding to the document. |

### 10.2.9 Condition

InDesign documents can feature conditional text-text that is only visible in the layout when a specific state is enabled. The <Condition> element controls the appearance of the text governed by a condition.

**Schema Example 11. Condition**

```rnc
Condition_Object = element Condition {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    attribute IndicatorMethod { ConditionIndicatorMethod_EnumValue }?,
    attribute UnderlineIndicatorAppearance { ConditionUnderlineIndicatorAppearance_EnumValue }?,
    attribute Visible { xsd:boolean }?,
    element Properties {
        element IndicatorColor { InDesignUIColorType_TypeDef }?
        & element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

**Table 15**: Condition Properties Represented as Attributes

| Name                             | Type                                                    | Req     | Description |
| -----------------------          | ---------------------------------                       | ------- | ----------------------------------------------- |
| IndicatorMethod                  | ConditionIndicatorMethod_EnumValue                   | no      | The condition indicator method. |
| Name                             | string                                                  | yes     | The name of the Condition. |
| UnderlineIndicatorAppearance | ConditionUnderlineIndicatorAppearance_Enum Value | no      | The condition underline indicator appearance. |
| Visible                          | boolean                                                 | no      | If true, the Condition is visible. |

**Table 16**: Condition Properties Represented as Elements

| Name             | Type                                                   | Req     | Description |
| ---------------- | ------------------------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| IndicatorColor   | list of 3 doubles or InDesign UIColorType_TypeDef   | no      | The color for the condition indicator, specified either as an array of three doubles, each in the range 0 to 255 and representing R, G, and B val- ues, or as a UI color. |

### 10.2.10 ConditionSet

**Schema Example 12. ConditionSet**

```rnc
ConditionSet_Object = element ConditionSet {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    element Properties {
        element SetConditions {
            element VisibilityPair { VisibilityPair_TypeDef }*
        }?
        & element Label {
            element KeyValuePair { KeyValuePair_TypeDef }*
        }?
    }?
}
```

**Table 17**: Condition Properties Represented as Elements

| Name            | Type                      | Req     | Description |
| --------------- | ------------------------- | ------- | ------------------------------------------------- |
| SetConditions   | VisibilityPair_TypeDef   | no      | List of conditions and visibilities in the set. |

### 10.2.11 LinkedStoryOption

**Schema Example 13.**

```rnc
LinkedStoryOption_Object = element LinkedStoryOption {
    attribute UpdateWhileSaving { xsd:boolean }?,
    attribute WarnOnUpdateOfEditedStory { xsd:boolean }?,
    attribute RemoveForcedLineBreaks { xsd:boolean }?
}
```


**Table 18**: LinkedStoryOption Properties Represented as Attributes

| Name                          | Type      | Req     | Description |
| ----------------------------- | --------- | ------- | ------------------------------------------------------------------------------------------ |
| UpdateWhileSaving             | boolean   | no      | If true, the linked story will be updated while saving. |
| WarnOnUpdateOf EditedStory   | boolean   | no      | If true, a warning will be shown if the update link operation will override local edits. |
| RemoveForcedLine Breaks      | boolean   | no      | If true, forced line breaks will be removed dur- ing story creation or update. |

### 10.2.12 TaggedPDFPreference

**Schema Example 14. TaggedPDFPreference**

```rnc
TaggedPDFPreference_Object = element TaggedPDFPreference { attribute StructureOrder { TaggedPDFStructureOrderOptions_EnumValue }? }
```

**Table 19**: TaggedPDFPReferenceStructureOrder Properties Represented as Elements

| Name             | Type                                           | Req     | Description |
| ---------------- | ---------------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------- |
| StructureOrder   | TaggedPDFStructureOrderOptions_EnumValue   | no      | Can be UseArticles (use the order defined in the Articles panel) or UseXmlStructure (use the order of elements in the XMLstructure). |

**IDML Example 10. TaggedPDFPReferenceStructureOrder**

```xml
<TaggedPDFPreferenceStructureOrder="UseXMLStructure"/>
```

### 10.2.13 MetadataPacketPreference

**Schema Example 15. MetadataPacketPreference**

```rnc
MetadataPacketPreference_Object = element MetadataPacketPreference { element Properties { element Contents { xsd:string }? } ? }
```

**Table 20**: MetadataPacketPreference Properties Represented as Elements

| Name       | Type     | Req     | Description |
| ---------- | -------- | ------- | --------------------------------------- |
| Contents   | String   | no      | The metadata packet for the document. |

### 10.2.14 WatermarkPreference

```rnc
WatermarkPreference_Object = element WatermarkPreference { attribute WatermarkVisibility { xsd:boolean }?, attribute WatermarkDoPrint { xsd:boolean }?, attribute WatermarkDrawInBack { xsd:boolean }?, attribute WatermarkText { xsd:string }?, attribute WatermarkFontFamily { xsd:string }?, attribute WatermarkFontStyle { xsd:string }?, attribute WatermarkFontPointSize { xsd:int }?, attribute WatermarkOpacity { xsd:int }?, attribute WatermarkRotation { xsd:int }?, attribute WatermarkHorizontalPosition { WatermarkHorizontalPositionEnum_EnumValue }?, attribute WatermarkHorizontalOffset { xsd:double }?, attribute WatermarkVerticalPosition { WatermarkVerticalPositionEnum_EnumValue }?, attribute WatermarkVerticalOffset { xsd:double }?, element Properties { element WatermarkFontColor { InDesignUIColorType_TypeDef }? } ? }
```

**Table 21**: WatermarkPreference Properties Represented as Attributes

| Name                              | Type                                             | Req     | Description |
| --------------------------------- | ------------------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------- |
| WatermarkVisibility             | boolean                                          | no      | If true, the watermark is visible. |
| WatermarkDoPrint                  | boolean                                          | no      | If true, the watermark will print. |
| WatermarkDrawInBack             | boolean                                          | no      | If true, the watermark draws behind all page items. |
| WatermarkText                     | string                                           | no      | The text of the watermark. |
| WatermarkFontFamily             | string                                           | no      | The font family of the watermark text. |
| WatermarkFontStyle              | string                                           | no      | The FontStyle of the watermark text. |
| WatermarkFontPointSize          | int                                              | no      | The PointSize of the watermark text. |
| WatermarkOpacity                  | int                                              | no      | The opacity of the watermark text. |
| WatermarkRotation                 | int                                              | no      | The rotation of the watermark. |
| WatermarkHorizontalPosition   | WatermarkHorizontalPositionEnum_EnumValue   | no      | The horizontal origin of the watermark. Can be WatermarkHCenter, WatermarkHLeft, or WatermarkHRight. |
| WatermarkHorizontalOffset       | double                                           | no      | The offset of the watermark from its horizontal origin. |
| WatermarkVerticalPosition       | WatermarkVerticalPositionEnum_EnumValue     | no      | The vertical origin of the watermark. Can be WatermarkVCenter, WatermarkVLeft, or WatermarkVRight. |
| WatermarkVerticalOffset         | double                                           | no      | The offset of the watermark from its vertical origin. |

**Table 22**: WatermarkPreferenceProperties Represented as Elements

| Name                   | Type                                                   | Req     | Description |
| ---------------------- | ------------------------------------------------------ | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| WatermarkFontColor   | list of 3 doubles or InDesign UIColorType_TypeDef   | no      | The color for the watermark, specified either as an array of three doubles, each in the range 0 to 255 and representing R, G, and B values, or as a UI color. |

### 10.2.15 ConditionalTextPreference

**Schema Example 16. ConditionalTextPreference**

```rnc
ConditionalTextPreference_Object = element ConditionalTextPreference { attribute ShowConditionIndicators { ConditionIndicatorMode_EnumValue }?, attribute ActiveConditionSet { xsd:string }? }
```

**Table 23**: ConditionalTextPreference Properties Represented as Attributes

| Name                        | Type      | Req     | Description |
| --------------------------- | --------- | ------- | ------------------------------------------------------------------------------------------------------- |
| ShowConditionIndicators   | boolean   | no      | If true, display the condition indicators in the user interface. |
| ActiveConditionSet        | string    | no      | Areference to the active condtion set, as the value of the Self attribute of the <Condition> element. |

### 10.2.16 TextVariable

A text variable is an item you insert in text that varies according to the context. For example, the Last Page Number variable displays the page number of the last page of the document. If you add or remove pages, the variable is updated accordingly. The text variables in an IDML document are defined by <TextVariable> elements. Text variables come in a variety of types: <CustomTextVariablePreference>, <FileNameVariablePreference>, <PageNumberVariablePreference>, <ChapterNumberVariablePreference>, <DateVariablePreference>, <MatchCharacterStylePreference>, <MatchParagraphStylePreference>, or <CaptionMetadataVariablePreference >element.

The type of a text variable is defined by the Variable  Type attribute of the <TextVariable> element, and the definition of the text variable is specified in a child element of the <TextVariable> element.

A <TextVariable> element stored in the <Document> element is only the definition of the text variable. Text variable instances appear in <Story> elements, and all of the formatting of the text variable instance is defined there, not in the <Document> element. For more on text variables, refer to the InDesign online help.

**Schema Example 17. TextVariable**

```rnc
TextVariable_Object = element TextVariable { attribute Self { xsd:string }, attribute Name { xsd:string }, attribute VariableType { VariableTypes_EnumValue }?, ( CustomTextVariablePreference_Object?& FileNameVariablePreference_Object?& PageNumberVariablePreference_Object?& ChapterNumberVariablePreference_Object?& DateVariablePreference_Object?& MatchCharacterStylePreference_Object?& MatchParagraphStylePreference_Object?& CaptionMetadataVariablePreference_Object? ) }
```

**Table 24**: TextVariable Properties Represented as Attributes

| Name           | Type                       | Req     | Description |
| -------------- | -------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Name           | string                     | no      | The name of the text variable. |
| VariableType   | VariableTypes_EnumValue   | no      | The TextVariable type. Can be CustomText Type (Custom text variable), FileNameType (File name variable), LastPageNumberType (Last page number variable), ChapterNumberType (Chapter number variable), OutputDate Type (Output date variable), CreationDate Type (CreationDate variable), Modification DateType (ModificationDate variable), MatchCharacterStyleType (Running header CharacterStyle variable), MatchParagraph StyleType (Running header paragraph style variable), XrefPageNumberType (Cross ref- erence page number type), XrefChapter NumberType (Cross reference chapter number type), or LiveCaptionType (Metadata caption type). |

Text variables share some attributes, as shown in the following table.

**Table 25**: Common Text Variable Properties Represented as Attributes

| Name         | Type     | Req     | Description |
| ------------ | -------- | ------- | ------------------------------------------------------ |
| TextBefore   | string   | no      | Text that appears before the text variable instance. |
| TextAfter    | string   | no      | Text that appears after a text variable instance. |

**Schema Example 18. Custom  TextVariable  Preference**

```rnc
CustomTextVariablePreference_Object = element CustomTextVariablePreference { element Properties { element Contents { (string_type, xsd:string ) | (enum_type, SpecialCharacters_EnumValue ) | (object_type, xsd:string ) }? } ? }
```

**Table 26**: Custom  TextVariable  Preference Properties Represented as Elements

| Name       | Type                                        | Req     | Description |
| ---------- | ------------------------------------------- | ------- | ---------------------------------------------------------- |
| Contents   | Special Characters_Enum Value or string   | no      | The text contents of the CustomTextVariable- Preference. |

**Schema Example 19. File  Name  Variable  Preference**

```rnc
FileNameVariablePreference_Object = element FileNameVariablePreference { attribute TextBefore { xsd:string }?, attribute IncludePath { xsd:boolean }?, attribute IncludeExtension { xsd:boolean }?, attribute TextAfter { xsd:string }? }
```

**Table 27**: File  Name  Variable  Preference Properties Represented as Attributes

| Name               | Type      | Req     | Description |
| ------------------ | --------- | ------- | ----------------------------------------------------------------------- |
| IncludePath        | boolean   | no      | If true, include the file path in the text variable instances. |
| IncludeExtension   | boolean   | no      | If true, include the file extension in the text vari- able instances. |

**Schema Example 20. Page  Number  Variable  Preference**

```rnc
PageNumberVariablePreference_Object = element PageNumberVariablePreference { attribute TextBefore { xsd:string }?, attribute Format { VariableNumberingStyles_EnumValue }?, attribute TextAfter { xsd:string }?, attribute Scope { VariableScopes_EnumValue }? }
```

**Table 28**: Page  Number  Variable  Preference Properties Represented as Attributes

| Name     | Type                                   | Req     | Description |
| -------- | -------------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Format   | VariableNumberingStyles_EnumValue   | no      | The format of the page number. Can be Current, Arabic, UpperRoman, LowerRoman, UpperLetters, LowerLetters, Kanji, Full WidthArabic, SingleLeadingZeros, or DoubleLeadingZeros. |
| Scope    | VariableScopes_EnumValue              | no      | The scope of the page number variable. Can be DocumentScope or SectionScope. |

**Schema Example 21. Chapter  Number  Variable  Preference**

```rnc
ChapterNumberVariablePreference_Object = element ChapterNumberVariablePreference { attribute TextBefore { xsd:string }?, attribute Format { VariableNumberingStyles_EnumValue }?, attribute TextAfter { xsd:string }? }
```

**Table 29**: Chapter  Number  Variable  Preference Properties Represented as Attributes

| Name     | Type                                   | Req     | Description |
| -------- | -------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Format   | VariableNumberingStyles_EnumValue   | no      | The format of the chapter number. Can be Current, Arabic, UpperRoman, LowerRoman, UpperLetters, LowerLetters, Kanji, Full WidthArabic, SingleLeadingZeros, or DoubleLeadingZeros. |

**Schema Example 22. Date  Variable  Preference**

```rnc
DateVariablePreference_Object = element DateVariablePreference { attribute TextBefore { xsd:string }?, attribute Format { xsd:string }?, attribute TextAfter { xsd:string }? }
```

**Table 30**: Date  Variable  Preference Properties Represented as Attributes

| Name     | Type     | Req     | Description |
| -------- | -------- | ------- | ---------------------------------- |
| Format   | string   | no      | The format of the date variable. |

**Schema Example 23. MatchCharacterStylePreference**

```rnc
MatchCharacterStylePreference_Object = element MatchCharacterStylePreference { attribute TextBefore { xsd:string }?, attribute TextAfter { xsd:string }?, attribute AppliedCharacterStyle { xsd:string }?, attribute SearchStrategy { SearchStrategies_EnumValue }?, attribute ChangeCase { ChangeCaseOptions_EnumValue }?, attribute DeleteEndPunctuation { xsd:boolean }? }
```

**Table 31**: MatchCharacterStylePreference Properties Represented as Attributes

| Name                      | Type                            | Req     | Description |
| ------------------------- | ------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------- |
| AppliedCharacterStyle   | string                          | no      | Areference to the CharacterStyle applied to the text variable (as the value of the Self attribute of the <CharacterStyle> ). |
| ChangeCase                | ChangeCase Options_EnumValue   | no      | Change the case of the text variable. Can be Uppercase, Lowercase, Titlecase, or Sentencecase. |
| DeleteEnd Punctuation    | boolean                         | no      | If true, delete any punctuation at the end of the text variable. |
| SearchStrategy            | SearchStrategies_EnumValue     | no      | The search strategy applied to the text variable. Can be FirstOnPage or LastOnPage. |

**Schema Example 24. MatchParagraphStylePreference**

```rnc
MatchParagraphStylePreference_Object = element MatchParagraphStylePreference { attribute TextBefore { xsd:string }?, attribute TextAfter { xsd:string }?, attribute AppliedParagraphStyle { xsd:string }?, attribute SearchStrategy { SearchStrategies_EnumValue }?, attribute ChangeCase { ChangeCaseOptions_EnumValue }?, attribute DeleteEndPunctuation { xsd:boolean }? }
```

**Table 32**: MatchParagraphStylePreference Properties Represented as Attributes

| Name                      | Type                            | Req     | Description |
| ------------------------- | ------------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------- |
| AppliedCharacterStyle   | string                          | no      | Areference to the paragraph style applied to the text variable (as the value of the Self attribute of the <ParagraphStyle> ). |
| ChangeCase                | ChangeCase Options_EnumValue   | no      | Change the case of the text variable. Can be Uppercase, Lowercase, Titlecase, or Sentencecase. |
| DeleteEnd Punctuation    | boolean                         | no      | If true, delete any punctuation at the end of the text variable. |
| SearchStrategy            | SearchStrategies_EnumValue     | no      | The search strategy applied to the text variable. Can be FirstOnPage or LastOnPage. |

**Schema Example 25. CaptionMetadataVariablePreference**

```rnc
CaptionMetadataVariablePreference_Object = element CaptionMetadataVariablePreference { attribute TextBefore { xsd:string }?, attribute MetadataProviderName { xsd:string }?, attribute TextAfter { xsd:string }? }
```

**Table 33**: MatchParagraphStylePreference Properties Represented as Attributes

| Name                     | Type     | Req     | Description |
| ------------------------ | -------- | ------- | -------------------------------------------------------------------- |
| MetaDataProviderName   | string   | no      | The metadata provider name for the variable (see table following). |

**Table 34**: MetaData Provider Names

| Attribute Value                | Description |
| ------------------------------ | ---------------------------------------------------------------------------------------- |
| "$ID/#LinkInfoNameStr"         | Uses the file name of the linked file as the caption metadata value. |
| "$ID/#LinkInfoStatusStr"       | Uses the link status as the caption metadata value. |
| "$ID/#LinkInfoPageNumberStr"   | Uses the page number on which the linked file is placed as the caption metadata value. |
| "$ID/#LinkInfoSizeStr"         | Uses the size of the linked file as the caption metadata value. |
| "$ID/#LinkInfoColorSpaceStr"   | Uses the color space of the linked file as the caption metadata value. |

| "$ID/#LinkInfoColorProfileStr"     | Uses the ICC profile of the linked file as the caption metadata value. |
| ---------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "$ID/#LinkInfoLayerOverrideStr"    | Uses the Layer Overrides information for the linked file as the caption metadata value. |
| "$ID/#LinkInfoPPIStr"              | Uses the actual PPI of the linked file as the caption metadata value. |
| "$ID/#LinkInfoEffectivePPIStr"     | Uses the effective PPI of the linked file as the caption meta- data value. |
| "$ID/#LinkInfoTransparencyStr"     | Uses the transparency information (Yes/No) of the linked file as the caption metadata value. |
| "$ID/#LinkInfoPixelSizeStr"        | Uses the dimensions of the linked file as the caption metadata value. |
| "$ID/#LinkInfoScaleStr"            | Uses the scaling percentage of the linked file as the caption metadata value. |
| "$ID/#LinkInfoSkewStr"             | Uses the skew angle of the linked file as the caption metadata value. |
| "$ID/#LinkInfoRotationStr"         | Uses the rotation angle of the linked file as the caption meta- data value. |
| "$ID/#LinkInfoLayerNameStr"        | Uses the layer name on which the linked file is placed as the caption metadata value. |
| "$ID/#LinkInfoFullPathStr"         | Uses the full path of the linked file as the caption metadata value. |
| "$ID/#LinkInfoXMPApertureStr"      | Uses the XMPaperture information of the linked file as the caption metadata value. This corresponds to the "FNum- ber" element in the XMPnamespace "http://ns.adobe.com/ exif/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPShutterStr"       | Uses the XMPexposure time information of the linked file as the caption metadata value. This corresponds to the "Expo- sureTime " element in the XMPnamespace "http://ns.adobe. com/exif/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPISOSpeedStr"      | Uses the XMPISO speed rating of the linked file as the cap- tion metadata value. This corresponds to the "ISOSpeedRat- ings " element in the XMPnamespace "http://ns.adobe.com/ exif/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPFocalLengthStr"   | Uses the XMPfocal length of the linked file as the caption metadata value. This corresponds to the "FocalLength " ele- ment in the XMPnamespace "http://ns.adobe.com/exif/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPCaptureDateStr"   | Uses the XMPcapture date/time of the linked file as the cap- tion metadata value. This corresponds to the "DateTimeOrigi- nal " element in the XMPnamespace "http://ns.adobe.com/ exif/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPCameraStr"        | Uses the XMPcamera model information of the linked file as the caption metadata value. This corresponds to the "Model" element in the XMPnamespace "http://ns.adobe.com/ tiff/1.0/" in the linked file's XMPpacket. |

| "$ID/#LinkInfoXMPLensStr"                | Uses the XMPlens information of the linked file as the cap- tion metadata value. This corresponds to the "Lens" element in the XMPnamespace "http://ns.adobe.com/exif/1.0/aux/" in the linked file's XMPpacket. |
| ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "$ID/#LinkInfoUsedSwatchesStr"           | Uses the list of swatches used by the linked file as the caption metadata value. |
| "$ID/#LinkInfoXMPCreditStr"              | Uses the XMPcredits information of the linked file as the caption metadata value. This corresponds to the "Credit" element in the XMPnamespace "http://ns.adobe.com/photo- shop/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPHeadlineStr"            | Uses the XMPheadline information of the linked file as the caption metadata value. This corresponds to the "Headline" element in the XMPnamespace "http://ns.adobe.com/photo- shop/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPLocationStr"            | Uses the XMPlocation information of the linked file as the caption metadata value. This corresponds to the "Location" element in the XMPnamespace "http://iptc.org/std/Iptc4x- mpCore/1.0/xmlns/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPLocationCityS tr"       | Uses the XMPcity information of the linked file as the cap- tion metadata value. This corresponds to the "City" element in the XMPnamespace "http://ns.adobe.com/photoshop/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPLocation StateStr"     | Uses the XMPstate information of the linked file as the cap- tion metadata value. This corresponds to the "State" element in the XMPnamespace "http://ns.adobe.com/photoshop/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPLocation CountryStr"   | Uses the XMPcountry information of the linked file as the caption metadata value. This corresponds to the "Country" element in the XMPnamespace "http://ns.adobe.com/photo- shop/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoFormatTypeStr"             | Uses the file format of the linked file as the caption metadata value. |
| "$ID/#LinkInfoLinkTypeStr"               | Uses the link type of the linked file as the caption metadata value. |
| "$ID/#LinkInfoXMPTitleStr"               | Uses the XMPdocument title information of the linked file as the caption metadata value. This corresponds to the "title" element in the XMPnamespace "http://purl.org/dc/ele- ments/1.1/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPAuthorStr"              | Uses the XMPdocument author information of the linked file as the caption metadata value. This corresponds to the "creator" element in the XMPnamespace "http://purl.org/dc/ elements/1.1/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPDescriptionStr"         | Uses the XMPdescription information of the linked file as the caption metadata value. This corresponds to the "descrip- tion" element in the XMPnamespace "http://purl.org/dc/ele- ments/1.1/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPKeywordsStr"            | Uses the XMPkeywords of the linked file as the caption metadata value. This corresponds to the "subject" element in the XMPnamespace "http://purl.org/dc/elements/1.1/" in the linked file's XMPpacket. |

| "$ID/#LinkInfoXMPRatingStr"        | Uses the XMPrating of the linked file as the caption meta- data value. This corresponds to the "Rating" element in the XMPnamespace "http://ns.adobe.com/xap/1.0/" in the linked file's XMPpacket. |
| ---------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| "$ID/#LinkInfoXMPCreatorToolStr"   | Uses the XMPcreator tool information of the linked file as the caption metadata value. This corresponds to the "Creator- Tool" element in the XMPnamespace "http://ns.adobe.com/ xap/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPCreateDateStr"    | Uses the XMPcreation date-time of the linked file as the cap- tion metadata value. This corresponds to the "CreateDate" ele- ment in the XMPnamespace "http://ns.adobe.com/xap/1.0/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoXMPCopyrightStr"     | Uses the XMPcopyright information of the linked file as the caption metadata value. This corresponds to the "Copyright" element in the XMPnamespace "http://ns.adobe.com/xap/1.0/ rights/" in the linked file's XMPpacket. |
| "$ID/#LinkInfoPlaceDateStr"        | Uses the last imported date-time of the linked file as the cap- tion metadata value. |
| "$ID/#LinkInfoModDateStr"          | Uses the ModificationDate-time of the linked file as the cap- tion metadata value. |
| "$ID/#LinkInfoChildLinksStr"       | Uses the number of child links of the linked file as the caption metadata value. |
| "$ID/#LinkInfoFolder0Str"          | Uses the folder name in which the linked file exists as the caption metadata value. Blank if it is the root folder. |
| "$ID/#LinkInfoFolder1Str"          | Uses the folder name of the parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| "$ID/#LinkInfoFolder2Str"          | Uses the folder name of the second level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| "$ID/#LinkInfoFolder3Str"          | Uses the folder name of the third level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| "$ID/#LinkInfoFolder4Str"          | Uses the folder name of the fourth level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| "$ID/#LinkInfoFolder5Str"          | Uses the folder name of the fifth level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| "$ID/#LinkInfoFolder6Str"          | Uses the folder name of the sixth level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |

| "$ID/#LinkInfoFolder7Str"                | Uses the folder name of the seventh level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| "$ID/#LinkInfoFolder8Str"                | Uses the folder name of the eighth level parent of the folder in which the linked file exists as the caption metadata value. Blank if it is the root folder, or if path is too short to identify this folder. |
| "$ID/#LinkInfoVolumeNameStr"             | Uses the drive or root volume name of the linked file as the caption metadata value. |
| "$ID/#LinkInfoStoryModStr"               | Uses the story modification status of the linked story as the caption metadata value. |
| "$ID/#LinkInfoStoryNote CountDesc"      | Uses the number of notes in the linked story as the caption metadata value. |
| "$ID/#LinkInfoStoryTrack ChangesDesc"   | Uses the TrackChanges setting (on or off) of the linked story as the caption metadata value. |
| "$ID/#LinkInfoStoryLabelDesc"            | Uses the label of the linked story as the caption metadata value. |
| "$ID/#LinkInfoStoryAssignment Desc"     | Uses the name of the assignment to which the linked story belongs as the caption metadata value. |
| "$ID/#LinkInfoStoryAssigned ToDesc"     | Uses the UserName to whom the assignment containing the linked story is assigned as the caption metadata value. |
| "$ID/#LinkInfoWorkgroupStatus Str"      | Uses the Version Cue status of the linked file as the caption metadata value. |
| "$ID/#LinkInfoWorkgroupUserStr"          | Uses the Version Cue UserName of the linked file as the cap- tion metadata value. |

**IDML Example 11. TextVariable**

```xml
<TextVariable Self="dTextVariablenLast Page Number" Name="Last Page Number" Variable  Type="Last  Page Number  Type"> <PageNumberVariablePreference Self="d  Text Variablen  Last Page Number  PageNumberVariablePreference1" TextBefore="" Format="Current" TextAfter="" Scope="Section  Scope"/> </TextVariable>
```

### 10.2.17 Layer

InDesign documents can contain layers, which are transparent planes on which you can arrange the page items in your layout. Layers can be used to control the stacking order of objects in a document, but they can also be used to organize objects in a document. Layers in an InDesign document are document-wide. In IDML, <Layer> elements appear inside the <Document> element in the designmap.xml file.

For more on layers, refer to the InDesign online help.

**Schema Example 26. Layer**

```rnc
Layer_Object = element Layer { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute Visible { xsd:boolean }?, attribute Locked { xsd:boolean }?, attribute IgnoreWrap { xsd:boolean }?, attribute ShowGuides { xsd:boolean }?, attribute LockGuides { xsd:boolean }?, attribute UI { xsd:boolean }?, attribute Expendable { xsd:boolean }?, attribute Printable { xsd:boolean }?, element Properties { element LayerColor { InDesignUIColorType_TypeDef }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 35**: Layer Properties Represented as Attributes

| Name         | Type      | Req     | Description |
| ------------ | --------- | ------- | ------------------------------------------------------ |
| Expendable   | boolean   | no      | If true, the layer can be deleted. |
| IgnoreWrap   | boolean   | no      | If true, objects on the layer ignore text wrap. |
| Locked       | boolean   | no      | If true, the layer is locked. |
| LockGuides   | boolean   | no      | If true, the guides on the layer are locked. |
| Name         | string    | no      | The name of the layer. |
| Printable    | boolean   | no      | If true, the objects on the layer can be printed. |
| ShowGuides   | boolean   | no      | If true, show the guides assigned to the layer. |
| Visible      | boolean   | no      | If true, the layer is visible in the user interface. |

**Table 36**: Layer Properties Represented as Elements

| Name         | Type                            | Req     | Description |
| ------------ | ------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LayerColor   | InDesignUIColorType_TypeDef   | no      | The color of the layer, specified either as an array of three doubles, each in the range 0 to 255 and representing R, G, and B values, or as an InDesignUIColorType enumeration. |

**IDML Example 12. Layer**

```xml
<Layer Self="ub5" Name="Layer 1" Visible="true" Locked="false" IgnoreWrap="false" ShowGuides="true" LockGuides="false" UI="true" Expendable="true" Printable="true"> <Properties><LayerColor type="enumeration">Light Blue</LayerColor></Properties> </Layer>
```

### 10.2.18 Section

Page ranges in an InDesign document can be broken up into sections. Section properties control the page numbering system in use in the pages of the section. For more on sections, refer to the InDesign online help.

```rnc
Schema Example 27. Section Section_Object = element Section { attribute Self { xsd:string }, attribute Length { xsd:int }?, attribute Name { xsd:string }?, attribute AlternateLayoutLength { xsd:int }?, attribute AlternateLayout { xsd:string }?, attribute Pagination { PaginationOption_EnumValue }?, attribute PaginationMaster { xsd:string }?, attribute ContinueNumbering { xsd:boolean }?, attribute IncludeSectionPrefix { xsd:boolean }?, attribute PageNumberStart { xsd:int {minInclusive="1" maxInclusive="999999"} }?, attribute Marker { xsd:string }?, attribute PageStart { xsd:string }?, attribute SectionPrefix { xsd:string }?, element Properties { element PageNumberStyle { (enum_type, PageNumberStyle_EnumValue ) | (string_type, xsd:string ) }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

Note: InDesign features a variety of approaches to numbering and cross references; section numbering can interact with special characters, text variables, and paragraph numbering.

**Table 37**: Section Properties Represented as Attributes

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

| Name                      | Type                          | Req     | Description |
| ------------------------- | ----------------------------- | ------- | -------------------------------------------------------------------------------- |
| AlternateLayoutLength   | int                           | no      | The number of pages in the alternate layout sec- tion. |
| AlternateLayout           | string                        | no      | The alternate layout name for a set of pages. |
| Pagination                | PaginationOption_EnumValue   | no      | The pagination option for this section for adding and removing pages in HTML5. |
| PaginationMaster          | string                        | no      | The master to apply when pages are added in HTML5. |

### 10.2.19 DocumentUser

**Schema Example 28. DocumentUser**

```rnc
DocumentUser_Object = element DocumentUser { attribute Self { xsd:string }, attribute UserName { xsd:string }, element Properties { element UserColor { InCopyUIColorType_TypeDef }? } ? }
```

**Table 38**: DocumentUser Properties Represented as Attributes

| Name       | Type     | Req     | Description |
| ---------- | -------- | ------- | ----------------------- |
| UserName   | string   | no      | The name of the user. |

**Table 39**: DocumentUser Properties Represented as Elements

| Name        | Type                                               | Req     | Description |
| ----------- | -------------------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| UserColor   | list of doubles or InDesignUI ColorType_TypeDef   | no      | The color for the user, specified either as an array of three doubles, each in the range 0 to 255 and representing R, G, and B values, or as an InDesignUIColorType enumeration. |

### 10.2.20 Cross  Reference  Format

InDesign documents can contain cross references. Cross references are made up of <BuildingBlock> elements.

**Schema Example 29. CrossReferenceFormat**

```rnc
CrossReferenceFormat_Object = element CrossReferenceFormat { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute AppliedCharacterStyle { xsd:string }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( BuildingBlock_Object* ) }
```

**Table 40**: CrossReferenceFormat Properties Represented as Attributes

| Name                      | Type     | Req     | Description |
| ------------------------- | -------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------- |
| AppliedCharacterStyle   | string   | no      | Areference to the CharacterStyle applied to the cross reference format (as the value of the Self attribute of the <CharacterStyle>). |
| Name                      | string   | yes     | The name of the cross reference format. |

Cross references are made up of 'building blocks'-elements that specify text and text formatting that can be added to a cross reference (for more on building blocks, refer to the InDesign documentation). The <CrossReferenceFormat> element can contain multiple <BuildingBlock> elements.

**Schema Example 30. BuildingBlock**

```rnc
BuildingBlock_Object = element BuildingBlock { attribute Self { xsd:string }, attribute BlockType { BuildingBlockTypes_EnumValue }, attribute AppliedCharacterStyle { xsd:string }?, attribute CustomText { xsd:string }?, attribute AppliedDelimiter { xsd:string }?, attribute IncludeDelimiter { xsd:boolean }? }
```

**Table 41**: BuildingBlock Properties Represented as Attributes

| Name                      | Type                             | Req     | Description |
| ------------------------- | -------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AppliedCharacterStyle   | string                           | no      | Areference to the CharacterStyle applied to the cross reference format (as the value of the Self attribute of the <CharacterStyle>). A reference to the CharacterStyle applied to the text variable (as the value of the Self attribute of the <CharacterStyle>). |
| AppliedDelimiter          | string                           | no      | The delimiter character of the building block. |
| BlockType                 | BuildingBlockTypes_EnumValue   | no      | The type of the building block. Can be CustomStringBuildingBlock, FileNameBuildingBlock, ChapterNumberBuildingBlock, PageNumberBuildingBlock, FullParagraphBuildingBlock, ParagraphNumberBuildingBlock, ParagraphTextBuildingBlock, or BookmarkNameBuildingBlock. |
| CustomText                | string                           | no      | The text of the building block. Valid only when the BlockType is CustomStringBuilding Block. |

| Name               | Type      | Req     | Description |
| ------------------ | --------- | ------- | --------------------------------------------------------------------------- |
| IncludeDelimiter   | boolean   | no      | If true, include the delimiter character in the building block instances. |

**IDML Example 13. BuildingBlock**

```xml
<BuildingBlock Self="u8bBuildingBlock1" BlockType="ParagraphNumberBuildingBlock" AppliedCharacterStyle="n" CustomText="$ID/" AppliedDelimiter="$ID/" IncludeDelimiter="false"/>
```

### 10.2.21 Index

An index in an InDesign document.

**Schema Example 31. Index**

```rnc
Index_Object = element Index { attribute Self { xsd:string }, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( Topic_Object* ) }
```

#### Topic

A topic in an index.

**Schema Example 32. Topic**

```rnc
Topic_Object = element Topic { attribute Self { xsd:string }, attribute SortOrder { xsd:string }?, attribute Name { xsd:string }, ( Topic_Object*& CrossReference_Object* ) }
```

**Table 42**: Topic Properties Represented as Attributes

| Name        | Type     | Req     | Description |
| ----------- | -------- | ------- | --------------------------------------- |
| Name        | string   | yes     | The name of the topic. |
| SortOrder   | string   | no      | The indexing sort order of the topic. |

#### CrossReference

A cross reference topic in the document's index (not a cross reference text variable).

**Schema Example 33. CrossReference**

```rnc
CrossReference_Object = element CrossReference { attribute Self { xsd:string }, attribute ReferencedTopic { xsd:string }?, attribute CrossReferenceType { CrossReferenceType_EnumValue }?, attribute CustomTypeString { xsd:string }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 43**: Cross  Reference Properties Represented as Attributes

| Name                   | Type                             | Req     | Description |
| ---------------------- | -------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CrossReferenceType   | CrossReferenceType_EnumValue   | no      | The type of the cross reference. Can be CustomCrossReference, CustomCrossReferenceAfter, CustomCrossReferenceBefore, See, SeeAlso, SeeAlsoHerein, SeeHerein, or SeeOrAlsoBracket. |
| CustomTypeString       | string                           | no      | The string for a custom cross reference (used when CrossReferenceType is CustomCrossReference, CustomCrossReferenceAfter, or CustomCrossReferenceBefore). |
| ReferencedTopic        | string                           | no      | The topic of this cross reference. |

### 10.2.22 Hyperlinks

You can create hyperlinks in an InDesign document so that when you export to PDF, a viewer can click a link to jump to other locations in the same PDF document, to other PDF documents, or to web sites. Hyperlinks are made up of a hyperlink source and a hyperlink destination, and various display/formatting options.

A hyperlink source is hyperlinked text, a hyperlinked TextFrame, or a hyperlinked graphics frame. A hyperlink destination is the URL, position in text, or page to which a hyperlink jumps. A source can jump to only one destination, but any number of sources can jump to the same destination.

**Schema Example 34. Hyperlink**

```rnc
Hyperlink_Object = element Hyperlink { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute Source { xsd:string }, attribute Visible { xsd:boolean }?, attribute Highlight { HyperlinkAppearanceHighlight_EnumValue }?, attribute Width { HyperlinkAppearanceWidth_EnumValue }?, attribute BorderStyle { HyperlinkAppearanceStyle_EnumValue }?, attribute Hidden { xsd:boolean }?, attribute DestinationUniqueKey { xsd:int }?, element Properties { element BorderColor { InDesignUIColorType_TypeDef }?& element Destination { (element FileName { string_type, xsd:string }, element Volumn { string_type, xsd:string }, element DirectoryId { long_type, xsd:int }, element DataLinkClassId { long_type, xsd:int }, element DestinationUid { long_type, xsd:int }) | (object_type, xsd:string ) }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 44**: Hyperlink Properties Represented as Attributes

| Name                     | Type                                         | Req     | Description |
| ------------------------ | -------------------------------------------- | ------- | ------------------------------------------------------------------------------------------------ |
| Name                     | string                                       | yes     | The name of the hyperlink. |
| Source                   | string                                       | yes     | Areference to the source of the hyperlink (as the value of the Self attribute of the element). |
| Visible                  | boolean                                      | no      | If true, they hyperlink will be visible in the exported PDF. |
| Highlight                | HyperlinkAppearanceHighlight_EnumValue   | no      | The highight of the hyperlink. Can be None, Invert, Outline or Inset. |
| Width                    | HyperlinkAppearanceWidth_EnumValue        |         | The width of the stroke applied to the hyperlink Can be Thin, Medium, or Thick. |
| BorderStyle              | HyperlinkAppearanceStyle_EnumValue        | no      | The border style of the hyperlink. Can be Solid or Dashed. |
| Hidden                   | boolean                                      | no      | If true, the hyperlink is hidden in the output PDF. |
| DestinationUniqueKey   | int                                          | no      | Aunique key identifying the hyperlink destina- tion. |

#### HyperlinkPageDestination

A hyperlink page destination specifies a page in the document as the destination for a hyperlink.

**Schema Example 35. HyperlinkPageDestination**

```rnc
HyperlinkPageDestination_Object = element HyperlinkPageDestination { attribute Self { xsd:string }, attribute Name { xsd:string }, attribute NameManually { xsd:boolean }?, attribute DestinationPage { xsd:string }?, attribute ViewSetting { HyperlinkDestinationPageSetting_EnumValue }?, attribute ViewPercentage { xsd:double {minInclusive="5" maxInclusive="4000"} }?, attribute Hidden { xsd:boolean }?, attribute DestinationUniqueKey { xsd:int }?, element Properties { element ViewBounds { UnitRectangleBoundsType_TypeDef }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 45**: HyperlinkPageDestination Properties Represented as Attributes

| Name                     | Type                                            | Req     | Description |
| ------------------------ | ----------------------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| DestinationPage          | string                                          | no      | The destination (target) page of the hyperlink. |
| DestinationUniqueKey   | int                                             | no      | Aunique key identifying the hyperlink destina- tion. |
| Hidden                   | boolean                                         | no      | If true, the hyperlink is hidden in the PDF. |
| Name                     | string                                          | yes     | The name of the hyperlink page destination. The name must be unique within the IDML document. |
| NameManually             | boolean                                         | no      | If true, name the hyperlink page destination manually. |
| ViewPercentage           | double                                          | no      | The view percentage, if ViewSetting is Fixed. |
| ViewSetting              | HyperlinkDestinationPageSetting_EnumValue   | no      | The view at which to view the content of the hyperlink. Can be Fixed, FitView, FitWindow, FitWidth, FitHeight, FitVisible, or InheritZoom. |

**Table 46**: HyperlinkPageDestination Properties Represented as Elements

| Name         | Type                                 | Req     | Description |
| ------------ | ------------------------------------ | ------- | ------------------------------------------------------------------------------------------------------------- |
| ViewBounds   | UnitRectangleBoundsType_TypeDef   | yes     | The view rectangle, specified in the format [y1, x1, y2, x2]. Note: Valid only when view setting is Fixed. |

### HyperlinkURLDestination

A hyperlink page destination specifies a web address as the destination for a hyperlink.

**Schema Example 36. HyperlinkURLDestination**

```rnc
HyperlinkURLDestination_Object = element HyperlinkURLDestination { attribute Self { xsd:string }, attribute DestinationUniqueKey { xsd:int }?, attribute Name { xsd:string }, attribute DestinationURL { xsd:string }?, attribute Hidden { xsd:boolean }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 47**: HyperlinkPageDestination Properties Represented as Attributes

| Name                     | Type      | Req     | Description |
| ------------------------ | --------- | ------- | ---------------------------------------------------------------------------------------------- |
| DestinationUniqueKey   | int       | no      | Aunique key identifying the hyperlink URL destination. |
| DestinationURL           | string    | no      | The URL of the hyperlink. |
| Name                     | string    | yes     | The name of the hyperlink URL destination. The name must be unique within the IDML document. |
| Hidden                   | boolean   | no      | If true, the hyperlink is hidden in the PDF. |

#### HyperlinkExternalPageDestination

A hyperlink page destination specifies a page outside the document as the destination for a hyperlink.

**Schema Example 37. HyperlinkExternalPageDestination**

```rnc
HyperlinkExternalPageDestination_Object = element HyperlinkExternalPageDestination { attribute Self { xsd:string }, attribute DestinationUniqueKey { xsd:int }?, attribute Name { xsd:string }?, attribute DocumentPath { xsd:string }?, attribute DestinationPageIndex { xsd:int {minInclusive="1" maxInclusive="9999"} }?, attribute ViewSetting { HyperlinkDestinationPageSetting_EnumValue }?, attribute ViewPercentage { xsd:double {minInclusive="5" maxInclusive="4000"} }?, attribute Hidden { xsd:boolean }?, element Properties { element ViewBounds { UnitRectangleBoundsType_TypeDef }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 48**: HyperlinkExternalPageDestination Properties Represented as Attributes

| Name                     | Type                                            | Req     | Description |
| ------------------------ | ----------------------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| DestinationPageIndex   | int                                             | no      | The index of the destination page in the target document. Range: 1 to 9999. |
| DocumentPath             | string                                          | no      | The path to the target document of the hyper- link. |
| DestinationUniqueKey   | int                                             | no      | Aunique key identifying the hyperlink URL destination. |
| Name                     | string                                          | yes     | The name of the hyperlink external page desti- nation. |
| ViewSetting              | HyperlinkDestinationPageSetting_EnumValue   | no      | The view at which to view the content of the hyperlink. Can be Fixed, FitView, FitWindow, FitWidth, FitHeight, FitVisible, or InheritZoom. |
| ViewPercentage           | double                                          | no      | The view percentage, if ViewSetting is Fixed. |

**Table 49**: HyperlinkExternalPageDestination Properties Represented as Elements

| Name         | Type                   | Req     | Description |
| ------------ | ---------------------- | ------- | ------------------------------------------------------------------------------------------------------------- |
| ViewBounds   | list of four doubles   | yes     | The view rectangle, specified in the format [y1, x1, y2, x2]. Note: Valid only when view setting is Fixed. |

#### HyperlinkPageItemSource

A hyperlink page item source is a hyperlink associated with a page item.

**Schema Example 38. HyperlinkPageItemSource**

```rnc
HyperlinkPageItemSource_Object = element HyperlinkPageItemSource { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute SourcePageItem { xsd:string }, attribute Hidden { xsd:boolean }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Table 50**: HyperlinkExternalPageDestination Properties Represented as Attributes

| Name     | Type      | Req     | Description |
| -------- | --------- | ------- | --------------------------------------------------------------------------- |
| Name     | string    | yes     | The name of the hyperlink external page desti- nation. |
| Hidden   | boolean   | no      | If true, the hyperlink page item source will be hidden in the output PDF. |

| Name             | Type     | Req     | Description |
| ---------------- | -------- | ------- | --------------------------------------------------------------- |
| SourcePageItem   | string   | yes     | Areference to a page item as the value of its Self attribute. |

**IDML Example 14. Hyperlink**

```xml
<HyperlinkURLDestination Self="HyperlinkURLDestination/adobe.com" DestinationUniqueKey="1" Name="adobe.com" DestinationURL="http://www.adobe.com" Hidden="false"/> <Hyperlink Self="ufb" Name="website" Source="uf8" Visible="false" Highlight="None" Width="Thin" BorderStyle="Solid" Hidden="false" DestinationUniqueKey="1"> <Properties> <BorderColor type="enumeration">Black</BorderColor> <Destination type="object">HyperlinkURLDestination/adobe.com</Destination> </Properties> </Hyperlink>
```

### 10.2.23 Bookmark

InDesign documents can add bookmarks for navigation in PDFs you export.

**Schema Example 39. Bookmark**

```rnc
Bookmark_Object = element Bookmark { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute Destination { xsd:string }, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( Bookmark_Object* ) }
```

**Table 51**: Bookmark Properties Represented as Attributes

| Name          | Type     | Req     | Description |
| ------------- | -------- | ------- | -------------------------------------------------------------------------------------------- |
| Destination   | string   | no      | The destination of the bookmark, as a reference to the Self attribute of a <Page> element. |
| Name          | string   | yes     | The name of the bookmark. |

### 10.2.24 PreflightProfile

**Schema Example 40. PreflightProfile**

```rnc
PreflightProfile_Object = element PreflightProfile { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute Description { xsd:string }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( PreflightProfileRule_Object*& PreflightRuleInstance_Object* ) }
```

**Table 52**: PreflightProfile Properties Represented as Attributes

| Name          | Type     | Req     | Description |
| ------------- | -------- | ------- | ------------------------------------------- |
| Description   | string   | no      | The description of the preflight profile. |

#### PreflightProfileRule

**Schema Example 41. PreflightProfileRule**

```rnc
PreflightProfileRule_Object = element PreflightProfileRule { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute Id { xsd:string }, attribute Description { xsd:string }?, attribute Flag { PreflightRuleFlag_EnumValue }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( RuleDataObject_Object* ) }
```

**Table 53**: PreflightProfileRule Properties Represented as Attributes

| Name          | Type                            | Req     | Description |
| ------------- | ------------------------------- | ------- | ---------------------------------------------------------------------------------------- |
| Description   | string                          | no      | The description of the preflight profile rule. |
| Flag          | PreflightRuleFlag_EnumValue   | no      | Can be ReturnAsError, ReturnAsInformational, ReturnAsWarning, or RuleIsDisabled. |
| Id            | string                          | yes     | The unique ID of the preflight rule. |

**Schema Example 42. RuleDataObject**

```rnc
RuleDataObject_Object = element RuleDataObject { attribute Self { xsd:string }, attribute Name { xsd:string }, attribute DataType { RuleDataType_EnumValue }, attribute Id { xsd:string }?, element Properties { element DataValue { (string_type, xsd:string ) | (double_type, xsd:double ) | (long_type, xsd:int ) | (short_type, xsd:short ) | (bool_type, xsd:boolean ) | (object_type, xsd:string ) | (list_type, element ListItem { (string_type, xsd:string ) | (double_type, xsd:double ) | (long_type, xsd:int ) | (short_type, xsd:short ) | (bool_type, xsd:boolean ) | (object_type, xsd:string ) | (list_type, element PreflightRuleDataListType { PreflightRuleDataListType_TypeDef }* ) }* ) } } }
```

**Table 54**: RuleDataObject Properties Represented as Attributes

| Name       | Type                      | Req     | Description |
| ---------- | ------------------------- | ------- | ----------------------------------- |
| DataType   | RuleDataType_EnumValue   | yes     | The data type of the rule. Can be |
| ID         | string                    | no      | The ID of the rule. |

**Table 55**: RuleDataObject Properties Represented as Elements

| Name         | Type                                   | Req     | Description |
| ------------ | -------------------------------------- | ------- | ----------------------------------- |
| Properties   | PreflightRule DataListType_TypeDef   | yes     | The preflight rule specification. |

#### PreflightRuleInstance

**Schema Example 43. PreflightRuleInstance**

```rnc
PreflightRuleInstance_Object = element PreflightRuleInstance { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute Id { xsd:string }, attribute Description { xsd:string }?, attribute Flag { PreflightRuleFlag_EnumValue }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( RuleDataObject_Object* ) }
```

**Table 56**: PreflightRuleInstance Properties Represented as Attributes

| Name          | Type                            | Req     | Description |
| ------------- | ------------------------------- | ------- | ---------------------------------------------------------------------------------------- |
| Description   | string                          | no      | The description of the preflight rule instance. |
| Flag          | PreflightRule Flag_EnumValue   | no      | Can be ReturnAsError, ReturnAs Informational, ReturnAsWarning, or RuleIsDisabled. |
| Id            | string                          | yes     | The unique ID of the preflight rule. |

### 10.2.25 DataMergeImagePlaceholder

**Schema Example 44. DataMergeImagePlaceholder**

```rnc
DataMergeImagePlaceholder_Object = element DataMergeImagePlaceholder { attribute Self { xsd:string }, attribute Field { xsd:string }, attribute PlaceholderPageItem { xsd:string } }
```

**Table 57**: DataMergePlaceholder Properties Represented as Attributes

| Name                    | Type     | Req     | Description |
| ----------------------- | -------- | ------- | ------------------------------------------------------------------ |
| Field                   | string   | yes     | The name of the associated data field. |
| PlaceholderPage Item   | string   | yes     | Areference to the Self attribute of the place- holder page item. |

### 10.2.26 HyphenationException

**Schema Example 45. HyphenationException**

```rnc
HyphenationException_Object = element HyphenationException { attribute Self { xsd:string }, attribute Name { xsd:string }, attribute RemovedExceptions { list { xsd:string * } }?, attribute AddedExceptions { list { xsd:string * } }? }
```

**Table 58**: HyphenationException Properties Represented as Attributes

| Name                | Type              | Req     | Description |
| ------------------- | ----------------- | ------- | ------------------------------------------ |
| RemovedExceptions   | list of strings   | no      | Alist of removed hyphenation exceptions. |
| AddedExceptions     | list of strings   | no      | Alist of added hyphenation exceptions. |

### 10.2.27 IndexingSortOption

**Schema Example 46. IndexingSortOption**

```rnc
IndexingSortOption_Object = element IndexingSortOption { attribute Self { xsd:string }, attribute Name { xsd:string }, attribute Include { xsd:boolean }?, attribute Priority { xsd:int }?, attribute HeaderType { (HeaderTypes_EnumValue ) | (NothingEnum_EnumValue ) }? }
```

**Table 59**: IndexingSortOption Properties Represented as Attributes

| Name         | Type                     | Req     | Description |
| ------------ | ------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Include      | boolean                  | no      | If true, include the indexing sort option when generating the index. |
| HeaderType   | HeaderTypes_EnumValue   | no      | Indexing sort option header types. Can be BasicLatin, Belarusian, Bulgarian, ChinesePinyin, ChineseStrokeCount, Croatian, Czech, DanishNorwegian, Estonian, SwedishFinnish, HiraganaAll, HiraganaConsonantsOnly, Hungarian, Katakana, KatakanaConsonantsOnly, KoreanConsonant, KoreanConsonant PlusVowel, Latvian, Lithuanian, Polish, Romanian, Russian, Slovak, Slovenian, Spanish, Turkish, or Ukranian. |
| Priority     | int                      | no      | Priority of this indexing sort option (shuffles prior entries down). |

### 10.2.28 ABullet

**Schema Example 47. ABullet{**

```rnc
ABullet_Object = element ABullet { attribute Self { xsd:string }, attribute CharacterType { BulletCharacterType_EnumValue }?, attribute CharacterValue { xsd:int }?, element Properties { element BulletsFont { (object_type, xsd:string ) | (string_type, xsd:string ) | (enum_type, AutoEnum_EnumValue ) }?& element BulletsFontStyle { (string_type, xsd:string ) | (enum_type, NothingEnum_EnumValue ) | (enum_type, AutoEnum_EnumValue ) }? } ? }
```

**Table 60**: ABullet Properties Represented as Attributes

| Name             | Type                              | Req     | Description |
| ---------------- | --------------------------------- | ------- | ------------------------------------------------------------------------------- |
| CharacterType    | BulletCharacterType_EnumValue   | no      | The character type. Can be GlyphWithFont, UnicodeOnly, or UnicodeWithFont. |
| CharacterValue   | int                               | no      | The bullet character as a unicode ID or a glyph ID. |

**Table 61**: ABullet Properties Represented as Elements

| Name               | Type                                                               | Req     | Description |
| ------------------ | ------------------------------------------------------------------ | ------- | ------------------------------------- |
| BulletsFont        | string, a reference to a font element, or an AutoEnum_EnumValue   | no      | Font of the bullet character. |
| BulletsFontStyle   | string, Nothing Enum_EnumValue, AutoEnum_EnumValue               | no      | FontStyle of the bullet character. |

### 10.2.29 Assignment

**Schema Example 48. Assignment**

```rnc
Assignment_Object = element Assignment { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute UserName { xsd:string }?, attribute ExportOptions { AssignmentExportOptions_EnumValue }?, attribute IncludeLinksWhenPackage { xsd:boolean }?, attribute FilePath { xsd:string }, element Properties { element FrameColor { (InDesignUIColorType_TypeDef ) | (enum_type, NothingEnum_EnumValue ) }?& element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( AssignedStory_Object* ) }
```



| Name       | Type     | Req     | Description |
| ---------- | -------- | ------- | ---------------- |
| UserName   | string   | no      | The UserName. |

| Name                        | Type                                  | Req     | Description |
| --------------------------- | ------------------------------------- | ------- | --------------------------------------------------------------- |
| ExportOptions               | AssignmentExportOptions_EnumValue   | no      | Can be AssignedSpreads, EmptyFrames, or Everything. |
| IncludeLinksWhenPackage   | boolean                               | no      | If true, includes linked files when packaging the assignment. |
| FilePath                    | string                                | yes     | The file path to the saved assignment. |

**Table 62**: Assignment Properties Represented as Elements

| Name         | Type                                                                        | Req     | Description |
| ------------ | --------------------------------------------------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| FrameColor   | list of doubles, InDesignUIColorType_TypeDef, or NothingEnum_EnumValue   | no      | The color of the assignment's frames, specified either as an array of three doubles, each in the range 0 to 255 and representing R, G, and B values, or as an InDesignUIColorType enumeration. |

#### AssignedStory

**Schema Example 49. Assignment Properties Represented as Attributes**

```rnc
AssignedStory_Object = element AssignedStory { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute StoryReference { xsd:string }?, attribute FilePath { xsd:string }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ? }
```

**Schema Example 50. Assignment Properties Represented as Attributes**

| Name             | Type     | Req     | Description |
| ---------------- | -------- | ------- | ------------------------------------------------ |
| StoryReference   | string   | no      | Areference to the AssignedStory. |
| FilePath         | string   | no      | The file path (colon delimited on the Mac OS). |

### 10.2.30 Article

Articles give users a way to associate page items with each other for export to electronic publishing (ePub) formats. For more on articles, refer to the Adobe InDesign CS5.5 online help.

The <Article> element appears as a child of the <Document> element (in an IDML package, the <Document> element is in the designmap.xml file). The <Article> element includes a list of one or more <ArticleMember> elements. Each <ArticleMember> element corresponds to a page item associated with the article.

The <ArticleMember> elements contain the attribute ItemRef, which simply points to the unique ID (self attribute) of the corresponding page item (for more on element cross references in IDML documents, refer to 9.5.4, 'Object Reference Format,' in the Adobe IDML File Format Specification). A given page item can be associated with any number of articles.

**Schema Example 51. Article**

```rnc
Article_Object = element Article { attribute Self { xsd:string }, attribute Name { xsd:string }?, attribute ArticleExportStatus { xsd:boolean }?, element Properties { element Label { element KeyValuePair { KeyValuePair_TypeDef }* }? } ?, ( ArticleMember_Object* )}
```

**Table 63**: Article Properties Represented as Attributes

| Name                    | Type      | Req     | Description |
| ----------------------- | --------- | ------- | ------------------------------------------------------------- |
| ArticleExportStatus   | boolean   | no      | If true, include the article information in exported files. |

**Table 64**: Article Properties Represented as Elements

| ArticleMember     | ArticleMember_Object     | yes     | Alist of one or more article members (which store cross references to the page items associ- ated with the article). |
| ----------------- | ------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------ |

**IDML Example 15. Article**

```xml
<Article Self="ue1" Name="my article1" ArticleExportStatus="true"> <ArticleMember Self="ue1ArticleMember0" ItemRef="ue0"/> <ArticleMember Self="ue1ArticleMember1" ItemRef="udc"/> </Article>
```

#### ArticleMember

**Schema Example 52. ArticleMember**

```rnc
ArticleMember_Object = element ArticleMember { attribute Self { xsd:string }, attribute ItemRef { xsd:string } }
```

**Table 65**: ArticleMember Properties Represented as Attributes

| Name      | Type     | Req     | Description |
| --------- | -------- | ------- | ----------------------------------------------------------------- |
| ItemRef   | String   | yes     | Areference to the self attribute of the associ- ated page item. |
