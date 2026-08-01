# 4 INX, IDML, and In  Design Scripting

INX, the precursor to IDML, was introduced to give In  Design the ability to save a document for use in a previous version. Rather than write a complicated and error-prone binary file conversion plug-in, we decided to use In  Design's scripting features. When In  Design exports to INX or IDML, we serialize objects and properties from the scripting DOM of an In  Design document to an XML file. When we open an INX or IDML document, In  Design constructs layout objects, sets preferences, enters text, and applies formatting to produce an In  Design document.

IDML will continue to be built on and reflect the scripting DOM view of the In  Design object model. The scripting system provides several vital benefits:

- A high-level isolation from the details and changes in the low-level In  Design object model.
- Well-documented and easily understood architecture for extending the object model and the file format to add third-party data. There is also an existing policy and procedure for developers to register their objects and attributes to ensure that the object names they add are unique within the scripting DOM.
- Significant level of object and property parameter validation and error checking.
- High level versioning support and a well-defined mechanism for adding, deleting, or modifying items.

IDML differs from the scripting DOM in the following ways:

- Scripting events (methods) are not included in IDML document.
- IDML requires that some elements and attributes appear in certain order, while scripting DOM can be viewed as random access.
- Some objects and properties that are included in IDML may not be available in scripting object models for Apple  Script, Java  Script, VBScript, and vice versa.
- In some cases, property values that are the same as default values are not written out to IDML.

The following example shows the close connection between scripting and IDML:

## Script (Java  Script):

```
//Where my  Rectangle is a reference to a rectangle: my Rectangle.stroke  Weight = .5; my Rectangle.corner  Option = Corner Options.bevel  Corner; IDML: <Rectangle Stroke  Weight=".5" Corner Option="Bevel  Corner" .../>
```

Given the close connection of IDML to In  Design scripting, the In  Design scripting documentation and example scripts provide a great way to learn about the format. The scripting object model is also exposed to scripting clients, and can be viewed from script editors (such as the Adobe Extend  Script Toolkit) for any of the supported scripting languages.


## Table of Contents
- [4.1 Dynamic Object Model](4_1_dynamic_object_model.md)
- [4.2 IDML and Third Party Data](4_2_idml_and_third_party_data.md)


## 4.1 Dynamic Object Model

It is important to note that In  Design's scripting object model is dynamic, and changes based on the active set of plug-ins. If you add plug-ins that support In  Design scripting, objects, properties, enumerations, and methods can appear in the scripting object model, and new objects and properties may appear in the exported IDML. In addition, removing or disabling plug-ins can change the scripting object model and, therefore, the XML elements written to an IDML file.


## 4.2 IDML and Third Party Data

IDML supports the inclusion of new scripting objects and properties added by In  Design plug-ins. Because IDML is built on the In  Design scripting object model, any features added by plug-ins that support In  Design scripting can be included in the IDML package.

That said, IDML does not guarantee round-trip of data added to an In  Design document by third party plug-ins. If the third party plug-in does not implement scripting at all, or if the scripting support for the plug-in is not complete, the data will not be included when you export as IDML.

If the IDML file calls for a plug-in that is not currently installed, In  Design will ignore the plugin data (i.e., omit it from the InDesign file created by opening the IDML document) and will not include it in a subsequent IDML export of the file. Note that this differs from InDesign's behavior when opening InDesign binary files, where third-party data is maintained when the plug-ins are missing (refer to the In  Design documentation for a more complete description of this behavior).

Since IDML is an XML format, you can add your own XML elements the XML files in the IDML package. Note, however, that In  Design will ignore XML elements that do not exist in the IDML schema when opening the IDML file, and that the data will not be preserved in the converted InDesign binary document (and will therefore not be included in future IDML export from that document).
