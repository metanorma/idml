# TODO 09: RelaxNG validation via Jing

## Goal

Wrap the bundled Jing validator (`reference-docs/plugin_sdk_21/devtools/idmltools/jing/`)
behind a Ruby API. Users can validate any `.idml` part (or whole package)
against the schemas in `reference-docs/schemas/package/`.

## Acceptance criteria

- [ ] `Idml::Validation` module autoloaded from `lib/idml.rb`.
- [ ] `Idml::Validation::Validator.new(schema_root:)` — points at the RNG
      schema directory (default: vendored under the gem, see below).
- [ ] `#validate_part(file_name, xml)` → returns a `Result` with `#ok?`,
      `#errors` (Array of error message strings).
- [ ] `#validate_package(package)` → returns a `ResultSet` enumerating
      per-part `Result`s.
- [ ] Jing is invoked as `java -jar .../jing.jar -c <rnc> <xml>`; output is
      parsed for `error:` lines.
- [ ] On a clean fixture (`sample-with-image.idml`), all 14 parts validate
      OK.
- [ ] On a deliberately-broken XML (e.g., missing required attribute),
      errors are captured and reported with line numbers.
- [ ] `java` not on PATH → raises `Idml::Validation::JavaUnavailable` with a
      helpful message.

## Files

- `lib/idml/validation.rb`
- `lib/idml/validation/result.rb` (or inline)
- `lib/idml/validation/validator.rb` (or inline)
- `spec/idml/validation/validator_spec.rb`

## Design notes

- Schema sourcing: do NOT vendor the 1.6 MB schemas into the gem install.
  Instead, accept a `schema_root:` argument with a sensible default that
  points at `reference-docs/schemas/package/` for development. Document
  this in the README. Users who want validation install schemas separately.
- Jing invocation: `Open3.capture3` to capture stdout/stderr separately.
  Jing emits errors to stderr.
- Result objects: structs, not heavy classes. `Struct.new(:file_name, :ok,
  :errors)`.
- Java version: Jing 20030619 needs Java 1.4+; modern Javas (8–21) work.
  Don't over-engineer detection — `java -version` once, cache the result.
- The schema file for a given part name comes from the same mapping used by
  `Parts::PATTERNS` — reuse it.

## Dependencies

- TODO 02 (Package), TODO 03 (Parts mapping).
