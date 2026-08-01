# TODO 15: CLI

## Goal

`exe/idml` binary exposing the gem's main operations as a
command-line tool. Useful for ad-hoc IDML inspection and
round-trip verification without writing Ruby.

## Acceptance criteria

- [ ] `idml parts path.idml` lists every entry name in the package.
- [ ] `idml validate path.idml` runs Jing against each schematized
      part and reports per-part status. Exit non-zero if any part
      fails.
- [ ] `idml round-trip path.idml -o output.idml` extracts every
      part and writes a new IDML; verifies byte-equivalence.
- [ ] `idml prefix path.idml PREFIX -o output.idml` prefixes every
      Self attribute and writes a new IDML.
- [ ] `idml version` prints the gem version.
- [ ] `--help` and `-h` work for each command.
- [ ] Spec: invoke each subcommand via `Idml::CLI` and verify
      stdout/stderr/exit code.

## Files

- `exe/idml`
- `lib/idml/cli.rb`
- `lib/idml/cli/command.rb` (base class with common helpers)
- `lib/idml/cli/{parts,validate,round_trip,prefix,version}.rb`
- `lib/idml.rb` — autoload `CLI`.
- `spec/idml/cli_spec.rb`

## Design notes

- Use `Thor` for the CLI framework (De facto Ruby standard). Add
  `thor` as a runtime dependency.
- Each command is a class — open/closed. New commands add a file,
  not edit a switch statement.
- The CLI is a thin wrapper around the gem's existing API; no
  business logic lives in the CLI.

## Dependencies

- TODOs 02, 09, 10 (Package, Validation, Composition::Prefix).
