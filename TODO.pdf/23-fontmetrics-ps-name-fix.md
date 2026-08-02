# TODO PDF 23: FontMetrics PostScript name fix

## Goal

Fix the `FontMetrics#postscript_name` method to prefer platform 3
(Windows, UTF-16BE) name records over platform 1 (Macintosh, MacRoman).
Currently the first matching name_id record is returned regardless of
platform, producing garbled names like "A r i a l M T".

## Why

The garbled PS name flows into the embedded font's `/BaseFont` entry,
producing invalid PDF font references. Font embedding tests must
tolerate the garbled name instead of asserting the correct value.

## Acceptance criteria

- [ ] `FontMetrics#parse_name_entry` iterates all records and prefers:
      1. platform_id=3 (Windows), encoding_id=1 (UCS-2)
      2. platform_id=3, any encoding
      3. platform_id=1 (Macintosh)
      4. platform_id=0 (Unicode)
- [ ] `Arial.ttf` produces `postscript_name == "ArialMT"`.
- [ ] `Helvetica.ttf` (if available) produces correct PS name.
- [ ] Spec: assert exact PS name for a known font.

## Files

- `lib/idml/text_engine/font_metrics.rb` (fix `parse_name_entry`)
- `spec/idml/text_engine/font_metrics_spec.rb`

## Design notes

- The name table has multiple records per name_id, one per
  platform/encoding/language combination. Windows (platform 3)
  records are the most reliable for PS names.
- Platform 1 (Macintosh) records use MacRoman encoding — the existing
  `decode_name_string` already handles this, but the selection logic
  doesn't prefer platform 3.

## Dependencies

- None.
