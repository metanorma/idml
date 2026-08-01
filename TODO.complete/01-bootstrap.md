# TODO 01: Bootstrap gem skeleton

## Goal

Stand up a runnable gem: `bundle exec rake` is green on an empty suite, CI
workflows fire on PRs, anti-pattern spec is in force.

## Acceptance criteria

- [ ] `idml.gemspec` exists, declares `idml` 0.1.0, Ruby `>= 3.3.0`,
      BSD-2-Clause, deps `lutaml-model ~> 0.8.18` and `bigdecimal` (no `mml`).
- [ ] `Gemfile`, `Gemfile.lock` (after `bundle install`).
- [ ] `Rakefile` with `bundle exec rake` running spec + rubocop.
- [ ] `.rspec` with `--format documentation --color --require spec_helper`.
- [ ] `.rubocop.yml` inherits from `riboseinc/oss-guides` + `.rubocop_todo.yml`
      (empty), enables `rubocop-rspec`, `rubocop-performance`, `rubocop-rake`.
- [ ] `lib/idml.rb` eager-requires `lutaml/model`, autoloads `VERSION`.
- [ ] `lib/idml/version.rb` defines `VERSION = "0.1.0"`.
- [ ] `spec/spec_helper.rb` boots simplecov + loads `lib/idml`.
- [ ] `spec/anti_patterns_spec.rb` ports sts-ruby's checks: `method_missing`,
      `respond_to_missing?`, `Object.const_get`, `.send(`,
      `instance_variable_set/get`, `respond_to?` type-checks, hand-rolled
      serializers (`to_h`/`from_h`/`to_xml`/`from_xml` etc.), `require_relative`
      in lib/, internal `require` calls.
- [ ] `.github/workflows/rake.yml` and `release.yml` use metanorma/ci
      reusable workflows.
- [ ] `CODE_OF_CONDUCT.md`.
- [ ] `bundle exec rake` exits 0 on an empty spec suite.

## Files

- `idml.gemspec`
- `Gemfile`, `Gemfile.lock`
- `Rakefile`
- `.rspec`
- `.rubocop.yml`, `.rubocop_todo.yml`
- `lib/idml.rb`, `lib/idml/version.rb`
- `spec/spec_helper.rb`, `spec/anti_patterns_spec.rb`
- `.github/workflows/rake.yml`, `.github/workflows/release.yml`
- `CODE_OF_CONDUCT.md`

## Design notes

- Use `Dir.chdir(File.expand_path(__dir__)) { \`git ls-files -z\`.split("\x0") }`
  in gemspec to keep `spec.files` accurate (matches sts-ruby pattern).
- The anti-pattern spec is the project's load-bearing quality gate. It must
  pass on every commit, including this initial one.
- Set `TargetRubyVersion: 3.3` in `.rubocop.yml` (matches gemspec minimum).

## Dependencies

- None.
