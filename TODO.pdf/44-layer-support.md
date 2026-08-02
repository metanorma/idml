# TODO PDF 44: Layer support

## Goal

Parse Layer definitions from designmap.xml. Each page item's
`ItemLayer` attribute determines visibility. Items on hidden layers
are skipped during rendering.

## Acceptance criteria

- [ ] `Idml::Elements::Layer` model with Self, Name, Visible, Locked attrs.
- [ ] Designmap has `layer` collection attribute.
- [ ] Pipeline passes layer visibility map to SpreadRenderer.
- [ ] Page items with `ItemLayer` referencing a hidden layer are skipped.
- [ ] Items without ItemLayer are always rendered.
- [ ] Spec: hide a layer, verify its items absent from PDF.

## Dependencies

- TODO 16 (typed-model pipeline).
