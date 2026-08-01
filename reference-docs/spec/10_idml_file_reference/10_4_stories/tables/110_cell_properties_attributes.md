| Name                             | Type      | Req     | Description |
| -------------------------------- | --------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AppliedCellStyle                 | string    | no      | The cell style applied to the cell. |
| AppliedCellStyle Priority       | int       | no      |  |
| BottomEdgeStrokeColor          | string    | no      | The swatch (color, gradient, tint, or mixed ink) applied to the bottom edge border stroke. |
| BottomEdgeStrokeGapColor       | string    | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the bottom edge border stroke. Note: Not valid when bottom edge stroke type is solid. |
| BottomEdgeStrokeGapOverprint   | boolean   | no      | If true, the gap color of the bottom edge border stroke will overprint. Note: Not valid when bot- tom edge stroke type is solid. |
| BottomEdgeStrokeGapTint        | double    | no      | The tint (as a percentage) of the bottom edge border stroke gap color. (Range: 0 to 100) Note: Not valid when bottom edge stroke type is solid. |
| BottomEdgeStrokeOverprint      | boolean   | no      | If true, the bottom edge border stroke will over- print. |
| BottomEdgeStrokePriority       | int       | no      | The priority of a stroke determines the order in which it will be drawn, relative to the other strokes on the cell. Higher values equal higher priority. |
| BottomEdgeStrokeTint           | double    | no      | The tint (as a percentage) of the bottom edge border stroke. |
| BottomEdgeStrokeType           | string    | no      | The stroke type of the bottom edge. |
| BottomEdgeStrokeWeight         | double    | no      | The stroke weight of the bottom edge border stroke. |
| BottomInset                          | double                     | no      | The bottom inset of the cell. |
| ClipContentToCell                    | boolean                    | no      | If true, clips the cell's content to width and height of the cell. |
| ColumnSpan                           | int                        | no      | The number of columns that the cell spans. |
| DiagonalLineIn Front                | boolean                    | no      | If true, draws the diagonal line in front of cell contents. |
| DiagonalLine StrokeColor            | string                     | no      | The diagonal line color, specified as a swatch. |
| DiagonalLine StrokeGapColor         | string                     | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the diagonal line stroke. Note: Not valid when diagonal line stroke type is solid. |
| DiagonalLine StrokeGap Overprint   | boolean                    | no      | If true, the stroke gap of the diagonal line will overprint. Note: Not valid when diagonal line stroke type is solid. |
| DiagonalLine StrokeGapTint          | double                     | no      | The tint (as a percentage) of the diagonal line stroke gap color. Note: Not valid when diagonal line stroke type is solid. |
| DiagonalLine StrokeOverprint        | boolean                    | no      | If true, the diagonal line stroke will overprint. |
| DiagonalLine StrokeTint             | double                     | no      | The diagonal line tint (as a percentage). (Range: 0 to 100) |
| DiagonalLine StrokeType             | string                     | no      | The stroke type of the diagonal line(s). |
| DiagonalLine StrokeWeight           | double                     | no      | The diagonal line stroke weight. |
| FillColor                            | string                     | no      | The swatch (color, gradient, tint, or mixed ink) applied to the fill of the cell. |
| FillTint                             | double                     | no      | The tint (as a percentage) of the fill of the cell. |
| FirstBaseline Offset                | FirstBaseline_ EnumValue   | no      | The distance between the baseline of the text and the top inset of the cell. Can be Ascent Offset (The tallest character in the font falls below the top inset of the object), CapHeight (The tops of upper case letters touch the top inset of the object), LeadingOffset (The text leading value defines the distance between the baseline of the text and the top inset of the object), EmboxHeight (The text em box height is the distance between the baseline of the text and the top inset of the object), XHeight (The tops of lower case letters touch the top inset of the object), or FixedHeight (Uses the value specified for minimum first baseline offset as the distance between the baseline of the text and the top inset of the object). |
| InnerColumn StrokeColor             | string                     | no      | The color, specified as a swatch, of the inner col- umn border stroke. |
| InnerColumn StrokeGapColor         | string    | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the inner column border stroke. Note: Not valid when inner column stroke type is solid. |
| InnerColumn StrokeGap Overprint   | boolean   | no      | If true, the gap color of the inner column bor- der stroke will overprint. Note: Not valid when inner column stroke type is solid. |
| InnerColumn StrokeGapTint          | double    | no      | The tint (as a percentage) of the inner column border stroke gap color. (Range: 0 to 100) Note: Not valid when inner column stroke type is solid. |
| InnerColumn StrokeOverprint        | boolean   | no      | If true, the inner column border stroke will overprint. |
| InnerColumn StrokeTint             | double    | no      | The tint (as a percentage) of the inner column border stroke. (Range: 0 to 100) |
| InnerColumn StrokeType             | string    | no      | The stroke type of the inner column. |
| InnerColumn StrokeWeight           | double    | no      | The stroke weight of the inner column border stroke. |
| InnerRowStroke Color               | string    | no      | The color, specified as a swatch, of the inner row border stroke. |
| InnerRowStroke GapColor            | string    | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the inner row border stroke. Note: Not valid when inner row stroke type is solid. |
| InnerRowStroke GapOverprint        | boolean   | no      | If true, the gap color of the inner row bor- der stroke will overprint. Note: Not valid when inner row stroke type is solid. |
| InnerRowStroke GapTint             | double    | no      | The tint (as a percentage) of the inner row border stroke gap color. (Range: 0 to 100) Note: Not valid when inner row stroke type is solid. |
| InnerRowStroke Overprint           | boolean   | no      | If true, the inner row border stroke will over- print. |
| InnerRowStroke Tint                | double    | no      | The tint (as a percentage) of the inner row border stroke. (Range: 0 to 100) |
| InnerRowStroke Type                | string    | no      | The stroke type of the inner row. |
| InnerRowStroke Weight              | double    | no      | The stroke weight of the inner row border strokes. |
| LeftEdgeStrokeColor               | string    | no      | The swatch (color, gradient, tint, or mixed ink) applied to the left edge border stroke. |
| LeftEdgeStrokeGapColor            | string    | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the left edge border stroke. Note: Not valid when left edge stroke type is solid. |
| LeftEdgeStrokeGapOverprint    | boolean                            | no      | If true, the gap color of the left edge border stroke will overprint. Note: Not valid when left edge stroke type is solid. |
| LeftEdgeStrokeGapTint         | double                             | no      | The tint (as a percentage) of the left edge border stroke gap color. (Range: 0 to 100) Note: Not valid when left edge stroke type is solid. |
| LeftEdgeStrokeOverprint       | boolean                            | no      | If true, the left edge border stroke will overprint. |
| LeftEdgeStrokePriority        | int                                | no      | The priority of a stroke determines the order in which it will be drawn, relative to the other strokes on the cell. Higher values equal higher priority. |
| LeftEdgeStrokeTint            | double                             | no      | The tint (as a percentage) of the left edge border stroke. (Range: 0 to 100) |
| LeftEdgeStrokeType            | string                             | no      | The stroke type of the left edge. |
| LeftEdgeStrokeWeight          | double                             | no      | The stroke weight of the left edge border stroke. |
| LeftInset                       | double                             | no      | The left inset of the cell. |
| MinimumFirst BaselineOffset    | double                             | no      | The space between the baseline of the text and the top inset of the frame or cell. |
| OverprintFill                   | boolean                            | no      | If true, the fill of the cell will overprint. |
| ParagraphSpacing Limit         | double                             | no      | The maximum space that can be added between paragraphs in a cell. Note: Valid only when ver- tical justification is justified. |
| RightEdgeStrokeColor          | string                             | no      | The color, specified as a swatch, of the right edge border stroke. |
| RightEdgeStrokeGapColor       | string                             | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the right edge border stroke. Note: Not valid when right edge stroke type is solid. |
| RightEdgeStrokeGapOverprint   | boolean      | no      | If true, the gap color of the right edge border stroke will overprint. Note: Not valid when right edge stroke type is solid. |
| RightEdgeStrokeGapTint        | double      | no      | The tint (as a percentage) of the right edge bor- der stroke gap color. (Range: 0 to 100) Note: Not valid when right edge stroke type is solid. |
| RightEdgeStrokeOverprint      | boolean      | no      | If true, the right edge border stroke will over- print. |
| RightEdgeStrokePriority       | int        | no      | The priority of a stroke determines the order in which it will be drawn, relative to the other strokes on the cell. Higher values equal higher priority. |
| RightEdgeStrokeTint           | double      | no      | The tint (as a percentage) of the right edge bor- der stroke. (Range: 0 to 100) |
| RightEdgeStrokeType           | string      | no      | The stroke type of the right edge. |
| RightEdgeStrokeWeight         | double      | no      | The stroke weight of the right edge border stroke. |
| RightInset                      | double                             | no      | The right inset of the cell. |
| RotationAngle                   | double                             | no      | The rotation angle (in degrees) of the cell, speci- fied as one of the following values: 0, 90, 180, or 270. |
| RowSpan                         | int                                | no      | The number of rows that the cell spans. |
| TopEdgeStrokeColor            | string                             | no      | The swatch (color, gradient, tint, or mixed ink) applied to the top edge border stroke. |
| TopEdgeStrokeGapColor         | string                             | no      | The swatch (color, gradient, tint, or mixed ink) applied to the gap of the top edge border stroke. Note: Not valid when top edge stroke type is solid. |
| TopEdgeStrokeGapOverprint     | boolean      | no      | If true, the gap color of the top edge border stroke will overprint. Note: Not valid when top edge stroke type is solid. |
| TopEdgeStrokeGapTint          | double      | no      | The tint (as a percentage) of the top edge border stroke gap color. (Range: 0 to 100) Note: Not valid when top edge stroke type is solid. |
| TopEdgeStrokeOverprint        | boolean      | no      | If true, the top edge border stroke will overprint. |
| TopEdgeStrokePriority         | int        | no      | The priority of a stroke determines the order in which it will be drawn, relative to the other strokes on the cell. Higher values equal higher priority. |
| TopEdgeStrokeTint               | double                             | no      | The tint (as a percentage) of the top edge border stroke. (Range: 0 to 100) |
| TopEdgeStrokeType               | string                             | no      | The stroke type of the top edge. |
| TopEdgeStrokeWeight           | double                             | no      | The stroke weight of the top edge border stroke. |
| TopInset                        | double                             | no      | The top inset of the cell. |
| TopLeftDiagonal Line           | boolean                            | no      | If true, draws a diagonal line starting from the top left. |
| TopRightDiagonal Line          | boolean                            | no      | If true, draws a diagonal line starting from the top right. |
| Vertical Justification         | Vertical Justification_ EnumValue | no      | The vertical alignment of cell. Can be Top Align (Text is aligned at the top of the object), CenterAlign (Text is center aligned vertically in the object), BottomAlign (Text is aligned at the bottom of the object), or JustifyAlign (Lines of text are evenly distributed vertically between the top and bottom of the object). |
| WritingDirection                | boolean                            | no      | The direction of the text in the cell. |
