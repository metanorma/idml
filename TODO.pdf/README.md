# IDML → PDF Rendering TODOs

This directory tracks the work to render an IDML package to PDF
without InDesign Server. The pipeline has three layers:

1. **Text engine** (TODOs 01–05): a pure-Ruby text layout engine
   that takes styled text runs + frame geometry and produces
   positioned glyphs. Uses font metrics from .ttf/.otf files.

2. **PDF content stream** (TODOs 06–10): maps IDML page items
   (shapes, text, colors, images) to PDF content-stream operators
   using pdfrb's Document/Canvas API.

3. **Pipeline** (TODOs 11–13): ties the text engine and PDF
   output together. IDML Package → typed model → render plan →
   pdfrb Document → PDF file.

The text engine is intentionally IDML-agnostic: it works on
styled text runs and frame geometry, not IDML-specific types.
This makes it reusable (e.g., for generating PDFs from scratch
or from other layout formats).
