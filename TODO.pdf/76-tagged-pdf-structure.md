# TODO PDF 76: Tagged PDF structure tree

## Status: DONE

## What was implemented

`idml render --tagged sample.idml -o out.pdf` now emits a real PDF
structure tree. Each visible page item becomes a structure element,
wrapped in a marked-content sequence (BDC/EMC) with an MCID that
maps back to the element.

Architecture:

- `Render::StructureTracker` — per-pipeline object that allocates
  per-page MCIDs and buffers element registrations. `enabled?` is
  false when `tagged:` was not requested; everything is a no-op then.
- `Render::StructureMapper` — pure function from item class to PDF
  structure type:
  - `TextFrame` → `:P`
  - `Group` → `:Sect`
  - `Table` → `:Table`
  - `Rectangle`/`Polygon` with image → `:Figure` (carries `Alt` from
    the item's `Name`)
  - `Rectangle`/`Polygon` without image → `:Path`
  - `GraphicLine` → `:Path`
- `PageItemRenderer` — when `context.structure.enabled?`, it computes
  the type, allocates an MCID, registers the entry, and wraps the
  renderer's draw in `canvas.tagged(type, mcid: mcid)`. Unknown item
  classes (no mapping) bypass the wrap and render normally.
- `RenderContext` carries `structure` and `page_index`.
- `Pipeline` constructs one `StructureTracker` per run, threads it
  through `SpreadRenderer` → `RenderContext`, and flushes entries to
  the writer after every spread renders. Then calls
  `writer.build_structure` to finalise the tree.

## Limitations

- Structure is currently flat — every visible page item is a top-level
  child of `/StructTreeRoot`. PDF/UA nesting (Group → Sect, Table →
  TR/TD) is not yet emitted. pdfrb's `add_child(parent, type)` exists
  for nesting; future work.
- Master-spread items are tagged as content, not as artifacts. PDF/UA
  prefers `canvas.artifact(:background)` for page furniture; future
  work.
- TextFrame emits a single `:P` element, not one per paragraph run.
  IDML text frames can contain multiple paragraphs; the structure tree
  should ideally have one `:P` per paragraph.

## Verification

- `lib/idml/render/structure_tracker.rb` — MCID allocation + flush.
- `lib/idml/render/structure_mapper.rb` — item → type map.
- `lib/idml/render/page_item_renderer.rb:19` — `wrap_tagged` integration.
- `lib/idml/render/pipeline.rb:38` — tracker construction + flush.
- `spec/idml/render/structure_tracker_spec.rb` — 5 specs.
- `spec/idml/render/structure_mapper_spec.rb` — 9 specs.
- `spec/idml/render/render_pdfrb_pipeline_spec.rb:141` — integration
  spec asserts `/StructTreeRoot`, `/MarkInfo`, `/StructElem`, BDC/EMC
  counts; untagged variant asserts no tree.

## Acceptance criteria

- [x] `idml render --tagged sample.idml -o out.pdf` produces a PDF
      whose `/StructTreeRoot` has elements.
- [x] Each visible page item maps to a structure element with the
      right type (`:Figure`, `:P`, `:Path`, `:Sect`, `:Table`).
- [x] Items filtered out by `LayerFilter` do not get structure entries.
- [x] Spec covers enabled/disabled paths and item-type mapping.
