# TODO PDF 109: DRY color tint application (ColorHelper vs CharacterStyle vs ParagraphRules)

## Status: DONE — `ColorHelper.apply_tint(color, tint)` is the single
canonical tint helper. CharacterStyle and ParagraphRules both delegate
to it. 7 new specs cover nil tint, tint >= 1.0, RGB/CMYK scaling,
tint 0.0, unknown models, nil input.

## Problem

Color tint (scaling a color's components toward zero) is implemented
in three places with slightly different shapes:

1. `Render::CharacterStyle.apply_tint(color, tint)` — used for
   text fill color.
2. `Render::ParagraphRules.scale_color(color, tint_value)` — used
   for paragraph rule colors.
3. (Implicit) `Render::ColorResolver` resolves tints on its own
   when reading ColorValue, before returning the color hash.

The first two are essentially the same logic with different method
names. The third means a `ColorResolver.resolve` result might or
might not have tint already applied — callers can't tell.

## What needs to happen

1. Pick one canonical tint helper. Either:
   - Move to `ColorHelper.apply_tint(color, tint)`, or
   - Create `Render::ColorTint.apply(color, tint)`.
2. CharacterStyle and ParagraphRules call the canonical helper.
3. ColorResolver documents whether it applies tint or returns raw
   colors (today it appears to apply tint internally).

## Acceptance criteria

- [ ] Single tint helper in one place.
- [ ] CharacterStyle and ParagraphRules both delegate to it.
- [ ] ColorResolver's tint behavior is documented.
- [ ] Spec coverage for tint 0.0, 0.5, 1.0 on RGB and CMYK colors.

## Dependencies

- None — pure refactor.
