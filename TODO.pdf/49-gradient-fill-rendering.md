# TODO PDF 49: Gradient fill rendering

## Goal

Render gradient fills on page items. IDML supports linear and radial
gradients via GradientStop entries in Resources/Graphic.xml.

## Acceptance criteria

- [ ] PdfWriter supports shading patterns (Type 2/3).
- [ ] GradientResolver maps Gradient + GradientStop entries to PDF shading.
- [ ] RectangleRenderer/PolygonRenderer emit gradient fill when FillColor
      references a Gradient.
- [ ] Linear and radial gradient types supported.
- [ ] Spec: render a Rectangle with linear gradient, verify shading dictionary.

## Dependencies

- TODO 22 (ColorResolver).
- TODO 30 (shape geometry).
