# 5 Uses for IDML

IDML provides a way for InDesign layouts to interoperate with XML based formats and technologies. Documents can be created and manipulated in IDML format and can then be opened and interpreted using InDesign.

We've designed IDML to make it a key part of automated workflows. Using IDML, you can:

- Generate or modify IDML documents or document elements using data from databases or other data sources (programmatic assembly).
- Reuse parts of IDML documents, or break a document into components that can be used in a development environment (programmatic disassembly).
- Transform document elements using XSLT.
- Find data in In  Design documents using XPath or XQuery.
- Use source control to manage creative content, or to compare two versions of a design.

IDML is intended for consumption by In  Design-family applications, including In  Design, In  Copy, and In  Design Server. IDML is not intended as an interchange format for use with applications outside the In  Design family of products, and does not attempt to write or structure In  Design content in a manner that is compatible with other XML layout formats (such as Mars, XSL-FO, or SVG). It is, however, possible to transform IDML content into these formats by applying XSLT transformations to the IDML structures. Writing such a transformation is a very large task, and is beyond the scope of this specification.
