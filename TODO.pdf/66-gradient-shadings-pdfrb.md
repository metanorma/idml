# TODO PDF 66: Real PDF gradient shadings via pdfrb 0.4.0

## Status: DONE

## What was implemented

RectangleRenderer now uses pdfrb's `Shadings#add_axial` +
`Canvas#fill_shading` for gradient fills instead of the discrete
32-rectangle approximation. Produces mathematically smooth gradients
with zero banding.

When FillColor is a Gradient reference:
1. Look up the Gradient element from Resources/Graphic.xml
2. Resolve each GradientStop's color via ColorResolver
3. Create a pdfrb axial shading: `add_axial(from:, to:, stops:)`
4. Draw the rectangle path and fill with the shading

## Acceptance criteria

- [x] RectangleRenderer detects Gradient/* fill colors
- [x] Creates pdfrb axial shading with resolved color stops
- [x] Uses canvas.fill_shading instead of discrete rectangles
- [x] Falls back to solid color for non-gradient fills
- [x] All tests pass
