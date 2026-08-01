# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project goal

Build a premier Ruby gem (`idml`) for **parsing, manipulating, validating, and
round-tripping Adobe InDesign IDML files in pure Ruby**. The gem must:

- Read and write `.idml` packages with full fidelity (round-trip: parse → model →
  reserialize → byte-equivalent XML parts and a valid ZIP container). This is
  the core scope and is pure-Ruby.
- Provide composition operations (insert_idml, add_page_from_idml, XML
  import/export) ported from SimpleIDML.
- Be modeled after `~/src/mn/sts-ruby/` — same gemspec/GHA/Rakefile shape, same
  `lutaml-model`-only serialization discipline, same anti-pattern spec, same
  autoload convention.

### `.indd` is NOT a peer of `.idml` — it's a foreign format

`.indd` is Adobe's proprietary binary format (magic bytes
`06 06 ed f5 d8 1d 46 e5 bd 31 ef e7 fe 74 b7 1d`), not a ZIP container.
`unzip` fails on it. It's an opaque serialization of InDesign's internal
object graph; no production-quality open-source parser exists, and the
format changes between InDesign versions.

The gem does NOT parse `.indd` directly. Instead, it integrates with
whatever converter the user has:

- **InDesign desktop + JSX** (free, user-side) — manual `File → Export`, or
  scripted via the Scripts panel. Most users do this once and feed the
  resulting `.idml` to the gem.
- **InDesign Server SOAP** (`IDSP.wsdl`) — server-side automation. Optional
  integration via a future `Idml::InDesign::Client` (mirror of SimpleIDML's
  `indesign/` module). Used when the workflow is headless server-side.

Document this clearly in the README so users know to export `.indd` → `.idml`
before invoking the gem. Treat `.indd` direct parsing as out of scope unless a
maintainer steps up to maintain a version-aware binary parser.

Today the repo is a stub (README + `reference-docs/idml-specification.pdf`).
The first real work is bootstrap + spec extraction.

## Build and test commands (target shape — mirror sts-ruby)

```bash
bundle exec rake                 # spec + rubocop (default task)
bundle exec rspec                # tests only
bundle exec rspec spec/idml/package_spec.rb   # one spec file
bundle exec rspec spec/idml/...:42            # one example by line
bundle exec rubocop              # lint
bundle exec rubocop -a           # auto-fix
```

Use `bundle exec rake release` only through the metanorma CI release workflow —
**never push tags or commit to main locally** (see global rules).

## Reference materials (port from these)

| Path | What it gives us |
| --- | --- |
| `reference-docs/idml-specification.pdf` | Adobe's authoritative IDML spec (prose). Keep as cross-reference; the markdown extraction (below) is what we cite day-to-day. |
| `reference-docs/plugin_sdk_21/` | Adobe InDesign Plug-in SDK 21. Contains the canonical IDML toolchain. |
| `reference-docs/plugin_sdk_21/docs/html/id_idml_cookbook.html` | IDML Cookbook — how-tos from Adobe. |
| `reference-docs/plugin_sdk_21/devtools/idmltools/` | Adobe's own IDML library (Java): `Package`, `PackageInspector`, `PackageTransformer`, `Validator`, plus sample programs (`PageBuilder`, `ICMLBuilder`, `ReplaceStory`, `ReplaceImages`, `ImportXmlTemplate`, `CopyStyles`, `AddCatalogPages`, `Notes`, `ConditionalText`). **Most authoritative behavioral reference** — match its API names where sensible. |
| `reference-docs/plugin_sdk_21/devtools/idmltools/jing/` | Bundled Relax-NG validator (Jing 20030619). Use `java -jar .../jing.jar schema.rng file.xml` for validation. |
| `reference-docs/plugin_sdk_21/devtools/idmltools/scripts/{GenerateSchema,GeneratePackageSchema}.jsx` | Schema-generation scripts (already edited to write to `reference-docs/schemas/{single,package}/`). Run via InDesign desktop Scripts panel or `InDesignServer -script`. Produces the canonical RNG schema from InDesign's internal IDML model. **Note:** Adobe's generator leaks prose into `datatype.rnc:177-196`; `reference-docs/schemas/fix-adobe-schema-bug.rb` patches it idempotently. See `reference-docs/schemas/README.md` for the regeneration procedure and version-compatibility caveats. |
| `reference-docs/plugin_sdk_21/devtools/idmltools/samples/helloworld/` | Adobe's own round-trip fixtures (`helloworld-1.idml`, `helloworld-2.idml`, `helloworld-1.indd`). |
| `~/src/external/idml/` (PatrickAgostini/idml, "expanded-schema") | **Schema cross-check.** `schema/rnc/` and `schema/rng/` contain Adobe-format RNG/RNC organized by IDML part type (MasterSpreads, Spreads, Stories, Resources, XML, Packaging, `datatype.rnc`, `designmap.rnc`). `idml_schema/models/` has Pydantic models generated via xsdata (RNC → RNG → XSD → Pydantic). Useful as a structural cross-check; our canonical schemas are in `reference-docs/schemas/`. |
| `reference-docs/spec/` | **Spec extraction (local copy).** The IDML spec PDF converted to browsable markdown: `00_index.md` plus 11 sections (`00_title` → `10_idml_file_reference`) and `appendix/`. Use this for prose and element reference tables — no need to re-extract the PDF. Source: PatrickAgostini/idml-schema. |
| `~/src/external/idml-schema/` (PatrickAgostini/idml-schema) | Upstream of the local spec copy above. Also has a Python implementation (`src/idml_schema/`: cli, core, manipulation, models, parsers, utils, writers) for cross-reference. |
| `~/src/external/docling-idml/` (PatrickAgostini/docling-idml) | Docling-based IDML → JSON converter. Reference for extraction/serialization pipelines that consume IDML. |
| `~/src/mn/sts-ruby/` | Canonical Ruby style: `sts.gemspec`, `Rakefile`, `.rspec`, `.rubocop.yml`, `.github/workflows/{rake,release}.yml`, `lib/sts.rb` autoload shape, `spec/anti_patterns_spec.rb`. Copy this skeleton. |
| `~/src/external/SimpleIDML/` | Python. Richest behavioral reference for composition: `insert_idml`, `add_page_from_idml`, `prefix`, XML import/export. Full regression tests + fixtures under `tests/regressiontests/`. **Port the fixtures and round-trip tests.** |
| `~/src/external/IDMLlib/` | PHP. Reader reference; `Builder/Factory/Model` split. Useful for the element model but incomplete — prefer idmltools + SimpleIDML. |
| `~/src/oimlsmart/publications-private/` | Reference for the PDF→text + GLM OCR pipeline (now mostly superseded by the pre-extracted spec in `external/idml-schema/docs/idml-specification/`). |

