# TODO PDF 25: CLI render subcommand

## Goal

Add a `render` subcommand to the `idml` CLI that converts an IDML
file to PDF.

## Why

Users need a command-line interface to convert IDML to PDF without
writing Ruby code. The rendering pipeline exists but is only accessible
programmatically.

## Acceptance criteria

- [ ] `idml render input.idml output.pdf` produces a valid PDF.
- [ ] `--font-path` option adds custom font search directories.
- [ ] `--verbose` option prints progress (spreads processed, images
      embedded, fonts resolved).
- [ ] Exit code 0 on success, 1 on error (with message to stderr).
- [ ] Spec: invoke the CLI via `Thor` and verify output file exists.

## Files

- `lib/idml/cli.rb` (add `render` command)
- `lib/idml/cli/` (if commands are split into subcommand files)
- `spec/idml/cli_spec.rb`

## Design notes

- The CLI uses `Thor` (already a dependency).
- The render command calls `Idml::Render.render(package:, to:, font_search_paths:)`.
- Error handling: catch `Errors::PackageNotFound`, `Errors::InvalidPackage`
  and print user-friendly messages.

## Dependencies

- TODO 12 (Pipeline).
