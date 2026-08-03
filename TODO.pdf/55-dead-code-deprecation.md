# TODO PDF 55: Dead code deprecation markers

## Goal

Mark old hand-rolled modules as deprecated. These modules are
superseded by pdfrb but cannot be deleted per the project's
"never delete source files" policy. Add deprecation comments and
update autoloads to lazy-load only when explicitly referenced.

## Modules to deprecate

- `Idml::Render::PdfWriter` — replaced by `PdfrbWriter`
- `Idml::Render::FontEmbedder` — replaced by `PdfrbWriter.register_font`
- `Idml::Render::Color` — replaced by `ColorHelper` + Canvas fill_color
- `Idml::Render::Path` — replaced by Canvas drawing methods
- `Idml::Render::Text` — replaced by Canvas text method

## Acceptance criteria

- [ ] Each deprecated module has a `# DEPRECATED` header comment pointing
      to its pdfrb replacement.
- [ ] No active code path (Pipeline, SpreadRenderer, renderers) references
      deprecated modules.
- [ ] Tests for deprecated modules are tagged with `:deprecated` or
      moved to a separate spec file.
- [ ] `render.rb` autoloads keep the old modules for backward compatibility.

## Dependencies

- pdfrb migration (DONE).