### Schema authority (in priority order)

1. **Generated RNG from InDesign** (`reference-docs/schemas/{single,package}/`) — canonical for InDesign 2026 (DOMVersion 21.5). Already validated against `spec/fixtures/sample-with-image/sample-with-image.idml` (all 14 parts pass).
2. **Pre-extracted RNG/RNC** at `~/src/external/idml/schema/{rng,rnc}/` — cross-check, may lag.
3. **Spec markdown** at `reference-docs/spec/` — prose + element reference tables for human reading and attribute-set spec derivation.
4. **idmltools Java source** — behavioral ground truth for edge cases.

When porting, **attribute lists come from the spec markdown or RNG schema**, structure and behavior from idmltools/SimpleIDML.

### Round-trip fixtures

- **`spec/fixtures/sample-with-image/`** — a complete `.indd` / `.idml` / `.pdf` triple exported from InDesign 2026 (DOMVersion 21.5). The `.idml` is the canonical round-trip fixture (validates clean against all 14 part schemas). The `.indd` is the source-of-truth binary; the `.pdf` is for visual diffing during composition work.
- **`reference-docs/plugin_sdk_21/devtools/idmltools/samples/helloworld/`** — Adobe's own fixtures (2017-era, useful for cross-version compatibility tests but not for strict validation against the 21.5 schemas).

## IDML container model

An `.idml` file is a UCF ZIP archive (stored, not deflated — `ZIP_STORED`) of
loosely-coupled XML parts. Round-trip means rebuilding every part, not just the
ones we model:

```
mimetype                              — must be first, uncompressed
META-INF/container.xml                — points at designmap.xml
designmap.xml                         — manifest of all other parts
Resources/
  Fonts.xml
  Graphic.xml
  ObjectStyles.xml
  PageStyles.xml (?)
  Preferences.xml
  StoryStyles.xml
  StyleMapping.xml
  Styles.xml
  Tags.xml
XML/
  BackingStory.xml                    — root of the logical XML structure
  Tags.xml
  Mapping.xml
  PhysicsPackage*.xml (?)
MasterSpreads/MasterSpread_*.xml
Spreads/Spread_*.xml
Stories/Story_*.xml                   — flow text content
Settings.xml
[Plug-in dicts, etc.]
```

Spreads hold page items (geometry); Stories hold text flows; BackingStory is
the logical XML tree root; `XMLContent` attributes on page items and
`XMLElement` wrappers in Stories link the geometric and logical trees.

## Architecture (target)

