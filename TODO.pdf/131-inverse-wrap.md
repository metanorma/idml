# TODO PDF 131: Inverse text wrap

## Status: COMPLETE — implemented 2026-08-23

## What was done

`TextWrapPreference Inverse="true"` flips the wrap region: text
may only flow INSIDE the wrap shape (the avoid-region becomes
everything outside it within the frame). Works for both the
bounding-box contour and the Contour-mode polygon shape (TODO
130); the inversion lives in one place — TextWrapResolver's
overlap dispatch — and reduces by (frame width − inside width),
so bands outside the shape block text entirely.

## Known limitations

- Side-aware narrowing is not implemented: the reduction shrinks
  the wrap width from the right regardless of which side the
  shape occupies.
