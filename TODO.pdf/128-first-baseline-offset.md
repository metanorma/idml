# TODO PDF 128: Text frame FirstBaselineOffset

## Status: COMPLETE — implemented 2026-08-23

## What was done

`TextFrameRenderer` honors
`TextFramePreference.FirstBaselineOffset` when positioning the
first line's baseline: AscentOffset places it ascent-below the top
inset (typically higher than the default leading-based position);
FixedHeight uses MinimumFirstBaselineOffset. LeadingOffset /
CapHeight / XHeight / EmboxHeight approximate as the existing
leading-based default (cap/x-height metrics are not exposed by
PdfrbFontMetrics). Applied in both the single-column and
multi-column paths.

## Known limitations

- CapHeight / XHeight offsets fall back to leading (font metrics
  expose ascent only).
- Not applied in vertical writing mode.
