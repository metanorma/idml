# Fixture attribution

Every `.idml` file under `spec/fixtures/` originates from an open-source
project. The gem's test suite uses them for round-trip verification.

## `sample-with-image/`

DOMVersion 21.5 fixture exported from Adobe InDesign 2026 by the project
maintainer on 2026-08-01. Includes the source `.indd` and a `.pdf`
render for visual diffing. Owned by this project.

## `simple_idml/`

Source: https://github.com/Starou/SimpleIDML/tree/master/tests/regressiontests/IDML
License: MIT (per SimpleIDML `LICENSE` file).
These are real-world magazine layouts (Le Figaro classifieds) —
multi-page documents with articles, photos, and XML structure.

## `patrick_agostini/`

Source: https://github.com/PatrickAgostini/idml/tree/main/tests/data
License: per PatrickAgostini/idml project.
Six minimal fixtures (`text`, `multipage`, `themes`, `placeholders`,
`bounded-text`, `shapes`) covering common IDML feature combinations.

## `joris_ros/`

Source: https://github.com/jorisros/IDMLlib/tree/master/tests/assets
License: per JorisRos/IDMLlib project.
Single `example.idml` used by the PHP IDMLlib library's test suite.

## `adobe_idmltools/`

Source: Adobe InDesign Plug-in SDK 21 (`devtools/idmltools/samples/helloworld/`).
License: Adobe SDK license (not redistributable outside the SDK — these
fixtures are bundled for testing only and follow the SDK terms).
Two `helloworld-*.idml` files: tiny canonical test documents from
Adobe's own IDML tooling.
