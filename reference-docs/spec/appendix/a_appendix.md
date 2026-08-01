## Appendix A. UCF Container Format

## 1.1 Overview

## 1.1.1 Purpose and Scope

This appendix defines the Universal Container Format. UCF is a general-purpose container technology. It is based on the packaging principles of OCF, the OEBSP Container Format, created by the International Digital Publishing Forum. The OCF specification describes a generalpurpose container technology in the context of encapsulating OEBPS publications. While the OCF specification anticipates that the general-purpose container technology it describes will ultimately be used in other bundling applications, the specification itself does not formally separate the generic technology from its use in the context of OEBPS. This goal of this appendix is to do just that, specifying a generic container format that can be used by many applications, where OCF itself is one application.

As a general container format, UCF collects a related set of files into a single-file container. UCF can be used to collect files in various document and data formats and for classes of applications. The single-file container enables easy transport of, management of, and random access to, the collection.

UCF defines rules for how to represent an abstract collection of files (the 'abstract container') into physical representation within a Zip archive (the 'physical container'). The rules for Zip containers build upon and are backward compatible with the Zip technology used by Open Document Format (ODF) 1.0.

UCF is the RECOMMENDED single-file container technology for all Zip-based Adobe formats. It is designed to provide a set of lightweight constraints on the use of Zip. It includes a set of optional features including digital signatures and encryption. If an UCF-based file format includes this optional functionality, it should follow the UCF specifications for use of these features. For example, not all UCF-based formats will make use of digital signatures. However, if a format does include support for signatures, it should follow the UCF rules for signatures.

This appendix borrows heavily from both the UCF specification and the OCF specification. Where possible, the same language is used with the permission of the IDPF. Adobe and IDPF plan to work with OASIS to develop an open standard container format based on OCF (and most likely called Open Container Format) that will be the basis for future versions of OCF and the Open Document Format.

## 1.1.2 Definitions

## ASCII

American Standard Code for Information Interchange - a 7-bit character encoding based on the English alphabet (ANSI X3.4-1986). When used in this document, ASCII refers to the printable

graphic characters in the range 33 (decimal) through 126 (decimal) and the nonprintable space character 32 (decimal).

## IDML

An XML representation of an InDesign document.

## IRI

