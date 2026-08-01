| Name                               | Type                     | Req     | Description |
| ---------------------------        | ---------                | ------- | -------------------------------------------------------------------- |
| BottomInset                        | double                   | no      | The bottom inset of the cell. |
| ClipContentToCell                  | boolean                  | no      | If true, clips the cell's content to width and height of the cell. |
| DiagonalLineIn Front              | boolean                  | no      | If true, draws the diagonal line in front of cell contents. |
| DiagonalLine StrokeColor          | string                   | no      | The diagonal line color, specified as a swatch. |
| DiagonalLine StrokeGapColor       | string                   | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the diagonal line stroke. Note: Not valid when diagonal line stroke type is solid. |
| DiagonalLine StrokeGap Overprint | boolean                  | no      | If true, the gap of the diagonal line stroke will overprint. Note: Not valid when diagonal line stroke type is solid. |
| DiagonalLine StrokeGapTint        | double                   | no      | The tint (as a percentage) of the diagonal line stroke gap color. Note: Not valid when diagonal line stroke type is solid. |
| DiagonalLine StrokeOverprint      | boolean                  | no      | If true, the diagonal line stroke will overprint. |
| DiagonalLine StrokeTint           | double                   | no      | The diagonal line tint (as a percentage). (Range: 0 to 100) |
| DiagonalLine StrokeType           | string                   | no      | The stroke type of the diagonal line(s). |
| DiagonalLine StrokeWeight         | double                   | no      | The diagonal line stroke weight. |
| FillColor                          | string                   | no      | The swatch (color, gradient, tint, or mixed ink) applied to the fill of the Column. |
| FillTint                           | double                   | no      | The tint (as a percentage) of the fill of the Col- umn. |
| FirstBaseline Offset              | FirstBaseline_ EnumValue | no      | The distance between the baseline of the text and the top inset of the cell. Can be Ascent Offset (The tallest character in the font falls below the top inset of the object), CapHeight (The tops of upper case letters touch the top inset of the object), LeadingOffset (The text leading value defines the distance between the baseline of the text and the top inset of the object), EmboxHeight (The text em box height is the distance between the baseline of the text and the top inset of the object), XHeight (The tops of lower case letters touch the top inset of the object), or FixedHeight (Uses the value specified for minimum first baseline offset as the distance between the baseline of the text and the top inset of the object). |
| LeftInset                          | double                   | no      | The left inset of the cell. |
| MinimumFirst BaselineOffset       | double                   | no      | The space between the baseline of the text and the top inset of the frame or cell. |
| Name                               | string                   | yes     | The name of the column. |
| OverprintFill                      | boolean                  | no      | If true, the fill of the Column will overprint. |
| ParagraphSpacing Limit            | double                   | no      | The maximum space that can be added between paragraphs in a cell. Note: Valid only when ver- tical justification is justified. |
| RightInset                         | double                   | no      | The right inset of the cell. |
| RotationAngle             | double                               | no      | The rotation angle (in degrees) of the cell, speci- fied as one of the following values: 0, 90, 180, or 270. |
| SingleColumnWidth         | double                               | no      | The width of a single column. |
| TopInset                  | double                               | no      | The top inset of the cell. |
| TopLeftDiagonal Line     | boolean                              | no      | If true, draws a diagonal line starting from the top left. |
| TopRightDiagonal Line    | boolean                              | no      | If true, draws a diagonal line starting from the top right. |
| Vertical Justification   | Vertical Justification_ EnumValue   | no      | The vertical alignment of cell. Can be Top Align (Text is aligned at the top of the object), CenterAlign (Text is center aligned vertically in the object), BottomAlign (Text is aligned at the bottom of the object), or JustifyAlign (Lines of text are evenly distributed vertically between the top and bottom of the object). |
| WritingDirection          | boolean                              | no      | The direction of the text in the cell. |
