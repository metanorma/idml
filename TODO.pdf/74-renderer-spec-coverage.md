# TODO PDF 74: Renderer spec coverage

## Status: DONE

## What was implemented

Dedicated spec files for every renderer that previously had none.
Each spec uses real `Idml::Elements::*` instances (parsed from XML
fragments) or lightweight `Struct` doubles that mirror the renderer's
interface — no RSpec `double()` or `instance_double` anywhere.

New spec files:

- `spec/idml/render/polygon_renderer_spec.rb` — 4 examples covering
  visibility, missing bounds, fill rendering, and stroke + cap.
- `spec/idml/render/graphic_line_renderer_spec.rb` — 4 examples
  covering unstrokable skip, color-miss skip, basic line drawing,
  and StrokeStyle application.
- `spec/idml/render/group_renderer_spec.rb` — 4 examples covering
  empty group, child dispatch, item_transform concat, and
  layer_filter visibility.
- `spec/idml/render/table_renderer_spec.rb` — 4 examples covering
  visibility skip, empty rows skip, per-cell rectangle count, and
  stroke emission.
- `spec/idml/render/text_frame_renderer_spec.rb` — 3 examples
  covering no-story skip, non-chain-head skip, and end-to-end BT/ET
  emission against the sample-with-image fixture.
- `spec/idml/render/blending_spec.rb` — 11 examples (added earlier
  in TODO 69).
- `spec/idml/render/stroke_style_spec.rb` — 13 examples (added
  earlier in TODO 72).
- `spec/idml/render/rectangle_renderer_spec.rb` — 6 examples (added
  earlier in TODO 68).

## Cleanups

- `render_helpers_spec.rb` — removed the `#render_gradient` test that
  used `instance_double(Idml::Parts::Graphic)` (TODO 73).
- `rectangle_renderer_spec.rb` — replaced
  `canvas.document.shadings.instance_variable_get(:@registry)` with
  the public `shadings.registry` reader.
- `designmap_spec.rb` — replaced `parsed.send(actual_attr(attr))`
  with an explicit case/when reader.

## Acceptance criteria

- [x] Every renderer in `lib/idml/render/renderers/` has a dedicated
      spec file with at least 3 examples.
- [x] No `instance_double` or `double()` in render specs.
- [x] No `instance_variable_get` / `instance_variable_set` in render
      specs.
- [x] No `.send(...)` in any spec.
- [x] `bundle exec rake` green (2350+ examples, 0 failures).
