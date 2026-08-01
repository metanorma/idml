# 7 IDML Design Approaches

To recognize our design goals for IDML, we have adopted a series of design philosophies, which we'll discuss in the following sections.

## 7.1 Separate Content for Efficient Processing

In  Design is often part of workflows where documents are broken into pieces so that they might be worked on in parallel. In a magazine production process, for example, sections, articles, or individual spreads might be given to different graphic artists or layout staff; stories can be given to different writers and editors. The same thing can be true for the process of assembling an IDML document. Stories might be populated with text from RSS feeds; informational graphics on a given spread might be generated from spreadsheet data.

In addition, In  Design documents contain a large number of entities that might be standardized across an organization or publication. Document preferences, styles, fonts, and colors, for example, might be common to all production processes for a particular job. These preferences can be stored in separate XML files and added to an IDML package.

All of the parts of an IDML file are put together in a Zip-compressed archive to represent one InDesign document. Inside this container, a specific 'master' file defines the relationships between the component files included in the container.

## 7.2 Maximize Compatibility with In  Design

IDML reflects the scripting DOM view of an In  Design document. It was designed to maximize compatibility and consistency with the In  Design binary file and represent In  Design document as accurately as possible.

IDML files do not retain any view or history data of the document; the intent is to represent the appearance and content of the document in XML.

Being able to convert back and forth between the In  Design binary file format and IDML is a requirement. In most cases, we must convert between IDML and In  Design binary representations, and each representation should be able to carry extensions added to the other.

There are many workflows involving conversions between IDML format and In  Design binary format. We also want to encourage a variety of uses that we may not have envisioned. Some general classes of workflows include following:

- IDML documents can be constructed from information in a database or from a wire feed using XML tools, and then opened in In  Design for further processing.
- An In  Design document can be exported to IDML for use as a template outside of In  Design. The IDML template can be modified using XML tools, then converted back to In  Design.
- An In  Design document can be exported to an IDML format file, which can be opened and saved in previous version of In  Design.

When converting between formats, it is not necessary to maintain binary equivalence. We only need to guarantee a high percentage of visual fidelity.

## 7.3 Maximize Independence of XML Elements

In  Design objects represented as XML elements in IDML are intended to be independent whenever possible. For example, to add, change, or delete a rectangle, you should be able to manipulate the rectangle element in a specific spread file. Other object types are more complicated, however. A TextFrame element, for example, must include a reference to the story containing the text shown in the TextFrame. The story itself, including all text formatting attributes, is in a separate file inside the IDML package.

## 7.4 Use Attributes Rather Than Elements

Wherever possible, IDML uses XML attributes, rather than XML elements, for storing most object properties. XML attributes are more compact, and offer performance advantages over XML elements (XML attributes are parsed along with the opening of the element which contains them, rather than as child XML elements).

## 7.5 Self-Documenting

The structure of IDML should be as self-documenting as possible. While the parent-child relationships of the elements do not need to reflect the object relationship in the In  Design binary object model, they generally reflect the In  Design scripting model.

Object and properties from the scripting model are represented in IDML as XML elements and attributes. The tag names of the elements and attributes are the 'long name' identifiers for the objects and properties defined in the scripting DOM.

## 7.6 Not a Literal Representation of In  Design Data Structures

IDML is not intended to represent the internal data structure of In  Design, nor is it intended as a replacement for the In  Design SDK. The In  Design API and binary file format will continue to evolve, and plug-in developers will continue to use the existing interfaces. By using the scripting DOM, IDML is insulated from changes to the In  Design API and low level changes to the file system.

## 7.7 Performance

IDML is designed with performance in mind. There are several design decisions that should result in performance improvement of IDML export and import:

- Object information is organized to optimize for import/export.
- At the C++ coding level, IDML core processing code and specific script providers have been tuned for better performance.
- IDML documents have been split into functional components, which will give us the ability to take advantage of multi-tasking during export in a future version.

## 7.8 Support for Previous Versions

It must be possible to open an IDML in the previous version of In  Design (for example opening an IDML file from In  Design CS5 in In  Design CS4). Since IDML is being introduced in In  Design CS4, it is not possible for IDML files from In  Design CS4 to be opened in In  Design CS3 or earlier. Instead, In  Design CS4 will be able to export to INX, which will be able to be opened in earlier versions of In  Design.

When a user opens an IDML file from an incompatible (due to plug-in configuration) version of In  Design/In  Copy, the application will display an error message. The user can choose to attempt to open the IDML file.
