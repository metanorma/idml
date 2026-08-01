## 10.1 Common Attributes and Elements

A number of attributes an elements are shared by a large number of elements in the files that make up an IDML package. Rather than repeat the definition of these elements, we'll document them int he following sections.

### 10.1.1 Self

The Self attribute contains a unique identifier for the elements that contain it. This identifier is used elsewhere in the IDML package to refer to the element, as discussed in the <hyperlink>'Object Reference Format'</hyperlink> section of this specification.


**Schema Example 2. Self**

```rnc
attribute Self { 
    xsd:string 
}
```

The following example shows the attribute of a element.

**IDML Example 5. Self**

```xml
<Story Self="udd" .../>
```

### 10.1.2 Scripting Labels

Many of the elements in the files contained in an IDML package can contain a <Label> element. This element represents a feature of InDesign's scripting object model: most non-text objects can contain any number of key/value pairs as strings. These objects have a default label property, but can have custom labels associated with them. Both the key and the value of a script label can be strings of any length.

For more on using script labels, refer to the Scripting chapter of the Adobe InDesign CS4 Scripting Guide for your scripting language of choice (AppleScript, JavaScript, or VBScript).

**Schema Example 3. Label**

```rnc
element Properties {
    element Label {
        element KeyValuePair {
            KeyValuePair_Type
        }*
    }?
}
```

The following example shows both the default label (Key attribute is "Label") and a custom label that has been added with the scripting method insertLabel.

**IDML Example 6. Label**

```xml
<Label>
    <KeyValuePair Key="Label" Value="This is a script label."/>
</Label>
<Label>
    <KeyValuePair Key="myCustomLabel" Value="This is a custom script label."/>
</Label>
```

| ElementName     | Element Description                                            | Element Description                                            | Element Description |
| --------------- | -------------------------------------------------------------- | -------------------------------------------------------------- | -------------------------------------------------------------- |
| Label           | The scripting label(s) associated with the object. Optional.  | The scripting label(s) associated with the object. Optional.  | The scripting label(s) associated with the object. Optional. |
| AttributeName   | Type                                                           | Req                                                            | Description |
| Key             | string                                                         | yes                                                            | The key of the label. |
| Value           | string                                                         | no                                                             | The string stored in the label. |

*Note: Only the default label is visible in the InDesign user interface (in the Script Label panel).*

### 10.1.3 Optional Values, Defaults, and Preferences

As you look through the IDML schema, you'll notice that most of the attributes and elements are marked as being optional. When you look at the schema for a <Rectangle> element, for example, you'll see that the <PathGeometry> element is optional. Since the <PathGeometry> element contains the list of path points that define the shape of the rectangle (see 'Page Item Geometry'), it is difficult to understand how it can be optional. What does this mean, in practical terms?

First, it is technically true that the <PathGeometry> element can be omitted. If you omit the <PathGeometry> element from the <Rectangle> element, InDesign will create a default-sized rectangle when you open the IDML file. The default size and location of the rectangle don't really matter-the point is that InDesign supplies default values for the missing values in the IDML file. While this is an extreme case-we don't expect that you'll ever want to construct a rectangle without specifying its size and location-it shows that you can construct documents from very minimal XML elements.

When you look at an IDML file that you've exported from InDesign, you'll see a very large number of XML elements. A <Document> element alone usually contains dozens of <Language>, <TextVariable>, and <CrossReferenceFormat> elements, among others. When you create IDML files yourself, you can omit these elements. They are only included in the IDML file by InDesign to ensure round-trip fidelity of the document. If you omit these default elements, InDesign will create the corresponding default objects in the InDesign document as it opens the IDML file.

