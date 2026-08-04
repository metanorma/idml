# TODO PDF 75: PDF metadata enrichment from IDML XMP

## Status: BLOCKED (Lutaml XMP namespace parsing)

## Goal

Pull IDML document metadata from `META-INF/metadata.xml` (XMP packet)
into the PDF Info dictionary via `PdfrbWriter#set_info`:

- `dc:title` → PDF `/Title`
- `dc:creator` → PDF `/Author`
- `dc:description` → PDF `/Subject`
- `dc:subject` → PDF `/Keywords`
- `xmp:CreatorTool` → PDF `/Creator`
- `xmp:CreateDate` → PDF `/CreationDate`
- `xmp:ModifyDate` → PDF `/ModDate`

## Blocker

`META-INF/metadata.xml` is an XMP packet — RDF/XML with multiple XML
namespaces (`dc:`, `xmp:`, `pdf:`, `xmpMM:`, `stFnt:`, etc.). Parsing
it with `lutaml-model` requires namespace-aware element mapping.

Lutaml 0.8.19's namespace API is in flux:

- `namespace "..."` with a URI string raises
  `String namespace URIs are not supported. Define an XmlNamespace
  class instead.`
- `namespace: Lutaml::Xml::XmlNamespace.new(uri, prefix)` raises
  a `NoMethodError` inside `process_mapping`.
- `map_element "dc:format"` (prefix in name) is silently ignored —
  local-name lookup strips the prefix.
- `prefix: "dc"` is ignored when there is no `namespace:` on the
  mapping.

The CLAUDE.md rule "no `Lutaml::Xml::Document.parse`" rules out
falling back to a generic XmlDocument traversal. We must use a typed
model.

## Path forward

Wait for Lutaml to stabilise its namespace API, then add a typed
`Idml::Parts::XmpMetadata` model that maps each XMP field to a Ruby
attribute. Pipeline reads `META-INF/metadata.xml`, calls
`XmpMetadata.from_xml`, and threads the resulting attributes through
`PdfrbWriter#set_info`.

When the blocker clears, the implementation looks like:

```ruby
module Idml
  module Parts
    class XmpMetadata < Lutaml::Model::Serializable
      attribute :title, :string
      attribute :author, :string
      attribute :subject, :string
      attribute :keywords, :string
      attribute :creator_tool, :string
      attribute :create_date, :string
      attribute :modify_date, :string

      xml do
        root "Description"
        # …namespace-aware mappings once Lutaml supports them…
      end
    end
  end
end

# In Pipeline:
if @package.has_part?("META-INF/metadata.xml")
  xmp = Idml::Parts::XmpMetadata.from_xml(
    @package.read_part("META-INF/metadata.xml"),
  )
  writer.set_info(
    Title: xmp.title,
    Author: xmp.author,
    Subject: xmp.subject,
    Keywords: xmp.keywords,
    Creator: xmp.creator_tool,
    CreationDate: pdf_date(xmp.create_date),
    ModDate: pdf_date(xmp.modify_date),
  )
end
```

## Acceptance criteria (after blocker clears)

- [ ] Pipeline reads `META-INF/metadata.xml` when present.
- [ ] `XmpMetadata` typed model parses dc:title/creator/description/
      subject plus xmp:CreatorTool/CreateDate/ModifyDate.
- [ ] Pipeline passes the parsed fields to `PdfrbWriter#set_info`.
- [ ] Existing Producer/CreationDate defaults still apply when XMP
      or individual fields are absent.
- [ ] Spec covers a synthetic XMP packet with all fields populated,
      plus the no-metadata fallback.

## Dependencies

- Lutaml namespace API stable enough that
  `map_element "format", namespace: <XmlNamespace>` works without
  raising. Tracked at the Lutaml migration guide referenced in the
  error message: `docs/_guides/xml-namespaces.adoc`.
