# TODO 31: ExportXml composition op

## Goal

Implement `Composition::ExportXml` — produce a flat XML string
representing the package's logical XML structure tree + text content.
Mirrors SimpleIDML's `IDMLPackage.export_xml`.

## Acceptance criteria

- [ ] `ExportXml.new(pkg).call(at: nil)` returns a String of XML.
- [ ] Output is rooted at the package's BackingStory structure.
- [ ] Each XMLElement has its text content populated from its linked
      Story.
- [ ] Spec: exporting the fixture yields XML containing every tagged
      element with its text.

## Files

- `lib/idml/composition/export_xml.rb`
- `spec/idml/composition/export_xml_spec.rb`

## Design notes

- Walks BackingStory's XmlElement tree.
- For each XMLElement with an XMLContent attribute, fetches the
  linked Story and inlines its text.
- Output is well-formed XML via lutaml-model serialization.

## Dependencies

- TODO 12 (Document for navigation).