This behavior corresponds to the way that InDesign handles defaults and preferences when you create documents using the user interface. When you use user interface controls to change various settings when no documents  are open, you're modifying the application defaults . Application defaults change the way that all new documents are created, but have no effect on existing documents. When you change settings in a document when no objects are selected, on the other hand, you're changing the document defaults . All new objects created in the document will take on the appropriate default values, but existing objects in the document (and objects in other documents) will be unaffected. (For more on InDesign's defaults handling, refer to the online help.)

IDML, however, cannot rely on the application defaults, because they can be changed by the user. IDML also cannot rely on document defaults, because the IDML schema specifies that most or all of the document default values are optional. Instead, IDML gets default values for omitted optional values from the IDML defaults file. This mechanism takes the place of both application and document defaults in the user-interface scenario described above, and guarantees that

the behavior of an IDML document will remain consistent, regardless of the user settings and installation details (such as the locale of the application). If a document default value is not found in the IDML document, InDesign will use the corresponding value from the IDML defaults file.

Typically, users set document defaults to specify a commonly-used formatting attribute-the default font, stroke weight, or FillColor, for example. IDML mirrors this practice by providing two very useful and important elements: <PageItemDefault> and <TextDefault> (in an IDML package file, you'll find these in the Preferences.xml file inside the Resources folder). The values that you provide in these elements define the default formatting for text and page items in the document.

When you define a default value for an attribute or element in one of these elements, all elements of a given type that have not explicitly overridden that value will inherit the formatting specified by the default.

Here's an example: let's say that you want the default stroke weight for all page items in a document to be two points. To do this, you change the value of the StrokeWeight attribute of the <PageItemDefault> element to 2. This means that all page items that you add to the document will have a stroke weight of two points. If you want to override the default stroke weight on a page item, you enter a different value in the corresponding attribute in the element defining the page item. In this example, if you want to specify that the stroke weight of a particular rectangle is one point, you'd set the value of the StrokeWeight attribute of the <Rectangle> object to 1. This value overrides the formatting specified in the <PageItemDefault> element.

In short, if the page item itself specifies the stroke weight, then InDesign uses that stroke weight value. If the page item does not specify the stroke weight, then InDesign uses the stroke weight value stored in the <PageItemDefault> element. If the <PageItemDefault> element IDML document does not specify a stroke weight, or if the IDML document does not contain a <PageItemDefault> element, then InDesign will use the stroke weight value from the <PageItemDefault> element in the IDML defaults file.

Note: The above example is a bit of an oversimplification in that it assumes that the default object style applied to new rectangles is InDesign's built-in 'None' object style (which is an object style that cannot be edited). This is InDesign's default behavior, but can be changed by users. In IDML, you would specify this default by setting the AppliedObjectStyle attribute of the <PageItemDefault> element to ObjectStyle/$ID/[None].

This makes writing your own IDML much easier-if you know that most of the page items you'll be creating in an IDML document will share the same formatting, you can specify that formatting in the <PageItemDefault> element and then omit the corresponding attributes and elements when you enter the <Rectangle>, <Oval>, <Polygon>, and <GraphicLine> elements that share those formatting attributes.

Note: If you are creating your own InDesign snippet files (.idms), you cannot specify the default formatting in this way-the <PageItemDefault> and <TextDefault> elements are not used in snippets. Instead, snippet files get their default formatting from the InDesign documents in which they are placed. This is the same behavior as importing a snippet file created by InDesign, but it means that if you're creating a snippet file, you'll need to fully specify all formatting that you don't want overridden by the formatting of the documents the snippet will be imported into. For more on importing and exporting snippets, refer to the InDesign online help. For more on the differences between the snippet format and document-level IDML, refer to 'Appendix B: Snippets and ICML Documents.'

As you continue to look through an IDML document exported from InDesign, you'll also see a number of preference elements (such as the <XMLImportPreference> , <XMLExportPreference> , or <LayoutAdjustmentPreference> elements). Again, these elements are included to maintain round-trip fidelity of the InDesign document, and have no effect on the construction of spreads, stories, and page items in an IDML file. The settings in the <XMLImportPreference> element, for example, will not have an effect until a user chooses File>Import XML in the InDesign document created by opening the IDML document. The content of the IDML document does not change.

When you're writing your own IDML, you can generally omit these preferences objects. The only case in which you might want to include these preference elements is if you are creating files in a workgroup setting and need to maintain standard behaviors across all documents. If, for example, your workgroup requires that the Adjust Layout feature is turned on, you'd set the EnableLayoutAdjustment attribute of the <LayoutAdjustmentPreference> element to true. For more on the preferences objects, see 'Preferences.xml.'
