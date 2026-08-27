# TODO PDF 139: Hyphen break opportunities in the LineBreaker

## Status: COMPLETE — implemented 2026-08-27

## Problem

The greedy line breaker only treated spaces as break opportunities.
Long compound words ("state-of-the-art", "e-mail") overflowed the
frame as one unbreakable run instead of wrapping after a hyphen.

## Solution

`LineBreaker#break_after?` treats hyphen-minus (U+002D), Unicode
hyphen (U+2010), non-breaking hyphen (U+2011), and soft hyphen
(U+00AD) as break-after points: the hyphen stays on the first line
and the remainder wraps. Soft hyphens break without adding a
visible hyphen. Dictionary-based hyphenation (Knuth-Liang) remains
out of scope — the Hyphenation* PSR attributes stay parsed but
unused.

## Files

- `lib/idml/text_engine/line_breaker.rb`
- `spec/idml/text_engine/text_engine_spec.rb`
