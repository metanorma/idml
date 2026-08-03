# TODO PDF 60: CLI PDF/A flag and compliance passthrough

## Goal

Wire the compliance option from CLI through Render.render to Pipeline.
Add `--pdf-a` flag to the CLI render command.

## Status: DONE

## What was implemented

- `Render.render(compliance:)` keyword argument passes to Pipeline.
- `Pipeline.new(package, output, font_search_paths, compliance:)` keyword.
- `cli.rb render` command accepts `--pdf-a` boolean flag.
- When set, Pipeline calls `apply_compliance(writer)` which adds XMP
  metadata and ICC OutputIntent for PDF/A-2a compliance.
