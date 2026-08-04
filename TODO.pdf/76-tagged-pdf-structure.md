# TODO PDF 76: Tagged PDF structure tree

## Status: PLANNED (design only)

## Goal

Emit a tagged-PDF structure tree (PDF/UA-1, PDF 1.7 §14.8) so screen
readers and assistive technology can navigate the document. Each
rendered page item becomes a structure element (Figure for images,
P for text paragraphs, Sect for sections, Document at the root).

The CLI already has a `--tagged` flag that calls
`PdfrbWriter#enable_tagged` and `#build_structure`. Today these calls
produce an empty `/StructTreeRoot`. This TODO populates the tree.

## Background

PDF structure elements form a tree rooted at `/StructTreeRoot`:

```
Document
├── Part (per spread)
│   ├── Sect (per page)
│   │   ├── Figure (per Image)
│   │   ├── P (per TextFrame paragraph)
│   │   ├── Path (per shape)
│   │   └── Sect (per Group, recursively)
```

Each element carries:
- `/S` — structure type (Figure, P, Sect, etc.)
- `/P` — parent element reference
- `/K` — kids (mcid integers or child element refs)
- `/Pg` — page reference (for leaf elements with mcid)
- `/Alt` — alternate description (e.g. image alt text)
- `/Lang` — language override

Marked-content operators `BMC`/`EMC` (or `BDC`/`EMC` with property
list) wrap content in the content stream, carrying an MCID that
links back to the structure element.

pdfrb 0.4.0 exposes:
- `Pdfrb::Content::Canvas#tagged(tag, mcid: nil, **props, &block)` —
  emits `BDC`/`EMC` with property list.
- `Pdfrb::Content::Canvas#artifact(type = nil, &block)` — wraps
  content as a PDF/UA artifact (header/footer/decoration).
- `Pdfrb::Document::Structure#add_element(type, text:, alt:, page:,
  mcid:)` — registers a structure element.

## Plan

1. **MCID allocation**: Each renderer requests an MCID from a
   per-page counter (kept in `RenderContext`) before drawing its
   item. The MCID goes into the `tagged` call wrapping the draw.
2. **Structure element registration**: After the canvas draw, the
   renderer calls `writer.add_structure_element(type, page_index:,
   mcid:, text:, alt:)` to register the structure element.
3. **Renderer mapping**: Each renderer maps its item to a structure
   type:
   - `RectangleRenderer`/`PolygonRenderer` with `ContentType="GraphicType"`
     and an image child → `Figure` with `Alt` from IDML `<Image Alt="...">`.
   - `RectangleRenderer`/`PolygonRenderer` without image → `Path` (or
     `Sect` if the item is a container).
   - `TextFrameRenderer` → `P` (one per paragraph run).
   - `GroupRenderer` → `Sect` (wraps its children's elements).
   - `TableRenderer` → `Table`, `TR`, `TH`, `TD` per row/cell.
4. **Artifact marking**: Page furniture (master-spread items,
   non-content decorations) is wrapped in `artifact(:background)`.
5. **Pipeline threading**: Pipeline passes a `structure: true` flag
   through `RenderContext`. Renderers only emit structure when the
   flag is set.
6. **Build**: Pipeline calls `writer.build_structure` at the end —
   this stitches the per-element registrations into a `/StructTreeRoot`.

## Acceptance criteria

- [ ] `idml render --tagged sample.idml -o out.pdf` produces a PDF
      whose `/StructTreeRoot` has a non-empty `/K` array.
- [ ] Each visible page item maps to a structure element with the
      right type (Figure, P, Path, Sect, Table).
- [ ] `pdfinfo out.pdf` (or equivalent) reports `Tagged: yes`.
- [ ] Spec renders a fixture and asserts presence of structure
      elements matching the rendered items.
- [ ] Items filtered out by `LayerFilter` do not get structure
      entries.

## Dependencies

- pdfrb `Canvas#tagged` and `Document::Structure#add_element` (DONE
  in 0.4.0).
- Per-page MCID counter — small addition to `RenderContext`.
- Per-renderer structure-type mapping table.
