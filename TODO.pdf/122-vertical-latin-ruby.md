# TODO PDF 122: Vertical mode completion — Latin rotation, vertical ruby

## Status: COMPLETE — implemented 2026-08-20

## Problem

The vertical writing path (TODO 13, 2026-08-19) stacked every glyph
upright: Latin letters and digits rendered sideways-wrong (rotated
in appearance relative to convention), and ruby annotations were
not emitted at all in vertical mode.

## What was done

- Latin rotation: non-CJK glyphs in vertical text render rotated
  90° clockwise (the vertical-writing convention for Latin runs),
  via a graphics-state transform (q → translate → rotate −90° →
  text at origin → Q). CJK glyphs stay upright.
- Vertical ruby: runs carrying RubyString emit the annotation
  stacked vertically alongside the base glyphs — to the right of
  the column by default, to the left for RubyPosition values
  containing "Below" (mirroring the horizontal above/below
  convention under rotation). RubyFontSize defaults to half the
  base size.

## Known limitations

- Tate-chu-yoko (horizontal digit groups inside vertical text) and
  mojikumi spacing classes remain documented stretch goals
  (TODO 13).
