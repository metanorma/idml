# IDML → PDF Rendering TODOs

This directory tracks the work to render an IDML package to PDF
without InDesign Server. The pipeline has three layers:

1. **Text engine** (TODOs 01–05): a pure-Ruby text layout engine
   that takes styled text runs + frame geometry and produces
   positioned glyphs. Uses font metrics via pdfrb's typed Fonts API.
2. **PDF content stream** (TODOs 06–10): maps IDML page items
   (shapes, text, colors, images) to pdfrb's Canvas API.
3. **Pipeline** (TODOs 11–13): ties the text engine and PDF
   output together. IDML Package → typed model → render plan →
   pdfrb Document → PDF file.

All entries are DONE — through the 2026-09 round: vertical keep
windows and multi-column NextColumn jumping (TODOs 154-155), RTL
alignment and vertical keeps (152-153), schema conformance +
InsetSpacing (151), the architecture deepening rounds (148-150),
mojikumi aki application (145), vertical Latin run groups (142),
hyphen breaks (139), and the known-limitation sweeps (135-138).
Vertical writing, kinsoku, ruby, and tate-chu-yoko all landed
(TODOs 122-125). TODO 61 is the live known-limitations index; the
remaining future enhancements are data-dependent (hyphenation
dictionary, mojikumi min/max aki bounds, kashida Arabic
justification). Each file carries a `## Status:` header with a
brief implementation summary.
