## 10.11 XMLTags

The <XMLTag> element represents an XML tag in an InDesign document. In an IDML package, tags are define in the Tags.xml file inside the XML folder. For more on creating and applying XML tags, refer to the InDesign online help.

**Schema Example 177. XMLTag**

```rnc
XMLTag_Object = element XMLTag {
    attribute Self { xsd:string },
    attribute Name { xsd:string },
    element Properties {
        element TagColor { InDesignUIColorType_TypeDef }? &
        element Label { 
            element KeyValuePair { KeyValuePair_TypeDef }* 
        }?
    }?
}
```

**Table 193**: XMLTag Properties Represented as Attributes

| Name     | Type     | Req     | Description |
| -------- | -------- | ------- | ------------------------- |
| Name     | string   | yes     | The name of the XMLtag. |

**Table 194**: XMLTag Properties Represented as Elements

| Name       | Type                    | Req     | Description |
| ---------- | ----------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------- |
| TagColor   | InDesignUIColorType   | no      | The color of the XMLtag. TagColor can be a UIColor enumeration or an RGB color as a list of three <ListItem> elements (in the order R, G, B). |

**IDML Example 100. XMLTag**

```xml
<XMLTag Self="XMLTag\cbody_text" Name="body_text"> 
    <Properties> 
        <TagColor type="enumeration">
            Yellow
        </TagColor> 
    </Properties> 
</XMLTag>
```