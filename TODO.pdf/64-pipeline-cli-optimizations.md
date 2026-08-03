# TODO PDF 64: Pipeline optimizations and CLI enhancements

## Status: DONE

## What was implemented

1. **Pipeline SpreadRenderer caching**: `render_spread_pages` creates
   one SpreadRenderer per spread (was one per page). The renderer is
   stateless and can be reused across pages within a spread.

2. **CLI --verbose / -v flag**: Prints progress during rendering:
   - Input and output paths
   - Spread count
   - Goes to stderr (doesn't interfere with stdout piping)

3. **render_options extraction**: CLI's render_options hash extracted
   as a method (DRY).

## Acceptance criteria

- [x] SpreadRenderer created once per spread (not per page)
- [x] CLI --verbose flag prints progress to stderr
- [x] All tests pass