```
Idml
├── VERSION
├── Package                  # the ZIP container: read parts, write parts,
│                            #   working-copy semantics (cf. SimpleIDML's
│                            #   @use_working_copy)
├── Part                     # base class for one XML file in the package
├── Designmap                # parses/writes designmap.xml
├── Spread, MasterSpread     # Spreads/*.xml, MasterSpreads/*.xml
├── Story, BackingStory      # Stories/*.xml, XML/BackingStory.xml
├── Style, StyleMapping      # Resources/Styles.xml, StyleMapping.xml
├── Graphic                  # Resources/Graphic.xml
├── Fonts, Tags              # Resources/Fonts.xml, XML/Tags.xml
├── Preferences              # Resources/Preferences.xml
├── XMLElement               # proxy for an XMLElement node (links the
│                            #   logical tree to its Story)
└── Composition              # operations: insert_idml, add_page_from_idml,
                             #   prefix, import_xml, export_xml — ported
                             #   from SimpleIDML
```

### Per-XML-file modeling rule

Every XML part is one `Lutaml::Model::Serializable` subclass. Element classes
inside a part (e.g. `Rectangle`, `TextFrame`, `ParagraphStyleRange`,
`CharacterStyleRange`, `Content`, `InCopyExportOption`) get their own class,
nested under the part's namespace. Attribute lists come from the IDML spec
section for that element.

```ruby
module Idml
  class Spread < Lutaml::Model::Serializable
    attribute :self, :string
    attribute :page, ::Idml::Spread::Page, collection: true
    attribute :rectangle, ::Idml::Spread::Rectangle, collection: true
    attribute :text_frame, ::Idml::Spread::TextFrame, collection: true
    # ...per spec section on <Spread>

    xml do
      root "Spread"
      map_attribute "Self", to: :self
      map_element "Page", to: :page
      map_element "Rectangle", to: :rectangle
      map_element "TextFrame", to: :text_frame
      ordered  # child order is semantically meaningful in IDML — preserve it
    end
  end
end
```

### Autoload convention

`lib/idml.rb` eager-requires `lutaml/model` and autoloads the top-level
namespaces. `lib/idml/<namespace>.rb` autoloads every class in that namespace,
grouped by category, alphabetical within each group — exactly as sts-ruby does.
**Never** `require_relative` inside `lib/`. Enforced by `spec/anti_patterns_spec.rb`.

### Round-trip contract

A round-trip test for any part looks like:

```ruby
xml = File.read("spec/fixtures/<part>.xml")
expect(Idml::Spread.to_xml(Idml::Spread.from_xml(xml)))
  .to be_xml_equivalent_to(xml)
```

The gold standard is whole-package round-trip: unzip a fixture `.idml`,
rebuild every part, rezipping, and assert byte-equivalence part-by-part (the
`mimetype` member must remain stored/uncompressed and first in the archive).
Use SimpleIDML's `tests/regressiontests/IDML/` fixtures as the corpus.

## Conventions (project-specific, enforced)

1. **lutaml-model only — no hand-rolled serialization.** Never define
   `to_h`/`from_h`/`to_xml`/`from_xml`/etc. on a model. Wire names and renames
   through `mapping`. (See global rule + `spec/anti_patterns_spec.rb`.)
2. **No `double()` in specs.** Use real model instances or lightweight
   `Struct`s. (Global rule.)
3. **Anti-pattern spec is mandatory.** Port `sts-ruby/spec/anti_patterns_spec.rb`
   on day one; it checks every `lib/` file for `method_missing`,
   `instance_variable_set/get`, `.send(`, `respond_to?` type-checks,
   `Object.const_get`, `require_relative`, internal `require`, hand-rolled
   serializers, and Nokogiri references.
4. **Schema authority.** For any new element class, generate the attribute list
   from `reference-docs/idml-specification.pdf` (the relevant section). Don't
   copy from SimpleIDML/IDMLlib blindly — they disagree on edge attributes.
5. **Attribute-set specs.** Each element class has a spec asserting its
   attribute set, the way sts-ruby does — this is the project's defence
   against drift, since round-trip alone cannot prove spec conformance.
6. **`ordered` on every part's root mapping.** Child order is semantically
   meaningful throughout IDML (z-order in spreads, paragraph order in stories).
7. **`ZIP_STORED` for the package.** IDML files are uncompressed; matching that
   is part of byte-faithful round-trip.
8. **lutaml-model only — no Nokogiri, no REXML.** The gem is fully
   model-driven through `lutaml-model`; every XML query routes through
   typed model methods. No `Lutaml::Xml::Document.parse`, no Moxml
   directly, no Nokogiri, no REXML. The anti-pattern spec hard-bans
   `require "nokogiri"`, `require "rexml/..."`, `Nokogiri::`, and
   `REXML::` references in `lib/`. See `TODO.complete/18-remove-nokogiri.md`
   and `TODO.complete/23-lutaml-only-no-rexml.md`.
