# TODO PDF 75: PDF metadata enrichment from IDML XMP

## Status: DONE

## What was implemented

Pull IDML document metadata from `META-INF/metadata.xml` (XMP packet)
into the PDF Info dictionary via `PdfrbWriter#set_info`:

- `dc:title` (rdf:Alt x-default) → PDF `/Title`
- `dc:creator` (rdf:Seq first li) → PDF `/Author`
- `dc:description` (rdf:Alt x-default) → PDF `/Subject`
- `dc:subject` (rdf:Bag joined) → PDF `/Keywords`
- `xmp:CreatorTool` → PDF `/Creator`
- `xmp:CreateDate` → PDF `/CreationDate`
- `xmp:ModifyDate` → PDF `/ModDate`

## Architecture

XMP has multiple XML namespaces (`dc:`, `xmp:`, `pdf:`) inside one
`<rdf:Description>` element. Per Lutaml's namespace API, each
namespaced child is its own `Lutaml::Model::Serializable` subclass
carrying its own `namespace` declaration via a `Lutaml::Xml::Namespace`
class. The parent composes the children via `map_element`.

Layered models in `lib/idml/parts/xmp.rb`:

- `Xmp::RdfNamespace`, `DcNamespace`, `XmpNamespace`, `XmetaNamespace` —
  `Lutaml::Xml::Namespace` subclasses with `uri` and `prefix_default`.
- `Xmp::Leaf` base + `Format`/`CreatorTool`/`CreateDate`/`ModifyDate`/
  `MetadataDate` — single direct-value leaves.
- `Xmp::ListItem` (rdf:li), `Alt` (rdf:Alt with x-default lookup),
  `Seq` (rdf:Seq), `Bag` (rdf:Bag) — RDF container types.
- `Xmp::Title`/`DcDescription`/`Creator`/`Subject` — dc: elements that
  wrap the RDF containers.
- `XmpDescription` — single rdf:Description composing all the leaves
  and containers above.
- `XmpRdf` — rdf:RDF with a collection of Descriptions plus merged
  accessors (`title`, `author`, `keywords`, etc.) that pick the first
  non-nil across Descriptions.
- `XmpMeta` — outer `<x:xmpmeta>` wrapper.

Pipeline threads this through `combined_metadata`, which starts from
the default Producer+CreationDate and overrides each field that the
XMP packet supplies.

## Verification

- `lib/idml/parts/xmp.rb` — typed XMP models.
- `lib/idml/render/pipeline.rb:193` — `combined_metadata` merge.
- `spec/idml/parts/xmp_meta_spec.rb` — 11 specs covering direct
  elements, containers, missing fields, and the fixture.
- `spec/idml/render/render_pdfrb_pipeline_spec.rb` — integration spec
  asserts `/Creator` from XMP lands in the PDF.

## Acceptance criteria

- [x] Pipeline reads `META-INF/metadata.xml` when present.
- [x] `XmpMeta` typed model parses dc:title/creator/description/subject
      plus xmp:CreatorTool/CreateDate/ModifyDate.
- [x] Pipeline passes the parsed fields to `PdfrbWriter#set_info`.
- [x] Existing Producer/CreationDate defaults still apply when XMP
      or individual fields are absent.
- [x] Spec covers a synthetic XMP packet with all fields populated,
      plus the no-metadata fallback.