Internationalized Resource Identifier (http://www.ietf.org/rfc/rfc3987.txt).

## UCF

The Universal Container Format defined by this specification.

## UCF Container

A container file that is compliant with the format defined in this specification.

## UCF User Agent

A combination of hardware and/or software that accepts documents or data packaged in an UCF Container and makes them available to consumer of the content.

## ODF

Open Document Format (http://www.oasis-open.org/committees/download.php/12572/ OpenDocument-v1.0-os.pdf).

## OEBPS

Open eBook Publication Structure (http://www.idpf.org/oebps/oebps1.2/index.htm).

## MIME

Multipurpose Internet Mail Extensions (http://www.ietf.org/rfc/rfc2045.txt). 'MIME media types' provide a standard methodology for specifying the content type of objects.

## RFC

Literally 'Request For Comments,' but more generally a document published by the Internet Engineering Task Force (IETF). See http://www.ietf.org/rfc.html.

396  Appendix A. UCF Container Format: Overview

## Relax NG

A schema language for XML (http://www.relaxng.org/).

## Rootfile

The top-level file of a rendition of a publication; either the 'root' from which all other components can be found or the lone file encapsulating the rendition. The OEBPS rootfile is the OEBPS Package file. A PDF file containing the PDF rendition could also be a rootfile.

## XML

Extensible Markup Language (http://www.w3.org/TR/xml/).

## Zip

A de facto industry standard bundling and compression format (http://www.pkware.com/ support/zip-application-note).

## 1.1.3 Relationship of UCF to Other Specifications

UCF combines subsets and applications of other specifications. Together, these facilitate the construction, organization, presentation, and unambiguous interchange of electronic documents:

The OEBPS Container Format specification (http://www.idpf.org/ocf/ocf1.0/).

Zip format (http://www.pkware.com/support/zip-application-note)

The Extensible Markup Language (XML) 1.0 (Fourth Edition) specification (http://www.w3.org/ TR/xml/)

The Namespaces in XML 1.0 (Second Edition) specification ( http://www.w3.org/TR/xml-names/)

XML-Signature Syntax and Processing (http://www.w3.org/TR/2002/REC-xmldsigcore-20020212)

XML Encryption Syntax and Processing (http://www.w3.org/TR/2002/REC-xmlenccore-20021210)

Extensible Metadata Platform (XMP) (http://www.adobe.com/products/xmp/)

The Unicode Consortium. The Unicode Standard, Version 5.0.0, defined by: The Unicode Standard, Version 5.0 (Boston, MA, Addison-Wesley, 2007. ISBN 0-321-48091-0), as updated from time to time by the publication of new versions. (See http://www.unicode.org/unicode/standard/ versions for the latest version and additional information on versions of the standard and of the Unicode Character Database).

Particular MIME media types (http://www.ietf.org/rfc/rfc4288.txt and http://www.iana.org/ assignments/media-types/index.html)

Open Document Format for Office Applications (Open Document) v1.0 (http://www.oasis-open. org/committees/download.php/12572/OpenDocument-v1.0-os.pdf)

## 1.2 Conformance

The keywords 'MUST', 'MUST NOT', 'REQUIRED', 'SHALL', 'SHALL NOT', 'SHOULD', 'RECOMMENDED', 'MAY', and 'OPTIONAL' in this document MUST be interpreted as described in (http://www.ietf.org/rfc/rfc2119.txt).

This section defines conformance requirements for UCF.

## 1.2.1 Conforming Containers

The term 'Conforming UCF Abstract Container' indicates an UCF Abstract Container (See Section 2.2) that conforms to all the relevant conformance criteria defined in this specification. The term 'Conforming UCF Zip Container' indicates a Zip archive that conforms to the relevant Zip container conformance criteria (See Section 4) and which implements an instance of a Conforming UCF Abstract Container.

In addition to other conformance criteria defined in this specification, a Conforming UCF Abstract Container MUST meet the following conditions:

- All XML files defined by this specification MUST be well-formed (as defined in XML 1.0).
- All XML defined by this specification files MUST be compatible with the XML 1.0 specification (http://www.w3.org/TR/2006/REC-xml-20060816) and the Namespaces in XML specification (http://www.w3.org/TR/REC-xml-names).
- These conditions do not apply to files in the container that are not defined by this specification (files other than container.xml, manifest.xml, metadata.xml, signatures.xml, encryption.xml, and rights.xml).

## 1.2.2 Conforming User Agents

The term 'Conforming UCF User Agent' indicates an UCF User Agent that supports all of the mandatory features defined by this specification.

An UCF User Agent that does not support all of the features defined in this specification MUST NOT claim to be a Conforming UCF User Agent and SHOULD provide readily available documentation of the subset of features it supports.

## 1.2.3 Future Directions

It is the intent of the contributors to this specification that subsequent versions of this specification continue in the directions established by the 1.0 release. Specifically:

- Future versions of this specification are expected to improve alignment with OASIS/ODF and IDPF/OCF.
- Any required functionality not present in relevant official standards shall be defined in a manner consistent with its eventual submission to an appropriate standards body as extensions to existing standards.

## 1.3 UCF Overview

## 1.3.1 UCF: A General Container Technology

UCF is designed as a general container technology. In particular, UCF is designed to be upwardly compatible with the container technology used in ODF 1.0 such that a future version of ODF might use UCF.

## 1.3.2 'Abstract Container' vs. 'Physical Container'

An 'Abstract Container' defines a file system model for the contents of the container. The file system model MUST have a single common root directory for all of the contents of the container. The special files REQUIRED by UCF MUST be included within the META-INF directory that is a direct child of the root directory.

A 'Physical Container' holds the physical manifestation of an abstract container. UCF defines how an abstract container MUST be mapped to the following two physical container technologies:

- File System Container The mapping of an Abstract Container to a file system within computer storage media on a specific platform (e.g., a hard disk on a computer or a data CD) MUST be a one-to-one mapping where each directory and file within the abstract container is represented as a directory or file within the file system. Section 3.3 defines a set of restrictions on file system names intended to allow files to be easily stored in most modern file systems.
- Zip Container The mapping of an Abstract Container to a Zip archive is defined in Section 4.

If a user agent processed both types of physical container, the contents of an OCF container MUST be processed the same no matter whether using a File System Container or a Zip Container. In both cases, the UCF User Agent ultimately opens the rootfile, from which it can determine how to process the container.

## 1.4 UCF Container Contents

## 1.4.1 File and directory structure

The virtual file system for the UCF 'Abstract Container' MUST have a single common root directory for all of the contents of the container.

The following file names in the root directory are reserved:

- 'mimetype'
- 'META-INF'

The 'mimetype' file is discussed in Section 4. The META-INF/ directory contains the reserved files used by UCF. These reserved files are described in the following sections. All other files within the Abstract Container MAY be in any location descendant from the root directory except for 'mimetype' at the root level or directly within the META-INF directory. An UCF based-format may include files in the META-INF directory as long as these files are within subdirectories in META-INF. The names of these subdirectories MUST NOT include the '.' character. This avoids conflicts with files specified by future versions of the UCF specification. Any file in the META-INF directory used by UCF will include a '.' character.

It is RECOMMENDED that the contents of individual documents or applications be stored within dedicated sub-directories to minimize potential file name collisions in the event that multiple renditions are used or that multiple publications per container are supported in future versions UCF.

## 1.4.2 Relative IRIs for referring to other components

Files within the Abstract Container refer to each other via Relative IRI References (http://www. ietf.org/rfc/rfc3987.txt and http://www.ietf.org/rfc/rfc3986.txt), no matter what is used for the physical container (e.g., File System Container or Zip Container). For example, if a file named 'chapter1.html' refers to an image file named 'image1.jpg' that is located in the same directory, then 'chapter1.html' might contain the following as part of its content:

```
<img src="image1.jpg" alt="…" …/>
```

For Relative IRI References, the Base IRI (see RFC3986) is determined by the relevant language specifications for the given file formats. For example, the CSS specification defines how relative IRI references work in the context of CSS style sheets and property declarations.

Unlike many language specifications, the Base IRIs for all files within the META-INF/ directory use the root folder for the Abstract Container as the default Base IRI. For example, if META-INF/ container.xml has the following content:

```
<?xml version="1.0"?> <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container"> <rootfiles> <rootfile full­path="OEBPS/Great Expectations.opf" media­type="application/oebps­package+xml" /> </rootfiles> </container>
```

the path 'OEBPS/Great Expectations.opf' is relative to the root directory for the Abstract Container and not relative to the META-INF/ directory.

If a Relative IRI Reference contains an absolute path (an IRI that has no schema or authority but begins with a '/'), the reference is resolved relative to the root directory of the Abstract Container. For example, in the example in Section 2.3.1, the IRI '/OEBPS/cover.html' will refer to the file OEBPS/cover.html no matter what file the IRI is found in.

## 1.4.3 File Names

The term File Name represents the name of any type of file, either a directory or an ordinary file within a directory within an Abstract Container. For a given directory within the Abstract Container, the Path Name is a string holding all directory names in the full path concatenated together with a '/' character separating the directory names. For a given file within the Abstract Container, the Path Name is the string holding all directory names concatenated together with a '/' character separating the directory names, followed by a '/' character and then the name of the file. The File Name restrictions described below are designed to allow directory names and file names to be used without modification on most commonly used operating systems. The UCF specification does not specify how a UCF User Agent that is unable to represent UCF conforming File Names would compensate for this incompatibility.

The following statements apply to Conforming UCF Content:

- File Names MUST be UTF-8 encoded with the restrictions below
- When represented as UTF-8, File Names MUST NOT exceed 255 bytes
- When represented as UTF-8, the Path Name for any directory or file within the Abstract Container MUST NOT exceed 65535 bytes
- File Names MUST NOT use the following characters (These characters are not be supported always across commonly used operating systems):
- U+0022 ' QUOTATION MARK
- U+002A * ASTERISK
- U+002E . FULL STOP, as the last character
- U+002F / SOLIDUS
- U+003A : COLON
- U+003C < LESS-THAN SIGN
- U+003E > GREATER-THAN SIGN
- U+003F ? QUESTION MARK
- U+005C \ REVERSE SOLIDUS
- The C0 controls, U+0000 through U+001F and U+007F
- File Names are case sensitive.
- Two File Names within the same directory MUST NOT map to the same string following case normalization (http://www.unicode.org/reports/tr21/tr21-5.html). Two File Names that differ only in case are disallowed within the same directory.
- Two File Names within the same directory MUST NOT be canonically equivalent in the Unicode sense.

Note that some commercial Zip tools do not support the full Unicode range and may only support the ASCII range for File Names. Content creators who want to use Zip tools that have these restrictions MAY find it is best to restrict their File Names to the ASCII range. If the names of files can not be preserved during the unzipping process, it will be necessary to compensate for any name translation which took place when the files are referred to by URI from within the content.

## 1.4.4 Container media type identification

It is frequently necessary for applications to determine the media type of a file. This is usually accomplished by looking at the file extension of the file. This gives applications a quick way to determine the type of the file without looking inside the file. UCF Container files SHOULD use an extension specific to the kind of UCF Container it is.

Unfortunately, the identification of files through the use of file extensions is notoriously unreliable. As a result, it is desirable to have a more robust way of identifying files independent of their file names or extensions. One mechanism that has evolved for doing this is to require the placement of specific information at specific file offsets. A processing agent can then check a fixed location to determine if the file is a specific type of UCF Container.

The method that has evolved for doing this in Zip archives is the inclusion of an uncompressed, unencrypted file called 'mimetype' as the first file in the Zip archive. The contents of this file are the media type of the file. UCF Containers MUST place the media type as an ASCII string in the 'mimetype' file as the first file in the Zip archive. See Section 4 for more detail on this mechanism.

## 1.4.5 META-INF

All valid UCF Containers MAY include a directory called 'META-INF' at the root level of the container file system. This directory contains the files specified below that describe the contents, metadata, signatures, encryption, rights and other information about the contained publication.

The semantics of the following files that MAY be present at the 'META-INF/' level are specified. All other files found at the 'META-INF/' level MUST be ignored by conformant UCF User Agents.

## 1.4.6 Container - META-INF/container.xml (Optional)

(This  is normative.)

An UCF Container MAY include a file called 'container.xml' within the 'META-INF' directory at the root level of the container file system. If present, the container.xml file MAY identify the MIME type of, and path to, the rootfile for the container and any OPTIONAL alternate renditions included within the container. An UCF-based format MUST either require container.xml to identify the rootfile or specify a format-specific method for initiating processing of the container. The container.xml file MAY specify implicit relationships in the container, as described in Section 3.5.1.2.

The container.xml file MUST NOT be encrypted.

The container.xml file contains XML that uses the 'urn:oasis:names:tc:opendocument:xmlns:co ntainer' namespace for all of its elements and attributes. The 'version='1.0'' attribute MUST be included for all containers that conform to this version of the specification.

A RELAX NG UCF schema describing the <container> element that MUST be the root element of container.xml can be found in the Appendix A.

## Rootfiles (Optional)

The <rootfiles> element MUST contain at least one <rootfile> element.

Each <rootfile> element specifies the rootfile of a single rendition of the contained publication. A rootfile often includes an enumeration of the other files needed by the rendition.

The values of the full-path attributes MUST contain a 'path component' (as defined by RFC3986) which MUST only take the form of a 'path-rootless' (as defined by RFC3986). The path components are relative to the root of the container in which they are used.

Conforming UCF User Agents MUST ignore unrecognized elements (and their contents) and unrecognized attributes within a container.xml file, including unrecognized elements and unrecognized attributes from other namespaces.

Conforming container.xml files MUST be valid according to the RELAX NG UCF schema with the <container> element as the root element after removing all elements (and child nodes of these elements) and attributes from other namespaces.

## Relationships (Optional)

Container.xml MAY include information that identifies implicit rela  tionships between files in a container. Usually, one file explicitly referrs to an  other file. For example, an SVG page description may reference an image. At times, it is convenient to indirectly reference a file. For example, one file may have metadata associated with it stored in a second file. Using an indirect associ  ation makes it possible to add metadata by simply creating a metadata resource and not changing the original resource or, in fact, any resource in the package.

Beyond convenience, indirect associations enable container files to be digitally signed while still permitting the addition of certain kinds of data such as metada  ta or annotations. For example, a document with no annotations can be signed. Annotations can then be added without invalidating the signature.

UCF provides a generic mechanism for establishing a relationship between two container files. A relationship specifies a relationship type and a mapping from a set of source names to target names. For any given file, this relationship can be used to determine the related file. However, UCF does not require that the related file exist.

The root <con  tainer> element MAY contain a child <relationships> element. This element MAY contain one or more child <relationship> elements that describe specific relationships. Each relationship element includes attributes type and target that specify a relationship type and a pattern that maps source to target names. The type is a qualified name. UCF defines one relationship type, 'metadata.' UCF-based formats can add other types by specifying a namespace. The target pattern is a string that may include the following variables that are substituted when a relationship is resolved:

| Variable     | Definition                             | Example |
| ------------ | -------------------------------------- | ----------- |
| path         | the full path to the resource          | /a/b/c.d |
| dir          | the directory (without the filename)   | /a/b |
| filename     | the path without the directory         | c.d |
| basename     | the filename without the extension     | c |
| ext          | the filename extension                 | d |

These variables are specified by enclosing their name in braces and preceding the opening brace with a '$'. Braces may be omitted if the first character after the variable name is not a letter. A target is resolved by copying the ordinary text in the pattern and replacing the variables with their values.

Any file in the example container can have an associated metadata file with the same name as the source file followed by the '.xmp' extension.

## Manifest - META-INF/manifest.xml (Optional)

An OPTIONAL file with the reserved name 'manifest.xml' within the 'META-INF' directory at the root level of the container may appear in a valid UCF container. If present, the file's content MUST be as defined in the ODF 1.0 manifest schema (http://www.oasis-open.org/committees/ download.php/12570/OpenDocument-manifest-schema-v1.0-os.rng).

The manifest.xml file, if present, MUST NOT be encrypted.

## Metadata - META-INF/metadata.xml (Optional)

A file with the reserved name 'metadata.xml' within the 'META-INF' directory at the root level of the container file system may appear in a valid UCF container. This file, if present, MUST be used for container-level metadata. In version 1.0 of OCF, no such container-level metadata is specified.

If the 'META-INF/metadata.xml' file exists, its contents MUST be valid XML with namespacequalified elements to avoid collision with future versions of OCF that MAY specify a particular grammar and namespace for elements and attributes within this file.

Adobe-defined formats based on UCF MUST use XMP to specify metadata (http://www.adobe. com/products/xmp/).

## Digital Signatures - META-INF/signatures.xml (Optional)

An OPTIONAL 'signatures.xml' file within the 'META-INF' directory at the root level of the container file system holds digital signatures of the container and its contents. The contents of this file is not specified in UCF 1.0. However, a future revision of UCF will define the format for this file. See Appendix D for the likely definition.

## Encryption - META-INF/encryption.xml (Optional)

An OPTIONAL 'encryption.xml' file within the 'META-INF' directory at the root level of the container file system holds all encryption information on the contents of the container. The contents of this file is not specified in UCF 1.0. However, a future revision of UCF will define the format for this file. See Appendix E for the likely definition.

## Rights Management - META-INF/rights.xml (Optional)

An OPTIONAL file with the name 'rights.xml' within the 'META-INF' directory at the root level of the container file system is a reserved name in a valid UCF container. This location is reserved for digital rights management (DRM) information for trusted exchange of Publications among rights holders, intermediaries, and users. In version 1.0 of UCF, there is not a REQUIRED format for DRM information, but a future version of the UCF specification MAY specify a particular format for DRM information.

If the 'META-INF/rights.xml' file exists, it MUST be a well-formed XML document which uses and conforms to XML Namespaces it uses, and its contents SHOULD be valid XML with namespace-qualified elements to avoid collision with future versions of UCF that MAY specify a particular format this file.

The rights.xml file MUST NOT be encrypted.

When the rights.xml file is not present, the UCF container provides no information indicating any part of the container is rights governed.

## 1.5 Zip Container

UCF's Zip Container supports the Zip format as specified by the application note at http://www. pkware.com/support/zip-application-note, but with the following constraints and clarifications:

Conforming UCF Zip Containers MUST NOT use the features in the Zip application note that allow Zip files to be split across multiple storage media. Conforming UCF User Agents MUST treat any UCF files that specify that the Zip file is split across multiple storage media as being in error.

Conforming UCF Zip Containers MUST only include uncompressed files or Flate-compressed files within the Zip archive. Conforming UCF User Agents MUST treat any UCF Containers that use compression techniques other than Flate as being in error.

Conforming UCF Zip Containers MAY use the Zip64 extensions and SHOULD only use those extensions when the content requires them. Conforming UCF User Agents MUST support the Zip64 extensions.

Conforming UCF Zip Containers MUST NOT use the encryption features defined by the Zip format; instead, encryption MUST be done using the features described in Section 3.5.5. Conforming UCF User Agents MUST treat any other UCF Zip Containers that use Zip encryption features as being in error.

It is not a requirement that Conforming UCF User Agents preserve information from an UCF Zip Container through load and save operations that do not map to corresponding representation within the UCF Abstract Container; in particular, a Conforming UCF User Agent does not have to preserve CRC values, comment fields or fields that hold file system information corresponding to a particular operating system (e.g., 'External file attributes' and 'Extra field')

Conforming UCF Zip Containers MUST encode File System Names using UTF-8.

Here are some details about particular fields in the Zip archive:

On the local file header table, Conforming UCF Zip Containers MUST set the 'version needed to extract' fields to the values 10, 20 or 45 in order to match the maximum version level needed by the given file (e.g., 20 if Deflate is needed, 45 if Zip64 is needed). Conforming UCF User Agents MUST treat any other values as being in error.

On the local file header table, Conforming UCF Zip Containers MUST set the 'compression' method field to the values 0 or 8. Conforming UCF User Agents MUST treat any other values as being in error.

Conforming UCF User Agents MUST treat UCF Zip Containers with an 'Archive decryption header' or an 'Archive extra data record' as being in error.

The first file in the Zip Container MUST be a file by the ASCII name of 'mimetype' which holds the MIME type for the Zip Container (i.e., 'application/epub+zip' as an ASCII string; no padding, white-space or case change). The file MUST be neither compressed nor encrypted and there MUST NOT be an extra field in its Zip header. If this is done, then the Zip Container offers convenient 'magic number' support as described in RFC 2048 and the following will hold true:

The bytes 'PK' will be at the beginning of the file

The bytes 'mimetype' will be at position 30

The actual MIME type (i.e., the ASCII string 'application/epub+zip') will begin at position 38

## 1.6 RELAX NG UCF Schema

```
<?xml version="1.0" encoding="UTF­8"?> <choice xmlns="http://relaxng.org/ns/structure/1.0"> <element name="container"> <attribute name="version"> <value>1.0</value> </attribute> <attribute name="xmlns"> <value>urn:oasis:names:tc:opendocument:xmlns:container </value> </attribute> <optional> <element name="rootfiles"> <oneOrMore> <element name="rootfile"> <attribute name="full­path">
```

```
<text/> </attribute> <attribute name="media­type"> <text/> </attribute> </element> </oneOrMore> </element> </optional> <optional> <element name="relationships"> <oneOrMore> <element name="relationship"> <attribute name="type"> <text/> </attribute> <attribute name="target"> <text/> </attribute> </element> </oneOrMore> </element> </optional> </element> <element name="signatures"> <attribute name="xmlns"> <value>urn:oasis:names:tc:opendocument:xmlns:container</ value> </attribute> <oneOrMore> <element name="Signature" ns="http://www.w3.org/2001/04/xmldsig#"> <externalRef href="http://www.w3.org/Signature/2002/07/xmldsig­core­schema.rng"/> </element> </oneOrMore> </element> <element name="encryption"> <attribute name="xmlns"> <value>urn:oasis:names:tc:opendocument:xmlns:container</ value> </attribute> <oneOrMore> <choice> <element name="EncryptedData" ns="http://www.w3.org/2001/04/xmlenc#"> <externalRef href="http://www.w3.org/Encryption/2002/07/xenc­schema.rng"/> </element> <element name="EncryptedKey" ns="http://www.w3.org/2001/04/xmlenc#"> <externalRef href="http://www.w3.org/Encryption/2002/07/xenc­schema.rng"/>
```

```
</element> </choice> </oneOrMore> </element> </choice> The following example demonstrates the use of this UCF format to contain a signed and encrypted OEBPS publication with an alternate PDF rendition within a Zip Container. Ordered list of files in the Zip Container: mimetype META­INF/container.xml META­INF/signatures.xml META­INF/encryption.xml OEBPS/As You Like It.opf OEBPS/book.html OEBPS/images/cover.png PDF/As You Like It.pdf The mimetype file: application/epub+zip The META-INF/container.xml file: <?xml version="1.0"?> <container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container"> <rootfiles> <rootfile full­path="OEBPS/As You Like It.opf" media­type="application/oebps­package+xml" /> <rootfile full­path="OEBPS/As You Like It.pdf" media­type="application/pdf" /> </rootfiles> </container> The META-INF/signatures.xml file: <?xml version="1.0"?> <signatures xmlns="urn:oasis:names:tc:opendocument:xmlns:container"> <Signature Id="AsYouLikeItSignature" xmlns="http://www.w3.org/2000/09/xmldsig#"> <!­­ SignedInfo is the information that is actually signed. In this case ­­> <!­­ the SHA1 algorithm is used to sign the canonical form of the XML    ­­> <!­­ documents enumerated in the Object element below                    ­­> <SignedInfo> <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC­xml­c14n­20010315"/> <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#dsa­sha1"/> <Reference URI="#AsYouLikeIt"> <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/> <DigestValue>j6lwx3rvEPO0vKtMup4NbeVu8nk=</DigestValue> </Reference> </SignedInfo>
```

```
<!­­ The signed value of the digest above using the DSA algorithm ­­> <SignatureValue>MC0CFFrVLtRlk=...</SignatureValue> <!­­ The key to use to validate the signature ­­> <KeyInfo> <KeyValue> <DSAKeyValue> <P>...</P><Q>...</Q><G>...</G><Y>...</Y> </DSAKeyValue> </KeyValue> </KeyInfo> <!­­ documents is signed while the binary form of the other documents ­­> <!­­ is used ­­> <Object> <Manifest Id="AsYouLikeIt"> <Reference URI="OEBPS/As You Like It.opf"> <Transforms> <Transform Algorithm="http://www.w3.org/TR/2001/REC­xml­ c14n­20010315"/> </Transforms> </Reference> <Reference URI="OEBPS/book.html"> <Transforms> <Transform Algorithm="http://www.w3.org/TR/2001/REC­xml­ c14n­20010315"/> </Transforms> </Reference> <Reference URI="OEBPS/images/cover.png" /> <Reference URI="PDF/As You Like It.pdf" /> </Manifest> </Object> </Signature>
```

```
<!­­ The list documents to sign. Note that the canonical form of XML   ­­> </signatures> The META-INF/encryption.xml file: <?xml version="1.0"?> <encryption xmlns="urn:oasis:names:tc:opendocument:xmlns:container" xmlns:enc="http://www.w3.org/2001/04/xmlenc#" xmlns:ds="http://www.w3.org/2000/09/xmldsig#"> <­­ The RSA encrypted AES­128 symmetric key used to encrypt the data ­­> <enc:EncryptedKey Id="EK"> <enc:EncryptionMethod  Algorithm="http://www.w3.org/2001/04/xmlenc#rsa­1_5"/> <ds:KeyInfo> <ds:KeyName>John Smith</ds:KeyName> </ds:KeyInfo> <enc:CipherData> <enc:CipherValue>xyzabc...</enc:CipherValue>
```

```
</enc:CipherData> </enc:EncryptedKey> <!­­ Each EncryptedData block identifies a single document that has been    ­­> <!­­ encrypted using the AES­128 algorithm. The data remains stored in it's ­­> <!­­ encrypted form in the original file within the container.             ­­> <enc:EncryptedData Id="ED1"> <enc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#kw­aes128"/> <ds:KeyInfo> <ds:RetrievalMethod URI="#EK" Type="http://www.w3.org/2001/04/xmlenc#EncryptedKey"/> </ds:KeyInfo> <enc:CipherData> <enc:CipherReference URI="OEBPS/book.html"/> </enc:CipherData> </enc:EncryptedData> <enc:EncryptedData Id="ED2"> <enc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#kw­aes128"/> <ds:KeyInfo> <ds:RetrievalMethod URI="#EK" Type="http://www.w3.org/2001/04/xmlenc#EncryptedKey"/> </ds:KeyInfo> <enc:CipherData> <enc:CipherReference URI="OEBPS/images/cover.png"/> </enc:CipherData> </enc:EncryptedData> <enc:EncryptedData Id="ED3"> <enc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#kw­aes128"/> <enc:KeyInfo> <enc:RetrievalMethod URI="#EK" Type="http://www.w3.org/2001/04/xmlenc#EncryptedKey"/> </enc:KeyInfo> <enc:CipherData> <enc:CipherReference URI="PDF/As You Like It.pdf"/> </enc:CipherData> </enc:EncryptedData> </encryption> The OEBPS/As You Like It.opf file: <?xml version="1.0"?> <!DOCTYPE package PUBLIC "+//ISBN 0­9673008­1­9//DTD OEB 1.2 Package//EN" "http://openebook.org/dtds/oeb­1.2/oebpkg12.dtd"> <package unique­identifier="Package­ID"> <metadata> <dc­metadata xmlns:dc="http://purl.org/dc/elements/1.0" xmlns:oebpackage="http://openebook.org/namespaces/oeb­ package/1.0"> <dc:Identifier id="Package­ID">ebook:guid­6B2DF0030656ED9D8</dc:Identifier> <dc:Title>As You Like It</dc:Title> <dc:Creator role="aut">William Shakespeare</dc:Creator>
```

```
<dc:Identifier>0­7410­1455­6</dc:Identifier> <dc:Subject></dc:Subject> <dc:Type></dc:Type> <dc:Date event="publication">3/24/2000</dc:Date> <dc:Date event="copyright">1/1/9999</dc:Date> <dc:Identifier scheme="ISBN">0­7410­1455­6</dc:Identifier> <dc:Publisher>Project Gutenberg</dc:Publisher> <dc:Language></dc:Language> </dc­metadata> </metadata> <manifest> <item id="7184" href="images/cover.png" media­type="image/png" /> </manifest> <spine> <itemref idref="4915"/> </spine>
```

```
<item id="4915" href="book.html" media­type="text/x­oeb1­document"/> </package> The OEBPS/book.html file: This file would be binary and be encrypted. Its decrypted contents might look something like: <?xml version="1.0" ?> <!DOCTYPE html PUBLIC "+//ISBN 0­9673008­1­9//DTD OEB 1.2 Document//EN" "http://openebook.org/dtds/oeb­1.2/oebdoc12.dtd"> <html> <head> ... </head> <body> ... <img src="images/cover.png" alt="Cover image: a picture of the Bard of Avon" /> ... </body> </html> The OEBPS/images/cover.png file: This file contains the encrypted binary bytes of the cover.png file. The OEBPS/As You Like It.pdf file: This file contains the encrypted binary bytes of the PDF file.
```

## 1.7 Comparison of UCF and OCF

As described in the introduction, UCF is OCF without the OEBPS dependencies. There are only a few significant differences:

The OCF specification states that the media type of the container must be application/epub+zip, while UCF specifies that UCF-based formats should choose an appropriate media type. OCF implicitly encourages the use of '+zip' to identify Zip-based formats.

OCF requires all XML documents in a container to be compatible with XML 1.1. UCF requires all XML documents to be compatible with XML 1.0. (The use of XML 1.0 follows generally recommended practice to use XML 1.0 rather than XML 1.1 unless XML 1.1 features are required.)

OCF forbids certain characters in names. In addition to those characters, UCF also disallows characters corresponding to the non-printing ASCII codes. While the OCF specifications lists forbidden characters by ASCII names, the UCF specification lists Unicode code points.

OCF requires that two file names in a container be unique after case normalization. UCF also requires that names be unique after character normalization using Unicode normalization form C (canonical decomposition followed by canonical composition).

OCF requires container.xml which in turn requires specification of a rootfile. UCF does not require container.xml. The rationale is that an UCF-based format can specify how to begin processing the container.

UCF adds file relationships, providing an application-independent method for storing and finding metadata associated with container files.

OCF specifies that the metadata.xml file must not be encrypted, while UCF allows this. Even when a publication is protected with encryption (usually to support digital rights management), the IDPF wants reading systems to be able to provide users with useful metadata. IDML (and possibly other UCF formats as well) has more general requirements and needs to leave this as an option for the container creator.

OCF encourages but does not require each publication (in UCF, generalized to document or application) to reside in its own directory within the container. This makes it easier to contain multiple renditions of the publication in the container.

The UCF specification has deferred the definition of encryption and digital signature features to a future revision. This will provide implementers more time to evaluate the proposed definition.

## 1.8 Digital Signatures

Support of digital signatures in UCF has been deferred until a future revision of the specification. However, it is likely that the specification of this feature will match the OCF specification, which follows:

An OPTIONAL 'signatures.xml' file within the 'META-INF' directory at the root level of the container file system holds digital signatures of the container and its contents. This file is an XML

document whose root element is <signatures>. The <signatures> element contains child elements of type <Signature> as defined by 'XML-Signature Syntax and Processing' (http://www.w3.org/ TR/2002/REC-xmldsig-core-20020212). Signatures can be applied to the publication and any alternate renditions as a whole or to parts of the publication and renditions. XML Signature can specify the signing of any kind of data, not just XML.

The signatusres.xml file MUST NOT be encrypted.

When the signatures.xml file is not present, the UCF container provides no information indicating any part of the container is digitally signed at the container level. It is however possible that digital signing exists within any optional alternate contained renditions.

A RELAX NG UCF schema describing the <signature> element that MUST be the root element of signatures.xml can be found in the Appendix A.

When an UCF agent creates a signature of data in a container, it SHOULD add the new signature as the last child <Signature> element of the <signatures> element in the signatures.xml file.

Each <Signature> in the signatures.xml file identifies by IRI the data to which the signature applies, using the XML Signature <Manifest> element and its <Reference> sub-elements. Individual contained files MAY be signed separately or together. Separately signing each file creates a digest value for the resource that can be validated independently. This approach MAY make a Signature element larger. If files are signed together, the set of signed files can be listed in a single XML Signature <Manifest> element and referred to by one or more <Signature> elements.

Any or all files in the container can be signed in their entirety with the exception of the signatures.xml file since that file will contain the computed signature information. Whether and how the signatures.xml file SHOULD be signed depends on the objective of the signer.

If the signer wants to allow signatures to be added or removed from the container without invalidating the signer's signature, the signatures.xml file SHOULD NOT be signed.

If the signer wants any addition or removal of a signature to invalidate the signer's signature, the Enveloped Signature transform (defined in Section 6.6.4 of XML Signa  ture) can be used to sign the entire preexisting signature file excluding the <Signature> being created. This transform would sign all previous signatures, and it would become invalid if a subsequent signature was added to the package.

If the signer wants the removal of an existing signature to invalidate the signer's signature but also wants to allow the addition of signatures, an XPath transform can be used to sign just the existing signatures. (This is only a suggestion. The particular XPath transform is not a part of UCF specification.)

XML-Signature does not associate any semantics with a signature, however an agent MAY include semantic information, for example, by adding information to the Signature element that describes the signature. XML Signature describes how additional information can be added to a signature (for example, by using the SignatureProperties element).

(This example is informative.)

The following XML expression shows the content of an example 'signatures.xml' file, and is based on the examples found in Section 2 of 'XML-Signature Syntax and Processing.' It contains one signature, and the signature applies to two resources, OEBFPS/book.html and OEBFPS/ images/cover.jpeg, in the container.

```
<signatures> <Signature Id="MyFirstSignature" xmlns="http://www.w3.org/2000/09/xmldsig#"> <SignedInfo> <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC­xml­c14n­20010315"/> <SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#dsa­sha1"/> <Reference URI="#Manifest1"> <DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1"/> <DigestValue>j6lwx3rvEPO0vKtMup4NbeVu8nk=</DigestValue> </Reference> </SignedInfo> <SignatureValue>MC0CFFrVLtRlk=...</SignatureValue> <KeyInfo> <KeyValue> <DSAKeyValue> <P>...</P><Q>...</Q><G>...</G><Y>...</Y> </DSAKeyValue> </KeyValue> </KeyInfo> <Object> <Manifest Id="Manifest1"> <Reference URI="OEBFPS/book.xml"> <Transforms> <Transform Algorithm="http://www.w3.org/TR/2001/REC­xml­c14n­20010315"/> </Transforms> </Reference> <Reference URI="OEBFPS/images/cover.jpeg"/> </Manifest> </Object> </Signature> </signatures>
```


## 1.9 Encryption

Support of encryption in UCF has been deferred until a future revision of the specification. With one exception, it is likely that the specification of this feature will match the OCF specification, which follows this paragraph. The exception is that it will be possible to specify that a particular algorithm does not require Flate compression of data before encryption.

An OPTIONAL 'encryption.xml' file within the 'META-INF' directory at the root level of the container file system holds all encryption information on the contents of the container. This file is an XML document whose root element is <encryption>. The <encryption> element contains child elements of type <EncryptedKey> and <EncryptedData> as defined by 'XML Encryption Syntax and Processing' (http://www.w3.org/TR/2002/REC-xmlenc-core-20021210). Each EncryptedKey element describes how one or more container files are encrypted. Consequently, if any resource within the container is encrypted, 'encryption.xml' MUST be present to indicate that the resource is encrypted and provide information on how it is encrypted.

An <EncryptedKey> element describes each encryption key used in the container, while an <EncryptedData> element describes each encrypted file. Each <EncryptedData> element refers to an <EncryptedKey> element, as described in XML Encryption.

A RELAX NG UCF schema describing the <encryption> element that MUST be the root element of encryption.xml can be found in the Appendix A.

When the encryption.xml file is not present, the UCF container provides no information indicating any part of the container is encrypted.

UCF encrypts individual files independently, trading off some security for improved performance, allowing the container contents to be incrementally decrypted. Encryption in this way still exposes the directory structure and file naming of the whole package.

UCF uses XML Encryption to provide a framework for encryption, allowing a variety of algorithms to be used. XML Encryption specifies a process for encrypting arbitrary data and representing the result in XML. Even though an UCF container MAY contain non-XML data, XML Encryption can be used to encrypt all data in an UCF container. UCF encryption sup  ports only encryption of whole files. The encryption.xml file, if present, MUST NOT be encrypted.

Encrypted data replaces unencrypted data in an UCF container. For example, if an image named 'photo.jpeg' is encrypted, the contents of the photo.jpeg resource SHOULD be replaced by its encrypted contents. When stored in a Zip container, files MUST be compressed before they are encrypted; Flate compression MUST be used. Within the Zip local file header and central directory, encrypted files SHOULD be listed as stored rather than Flate-compressed.

The following files MUST never be encrypted (regardless of whether default or specific encryption is requested):

- mimetype
- META-INF/container.xml
- META-INF/manifest.xml
- META-INF/metadata.xml
- META-INF/signatures.xml
- META-INF/encryption.xml
- META-INF/rights.xml

Signed resources MAY subsequently be encrypted by using the Decryption Transform for XML Signature. This feature enables an application such as an UCF agent to distinguish data that was encrypted before signing from data that was encrypted after signing. Only data that was encrypted after signing MUST be decrypted before computing the digest used to validate the signature.

(This example is informative.)

In the following example, adapted from Section 2.2.1 of 'XML Encryption Syntax and Processing,' the resource image.jpeg is encrypted using a symmetric key algorithm (AES) and the symmetric key is further encrypted using an asymmetric key algorithm (RSA) with a key of John Smith.

```
<encryption xmlns ="urn:oasis:names:tc:opendocument:xmlns:container"
```

```
xmlns:enc="http://www.w3.org/2001/04/xmlenc#" xmlns:ds="http://www.w3.org/2000/09/xmldsig#"> <enc:EncryptedKey Id="EK"> <enc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#rsa­1_5"/> <ds:KeyInfo> <ds:KeyName>John Smith</ds:KeyName> </ds:KeyInfo> <enc:CipherData> <enc:CipherValue>xyzabc</enc:CipherValue> </enc:CipherData> </enc:EncryptedKey> <enc:EncryptedData Id="ED1"> <enc:EncryptionMethod Algorithm="http://www.w3.org/2001/04/xmlenc#kw­aes128"/> <ds:KeyInfo> <ds:RetrievalMethod URI="#EK" Type="http://www.w3.org/2001/04/xmlenc#EncryptedKey"/> </ds:KeyInfo> <enc:CipherData> <enc:CipherReference URI="image.jpeg"/> </enc:CipherData> </enc:EncryptedData> </encryption>
```