9. **Attribute lists come from the RNC schemas.** For any new element
   class, generate the attribute list from the matching definition in
   `reference-docs/schemas/package/**/*.rnc` (e.g.,
   `Stories/Story.rnc` for the `<Story>` element). Don't guess — the
   RNC is the authority. See `TODO.complete/26-rnc-faithful-models.md`.

## Workflow rules (non-negotiable, from global CLAUDE.md)

- **Never delete source files** (any file you didn't create; any file at all by
  default). "Unused by code" is not "dispensable". Ask, don't act.
- **Never push tags, never commit/push to main, never merge to main.** All
  changes go through PRs.
- **Never add AI attribution** — no `Co-authored-by`, no "Generated with".
- **Never use `git add -A` / `git add .` / `git add -u`.** Stage by explicit
  path; verify the staged set before committing.
- **Never pass PR/commit bodies containing backticks inline** — use
  `--body-file`.
- **Library packages have no side effects.** Generated output goes to the
  caller's working directory, never into the gem's install location.

## Roadmap (suggested order — write a plan before starting)

Phases 1–3 are already done as part of repo setup; remaining phases are
implementation work.

1. **Bootstrap.** Copy skeleton from sts-ruby: `idml.gemspec`, `Gemfile`,
   `Rakefile`, `.rspec`, `.rubocop.yml` (+ `.rubocop_todo.yml` empty),
   `.github/workflows/{rake,release}.yml`, `lib/idml.rb`, `lib/idml/version.rb`,
   `spec/spec_helper.rb`, `spec/anti_patterns_spec.rb`. Get `bundle exec rake`
   green on an empty suite.
2. **DONE** — Spec markdown vendored at `reference-docs/spec/` (from
   PatrickAgostini/idml-schema).
3. **DONE** — RNG schemas generated from InDesign 2026 at
   `reference-docs/schemas/{single,package}/`, Adobe-bug patched via
   `fix-adobe-schema-bug.rb`, validated clean against
   `spec/fixtures/sample-with-image/sample-with-image.idml` (all 14 parts pass).
4. **InDesign Server SOAP client** (`.indd` integration, *optional/deferred*).
   Only needed for headless server-side workflows. Port SimpleIDML's
   `indesign/` module against `reference-docs/server/lib/IDSP.wsdl`.
   Operations: `save_as(src, [{fmt: "idml"}, {fmt: "pdf"}, {fmt: "indd"}])`
   and `export_package_as`. SOAP samples at
   `reference-docs/server/samples/sample-client/{java,aspnet}/` show the
   request/response shapes. **Most users do not need this** — they export
   `.indd` → `.idml` once via InDesign desktop and feed the `.idml` to the gem.
5. **Package layer.** `Idml::Package` — ZIP read/write, part lookup by name,
   working-copy semantics. Port from SimpleIDML's `IDMLPackage` minus the lazy
   XML caches (we use `lutaml-model` instead of `lxml.etree`).
6. **Core XML parts, in dependency order:** `Designmap`, `Fonts`, `Tags`,
   `Style`, `StyleMapping`, `Graphic`, `Preferences`, `BackingStory`, `Story`,
   `Spread`, `MasterSpread`. Each gets a round-trip spec against the
   `sample-with-image` fixture part. Attribute lists derived from the RNG/RNC
   schemas — not from sibling libraries.
7. **Whole-package round-trip suite.** Use `spec/fixtures/sample-with-image/`
   as the canonical DOMVersion 21.5 fixture; port SimpleIDML's
   `tests/regressiontests/IDML/` for cross-version coverage. Assert
   byte-equivalent rezip (mimetype stored + first, all other parts as
   generated).
8. **Validation.** Real Relax-NG validation via Jing (`java -jar`) or
   Nokogiri's embedded RNG validator against the committed schemas, plus
   per-class attribute-set specs as the structural-conformance floor. Document
   that strict validation is version-scoped — older IDML files won't validate
   against the 21.5 schemas (use byte-equivalence for those).
9. **Composition layer.** Port `insert_idml`, `add_page_from_idml`, `prefix`,
   `import_xml`, `export_xml` from SimpleIDML. API names should match
   idmltools samples where sensible (`PageBuilder`, `ReplaceStory`,
   `ReplaceImages`, `ImportXmlTemplate`). Coordinate transforms live in
   `Idml::Geometry` (see `SimpleIDML/doc/IDML_insert_idml_coordinate_transformation.*`).
10. **PDF round-trip** (later). Use the SOAP client (phase 4) to regenerate
    `.pdf` from composed `.idml`, then visually diff against the fixture's
    `.pdf` to catch layout regressions the schema can't see. The
    `spec/fixtures/sample-with-image/sample-with-image.pdf` is the gold
    reference image for the fixture.

When tackling any phase, write the plan first and reach alignment with the user
before touching code.
