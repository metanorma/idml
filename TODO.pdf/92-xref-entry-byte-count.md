# TODO PDF 92: XRef entry byte-count compliance (21 vs 20 bytes)

## Status: IDENTIFIED — pdfrb upstream bug

## Problem

PDF spec §7.5.4 requires each cross-reference entry to be exactly
**20 bytes** including the 2-character end-of-line marker. Three
valid EOL formats:

- `nnnnnnnnnn ggggg n\r\n` (CRLF)
- `nnnnnnnnnn ggggg n \n` (space + LF)
- `nnnnnnnnnn ggggg n \r` (space + CR)

pdfrb's xref writer emits `nnnnnnnnnn ggggg n \r\n` — **21 bytes**
because of the extra space between the status character and the
`\r\n`. Strict PDF readers (MuPDF, `mutool`) reject this:

```
format error: expected trailer marker
warning: trying to repair broken xref
warning: repairing PDF document
```

Lenient readers (`pdftk`, Apple Preview, Chrome) tolerate it.

## Verification

```python
# In a generated PDF:
entry = b'0000000015 00000 n \r\n'  # 21 bytes
assert len(entry) == 21  # BUG: should be 20
```

Compare with InDesign's output (compliant):
```python
entry = b'0000000015 00000 n \r\n'  # should be 20 bytes
# InDesign uses object streams + xref stream, so no traditional
# xref table in the test fixture's pages.pdf
```

## Fix

In pdfrb's writer, remove the space before `\r\n` in each xref
entry. The format should be:
```ruby
"%010d %05d %s\r\n" % [offset, generation, status]
```
Not:
```ruby
"%010d %05d %s \r\n" % [offset, generation, status]
```

## Impact

Without the fix, strict validators flag our PDFs as broken. The
PDFs still open in most readers because the xref can be rebuilt
from the object scan, but:

- `mutool` prints repair warnings.
- veraPDF may reject the file.
- PDF/A validators may flag non-compliance.

## Workaround

Use `compress: true` — pdfrb then uses an XRef stream
(`writer.use_xref_stream: true`) instead of a traditional xref
table, bypassing the byte-counting issue entirely.

## Acceptance criteria

- [ ] pdfrb xref writer emits 20-byte entries.
- [ ] `mutool info` reports no repair warnings.
- [ ] PDF/A validators accept the output without xref warnings.
