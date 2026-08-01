# TODO 17: YARD documentation

## Goal

Document the public API with YARD tags so users get rich docs
(`yard server`), and RubyGems.org shows API docs.

## Acceptance criteria

- [ ] Every public class (`Idml`, `Package`, `Document`,
      `Parts::Designmap`, `Composition::Prefix`, `Validation::Validator`)
      has YARD docstrings covering purpose, parameters, return type.
- [ ] Every public method has `@param` and `@return` tags.
- [ ] Add `yard` and `yard-rspec` (if useful) to the Gemfile
      development group.
- [ ] Add `.yardopts` configuring the build.
- [ ] Add `rake yard` task to generate docs locally.
- [ ] Rakefile `default` task unchanged (still spec + rubocop).
- [ ] CI workflow runs `yard` to confirm docs build without
      errors (does not gate the merge).

## Files

- All `lib/idml/*.rb` — add docstrings.
- `Gemfile` — add `yard`.
- `.yardopts`
- `Rakefile` — add `yard` task.

## Design notes

- Don't gold-plate. Cover the public API; private internals get
  short docstrings only where the why isn't obvious.
- Use `@example` blocks for non-trivial usage (Document#find_by_self,
  InsertIdml#call, etc.).

## Dependencies

- TODOs 11, 12 (so docs cover the accessors and Document API).
