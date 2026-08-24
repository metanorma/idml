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

All entries are DONE except: TODO 117 (endnote TEXT rendering —
gated on a real fixture to resolve the EndnoteTextRange reference
chain) and TODO 13's final stretch goal (full class-based mojikumi
tables; script spacing and line-end compression are in). Vertical
writing, kinsoku, ruby, and tate-chu-yoko all landed (TODOs
122-125). TODO 61 is the live known-limitations index. Each file
carries a `## Status:` header with a brief implementation summary.
