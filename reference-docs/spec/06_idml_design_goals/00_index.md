# 6 IDML Design Goals

The primary design goals of IDML are as follows:

- Completeness: Any object, property, or preference that can appear in an In  Design document can be represented in IDML. Complete 'round trip' compatibility is expected of IDML files.
- Readability: The IDML format is human-readable, and should be easily understood by a user with basic knowledge of the page layout. Representations of In  Design elements-spreads, TextFrames, stories, and colors, for example-are found inside the XML structure in the same location as they appear in a document. A TextFrame inside a group, for example, appears inside the group element, which, in turn is inside a spread element.
- For ease of programmatic assembly and disassembly, IDML is designed to be read and written by virtually any program or tool capable of reading and writing XML. Relative to INX, IDML files are easier to process using external tools, while maintaining the same full coverage of the In  Design object model.
- Robustness: The In  Design mechanisms for reading and interpreting IDML will be robust in the face of mistakes and eliminate fatal consequences. A Relax NG schema definition for

IDML will be provided for validation to help customers and workflow developers discover potential errors in their programmatically assembled or edited files. Since even validated files can contain unknown objects, errors will be reported during the interpretation process to assist in debugging.

- Backward compatibility: A user will be able to take an IDML file generated for version X and open it in version X-1 (provided X-1 supports IDML). In  Design CS4 is the first version to provide IDML support. In  Design CS4 will support the INX format for compatibility with InDesign CS3.
- Performance: IDML aims to maintain or exceed the performance of INX in In  Design CS4.
- Improvements over INX: IDML offers the following advantages over INX (this is not an exhaustive list):
- Provides a published format specification.
- Avoids  obscure  element  and  attribute  ordering,  relationships,  and  processing  constraints contained in the In  Design export/import code.
- Provides an XML schema (Relax NG) for validation.
- Eliminates the use of processing instructions in text content for text object placement
