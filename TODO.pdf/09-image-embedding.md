# TODO PDF 09: Image embedding

## Goal

Resolve IDML image links and embed them as PDF XObject images.

## Acceptance criteria

- [ ] `Idml::Render::Image` resolves the `href` attribute on Image
      page items to a file path.
- [ ] Supports JPEG and PNG (the two most common IDML image formats).
- [ ] Creates a PDF image XObject with the correct color space
      (DeviceRGB for color, DeviceGray for grayscale).
- [ ] Positions the image using the page item's GeometricBounds
      and ItemTransform.
- [ ] Spec: embed a known JPEG into a PDF page.

## Files

- `lib/idml/render/image.rb`
- `spec/idml/render/image_spec.rb`

## Design notes

- IDML stores image links relative to the IDML file's location.
  The Package doesn't contain the images themselves (unless it's
  an InDesign Package, which is a different ZIP structure).
- For now, accept the image path as-is. If the file doesn't exist,
  skip the image (don't error).

## Dependencies

- pdfrb XObject support (or raw PDF stream writing).
- Typed Spread/Image element classes (when added to SpreadObject).
