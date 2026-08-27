# TODO PDF 141: 100+ page performance regression guard

## Status: COMPLETE — implemented 2026-08-27

## Problem

No test guarded against per-page complexity blowups — a regression
to O(document) work per page would only surface as slow user
renders.

## Solution

`perf_hundred_pages_spec.rb` builds a synthetic 120-spread package
(one page + one text frame each, all sharing a wordy story) and
renders it end-to-end through `Idml::Render.render`. Asserts all
120 PDF pages emit and the render completes under a generous 60s
ceiling — sized to trip only on pathological blowups, not machine
noise. Baseline on this branch: ~2s for 120 pages.

## Files

- `spec/idml/render/perf_hundred_pages_spec.rb`
