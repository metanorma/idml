# TODO 19: Vendor IDML fixtures from reference repos

## Goal

Build a comprehensive `.idml` fixture corpus under `spec/fixtures/`
by pulling every unique `.idml` file from the reference repos. The
corpus anchors TODO 20's round-trip suite.

## Acceptance criteria

- [ ] `spec/fixtures/simple_idml/` contains every unique `.idml` from
      `~/src/external/SimpleIDML/tests/regressiontests/IDML/`
      (excluding `expected/` subdir).
- [ ] `spec/fixtures/patrick_agostini/` contains the 6 shared fixtures
      from `~/src/external/idml/tests/data/` (text, multipage, themes,
      placeholders, bounded-text, shapes).
- [ ] `spec/fixtures/joris_ros/` contains `example.idml` from
      `~/src/external/IDMLlib/tests/assets/`.
- [ ] `spec/fixtures/adobe_idmltools/` contains `helloworld-1.idml`
      and `helloworld-2.idml` from the curated plugin_sdk_21 tree.
- [ ] Existing `spec/fixtures/sample-with-image/` stays in place.
- [ ] `spec/fixtures/ATTRIBUTION.md` documents the source repo and
      license for each fixture directory.

## Files

- `spec/fixtures/simple_idml/*.idml` (~15 files)
- `spec/fixtures/patrick_agostini/*.idml` (6 files)
- `spec/fixtures/joris_ros/*.idml` (1 file)
- `spec/fixtures/adobe_idmltools/*.idml` (2 files)
- `spec/fixtures/ATTRIBUTION.md`

## Design notes

- Don't copy `expected/` from SimpleIDML — those are SimpleIDML's own
  test outputs, not canonical inputs.
- Don't add `.indd` files; we don't read `.indd`.
- Some fixtures are older (InDesign CS5–CS6 era, DOMVersion ~7–8).
  They won't validate against the InDesign 2026 schemas but should
  still round-trip byte-equivalent via the Package layer.

## Dependencies

- None.
