# TODO 30: ImportXml composition op

## Goal

Implement `Composition::ImportXml` — replace text content in a
package's stories based on an XML structure tree. Mirrors
SimpleIDML's `IDMLPackage.import_xml`.

## Acceptance criteria

- [ ] `ImportXml.new(pkg).call(xml_string:, at:)` returns a new
      Package with text content updated per the XML.
- [ ] Honors SimpleIDML's flags:
  `simpleidml-setcontent="false"`,
  `simpleidml-ignorecontent="true"`,
  `simpleidml-setcontent="delete"`,
  `simpleidml-setcontent="clear"`,
  `simpleidml-setcontent="remove-previous-br"`,
  `simpleidml-forcecontent="true"`.
- [ ] Spec: importing a known XML fragment into the fixture replaces
      a specific story's text with the new content.

## Files

- `lib/idml/composition/import_xml.rb`
- `spec/idml/composition/import_xml_spec.rb`

## Design notes

- Walks the source XML tree (lutaml-model), finds matching XMLElement
  by Self in the package's stories, replaces Content text.
- Image references via `href` attribute swap image links — defer if
  complex.

## Dependencies

- TODO 12 (Document for navigation).
