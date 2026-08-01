# 2 Introduction

IDML is an XML-based format that is capable of fully describing an In  Design document, and is the interchange format for Adobe In  Design CS4 documents. By using an XML representation of text and graphic frames, stories, and other aspects of an In  Design layout, IDML gives you a way to create and modify In  Design documents using tools outside the In  Design application.

Like its precursor INX, IDML is a Document Object Model (DOM) representation of In  Design documents, and is based on the In  Design scripting object model. INX stands for 'In  Design Interchange' and was introduced in In  Design CS2 to support the ability to save documents for use in a previous version. INX will continue to be used for backward compatibility for In  Design versions prior to In  Design CS4; IDML will be used for backward compatibility between In  Design CS4 and future versions.

It was quite difficult to write or edit the INX format, as it was designed to be written and consumed by In  Design alone. IDML addresses requests by third party developers and system integrators to make INX more readable and to make it easier to change and assemble In  Design documents using XML tools. By using IDML, you can realize gains in performance, convenience, and flexibility.

IDML is also like INX in that In  Design uses the format for a variety of other purposes, such as library items, In  Design snippets (standalone document fragments saved using IDML markup), and In  Copy assignments and stories.

It is important to note that while IDML is an XML format, you do not necessarily need to make use of In  Design's XML features in an IDML document. In fact, we expect that some users will prefer to keep all XML processing outside of In  Design for a variety of reasons, including performance and the limitations of the implementation of XML in In  Design.
