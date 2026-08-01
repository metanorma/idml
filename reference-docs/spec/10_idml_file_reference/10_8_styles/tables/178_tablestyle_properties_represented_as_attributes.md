| Name                                 | Type      | Req     | Description |
| -----------------------------------| --------| ------| -------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| BodyRegionCellStyle                | string    | no      | The cell style of the body (i.e., not header or footer) region. |
| BottomBorderStrokeColor            | string    | no      | The color, specified as a swatch (color, gradient, tint, or mixed ink), of the bottom border stroke. |
| BottomBorderStrokeGapColor         | string    | no      | The gap color, specified as a swatch (color, gradient, tint, or mixed ink), of the bottom border stroke. Note: Valid only when bottom border stroke type is not solid. |
| BottomBorderStrokeGapOverprint   | boolean   | no      | If true, the gap of the bottom border stroke will overprint. Note: Valid only when bottom border stroke type is not solid. |
| BottomBorderStrokeGapTint          | double    | no      | The tint (as a percentage) of the gap color of the bottom border stroke. (Range: 0 to 100) Note: Valid only when bottom border stroke type is not solid. |
| BottomBorderStrokeOverprint        | boolean   | no      | If true, the bottom border stroke will overprint. |
| BottomBorderStrokeTint             | double    | no      | The tint (as a percentage) of the bottom border stroke. (Range: 0 to 100) |
| BottomBorderStrokeType             | string    | no      | The stroke type of the bottom border. |
| BottomBorderStrokeWeight           | double    | no      | The stroke weight of the bottom border stroke. |
| ColumnFills Priority           | boolean   | no      | If true, hides alternating row fills. If false, hides alternating column fills. |
| EndColumnFillColor            | string    | no      | The FillColor, specified as a swatch (color, gradient, tint, or mixed ink), of columns in the second alternating fill group. Note: Valid when alternating fills are defined for table columns. |
| EndColumnFillCount            | int       | no      | The number of columns in the second alternating fills group. Note: Valid when alternating fills are defined for table columns. |
| EndColumnFillOverprint        | boolean   | no      | If true, the columns in the second alternating fills group will overprint. Note: Valid when alternating fills are defined for table columns. |
| EndColumnFillTint               | double    | no      | The tint (as a percentage) of the columns in the second alternating fills group. (Range: 0 to 100) Note: Valid when alternating fills are defined for table columns. |
| EndColumnLineStyle            | string    | no      | The stroke type of columns in the second alternating strokes group. |
| EndColumnStrokeColor          | string    | no      | The stroke color, specified as a swatch (color, gradient, tint, or mixed ink), of column borders in the second alternating column strokes group. Note: Valid when end column stroke count is 1 or greater. |
| EndColumnStrokeCount          | int       | no      | The number of columns in the second alternating column strokes group. |
| EndColumnStrokeGapColor       | string    | no      | The stroke gap color, specified as a swatch (color, gradient, tint, or mixed ink), of column borders in the second alternating column strokes group. Note: Valid when end column stroke count is 1 or greater. |
| EndColumnStrokeGapOverprint   | boolean   | no      | If true, the gap of the column border stroke in the second alternating column strokes group will overprint. Note: Valid when end column stroke count is 1 or greater. |
| EndColumnStrokeGapTint        | double    | no      | The tint (as a percentage) of the gap color of column borders in the second alternating column strokes group. (Range: 0 to 100) Note: Valid when end column stroke count is 1 or greater. |
| EndColumnStrokeOverprint      | boolean   | no      | If true, the column borders in the second alternating column strokes group will overprint. Note: Valid when end column stroke count is 1 or greater. |
| EndColumnStrokeTint           | double    | no      | The tint (as a percentage) of column borders in the second alternating column strokes group. (Range: 0 to 100) Note: Valid when end column stroke count is 1 or greater. |
| EndColumnStrokeWeight      | double    | no      | The stroke weight of column borders in the second alternating column strokes group. Note: Valid when end column stroke count is 1 or greater. |
| EndRowFillColor              | string    | no      | The FillColor, specified as a swatch (color, gradient, tint, or mixed ink), of rows in the second alternating fills group. Note: Valid when alternating fills are defined for table rows. |
| EndRowFillCount              | int       | no      | The number of rows in the second alternating fills group. Note: Valid when alternating fills are defined for table rows. |
| EndRowFillOverprint        | boolean   | no      | If true, the rows in the second alternating fills group will overprint. Note: Valid when alternating fills are defined for table rows. |
| EndRowFillTint               | double    | no      | The tint (as a percentage) of the rows in the second alternating fills group. (Range: 0 to 100) Note: Valid when alternating fills are defined for table rows. |
| EndRowStrokeColor            | string    | no      | The stroke color, specified as a swatch (color, gradient, tint, or mixed ink), of row borders in the second alternating row strokes group. Note: Valid when end row stroke count is 1 or greater. |
| EndRowStrokeCount            | int       | no      | The number of rows in the second alternating row strokes group. |
| EndRowStrokeGapColor       | string    | no      | The gap color, specified as a swatch (color, gradient, tint, or mixed ink), of row borders in the second alternating rows group. Note: Valid when end row stroke count is 1 or greater. |
| EndRowStrokeGapOverprint   | boolean   | no      | If true, the gap of the row borders in the second alternating rows group will overprint. Note: Valid when end row stroke count is 1 or greater. |
| EndRowStrokeGapTint        | double    | no      | The tint (as a percentage) of the gap color of rows in the second alternating strokes group. (Range: 0 to 100) Note: Valid when end row stroke count is 1 or greater and end row stroke type is not solid. |
| EndRowStrokeOverprint      | boolean   | no      | If true, the rows in the second alternating rows group will overprint. Note: Valid when end row stroke count is 1 or greater. |
| EndRowStrokeTint             | double    | no      | The tint (as a percentage) of the row borders in the second alternating strokes group. (Range: 0 to 100) Note: Valid when end row stroke count is 1 or greater. |
| EndRowStrokeType             | string    | no      | The stroke type of rows in the second alternating strokes group. |
| EndRowStrokeWeight         | double    | no      | The stroke weight of row borders in the second alternating row strokes group. Note: Valid when end row stroke count is 1 or greater. |
| FooterRegionCellStyle              | string    | no      | The cell style of the footer region. |
| FooterRegionSameAsBodyRegion       | boolean   | no      | If true, uses the cell style of the body region for the footer region. |
| HeaderRegionCellStyle              | string    | no      | The cell style of the header region. |
| HeaderRegionSameAsBodyRegion       | boolean   | no      | If true, use the cell style of the body region for the header region. |
| KeyboardShortcut                     |           | no      |  |
| LeftBorderStrokeColor              | string    | no      | The color, specified as a swatch (color, gradient, tint, or mixed ink), of the left border stroke. |
| LeftBorderStrokeGapColor           | string    | no      | The gap color, specified as a swatch (color, gradient, tint, or mixed ink), of the left border stroke. Note: Valid only when left border stroke type is not solid. |
| LeftBorderStrokeGapOverprint       | boolean   | no      | If true, the gap of the left border stroke will overprint. Note: Valid only when left border stroke type is not solid. |
| LeftBorderStrokeGapTint            | double    | no      | The tint (as a percentage) of the gap color of the left border stroke. (Range: 0 to 100) Note: Valid only when left border stroke type is not solid. |
| LeftBorderStrokeOverprint          | boolean   | no      | If true, the left border stroke will overprint. |
| LeftBorderStrokeTint               | double    | no      | The tint (as a percentage) of the left border stroke. (Range: 0 to 100) |
| LeftBorderStrokeType               | string    | no      | The stroke type of the left border. |
| LeftBorderStrokeWeight             | double    | no      | The stroke weight of the left border stroke. |
| LeftColumnRegionCellStyle          | string    | no      | The cell style of the left column region. |
| LeftColumnRegionSameAsBodyRegion   | boolean   | no      | If true, uses the cell style of the body region for the left column region. |
| Name                                 | string    | yes     | The name of the TableStyle. |
| RightBorderStrokeColor             | string    | no      | The color, specified as a swatch (color, gradient, tint, or mixed ink), of the right border stroke. |
| RightBorderStrokeGapColor          | string    | no      | The gap color, specified as a swatch (color, gradient, tint, or mixed ink), of the right border stroke. Note: Valid only when right border stroke type is not solid. |
| RightBorderStrokeGapOverprint    | boolean   | no      | If true, the gap color of the right border stroke will overprint. Note: Valid only when right border stroke type is not solid. |
| RightBorderStrokeGapTint           | double    | no      | The tint (as a percentage) of the gap color of the right border stroke. (Range: 0 to 100) Note: Valid only when right border stroke type is not solid. |
| RightBorderStrokeOverprint            | boolean   | no      | If true, the right border stroke will overprint. |
| RightBorderStrokeTint                 | double    | no      | The tint (as a percentage) of the right border stroke. (Range: 0 to 100) |
| RightBorderStrokeType                 | string    | no      | The stroke type of the right border. |
| RightBorderStrokeWeight               | double    | no      | The stroke weight of the right border stroke. |
| RightColumnRegionCellStyle            | string    | no      | The cell style of the right column region. |
| RightColumnRegionSameAsBodyRegion   | boolean   | no      | If true, uses the cell style of the body region for the right column region. |
| SkipFirstAlternatingFillColumns     | int       | no      | The number of columns on the left side of the table to skip before applying the column fill color. Note: Valid when alternating fills are defined for table columns. |
| SkipFirstAlternatingFillRows        | int       | no      | The number of body rows at the beginning of the table to skip before applying the row FillColor. Note: Valid when alternating fills are defined for table rows. For information on body rows, see body row count. |
| SkipFirstAlternatingStrokeColumns   | int       | no      | The number of columns on the left of the table in which to skip border stroke formatting. Note: Valid when start column stroke count is 1 or greater and/or end column stroke count is 1 or greater. |
| SkipFirstAlternatingStrokeRows      | int       | no      | The number of body rows at the beginning of the table in which to skip border stroke formatting. Note: Valid when start row stroke count is 1 or greater and/or end row stroke count is 1 or greater. For information on body rows, see body row count. |
| SkipLastAlternatingFillColumns      | int       | no      | The number columns on the right side of the table in which to not apply the column FillColor. Note: Valid when alternating fills are defined for table columns. |
| SkipLastAlternatingFillRows         | int       | no      | The number of body rows at the end of the table in which to not apply the row FillColor. Note: Valid when alternating fills are defined for table rows. For information on body rows, see body row count. |
| SkipLast Alternating StrokeColumns    | int       | no      | The number of columns on the right side of the table in which to skip border stroke formatting. Note: Valid when start column stroke count is 1 or greater and/or end column stroke count is 1 or greater. |
| SkipLast Alternating StrokeRows   | int       | no      | The number of body rows at the end of the table in which to skip border stroke formatting. Note: Valid when start row stroke count is 1 or greater and/or end row stroke count is 1 or greater. For information on body rows, see body row count. |
| SpaceAfter                          | double    | no      | The space below the table. |
| SpaceBefore                         | double    | no      | The space above the table. |
| StartColumnFillColor              | string    | no      | The FillColor, specified as a swatch (color, gradient, tint, or mixed ink), of columns in the first alternating fills group. Note: Valid when alternating fills are defined for table columns. |
| StartColumnFillCount              | int       | no      | The number of columns in the first alternating fills group. Note: Valid when alternating fills are defined for table columns. |
| StartColumnFillOverprint          | boolean   | no      | If true, the columns in the first alternating fills group will overprint. Note: Valid when alternating fills are defined for table columns. |
| StartColumnFillTint               | double    | no      | The tint (as a percentage) of the columns in the first alternating fills group. (Range: 0 to 100) Note: Valid when alternating fills are defined for table columns. |
| StartColumnStrokeColor            | string    | no      | The stroke color, specified as a swatch (color, gradient, tint, or mixed ink), of column borders in the first alternating column strokes group. |
| StartColumnStrokeCount            | int       | no      | The number of columns in the first alternating column strokes group. |
| StartColumnStrokeGapColor         | string    | no      | The stroke gap color, specified as a swatch (color, gradient, tint, or mixed ink), of column borders in the first alternating column strokes group. Note: Valid when start column stroke count is 1 or greater. |
| StartColumnStrokeGap Overprint   | boolean   | no      | If true, the gap of the column borders in the first alternating column strokes group will overprint. Note: Valid when start column stroke count is 1 or greater. |
| StartColumnStrokeGapTint          | double    | no      | The tint (as a percentage) of the gap color of column borders in the first alternating column strokes group. (Range: 0 to 100) Note: Valid when start column stroke count is 1 or greater. |
| StartColumnStrokeOverprint        | boolean   | no      | If true, the column borders in the first alternating column strokes group will overprint. Note: Valid when start column stroke count is 1 or greater. |
| StartColumnStrokeTint             | double    | no      | The tint (as a percentage) of column borders in the first alternating column strokes group. (Range: 0 to 100) Note: Valid when start column stroke count is 1 or greater. |
| StartColumnStrokeType             | string    | no      | The stroke type of columns in the first alternating strokes group. |
| StartColumnStrokeWeight      | double    | no      | The stroke weight of column borders in the first alternating column strokes group. Note: Valid when start column stroke count is 1 or greater. |
| StartRowFillColor              | string    | no      | The FillColor, specified as a swatch (color, gradient, tint, or mixed ink), of rows in the first alternating fills group. Note: Valid when alternating fills are defined for table rows. |
| StartRowFillCount              | int       | no      | The number of rows in the first alternating fills group. Note: Valid when alternating fills are defined for table rows. |
| StartRowFillOverprint        | boolean   | no      | If true, the rows in the first alternating fills group will overprint. Note: Valid when alternating fills are defined for table rows. |
| StartRowFillTint               | double    | no      | The tint (as a percentage) of the rows in the first alternating fills group. (Range: 0 to 100) Note: Valid when alternating fills are defined for table rows. |
| StartRowStrokeColor          | string    | no      | The color, specified as a swatch (color, gradient, tint, or mixed ink), of row borders in the first alternating row strokes group. Note: Valid when start row stroke count is 1 or greater. |
| StartRowStrokeCount          | int       | no      | The number of rows in the first alternating row strokes group. |
| StartRowStrokeGapColor       | string    | no      | The stroke gap color of row borders in the first alternating row strokes group, specified as a swatch (color, gradient, tint, or mixed ink). Note: Valid when start row stroke count is 1 or greater. |
| StartRowStrokeGapOverprint   | boolean   | no      | If true, the gap color of the row border stroke in the first alternating row strokes group will overprint. Note: Valid when start row stroke count is 1 or greater. |
| StartRowStrokeGapTint        | double    | no      | The tint (as a percentage) of the gap color of row borders in the first alternating rows group. (Range: 0 to 100) Note: Valid when start row stroke count is 1 or greater. |
| StartRowStrokeOverprint      | boolean   | no      | If true, the row borders in the first alternating row strokes group will overprint. Note: Valid when start row stroke count is 1 or greater. |
| StartRowStrokeTint           | double    | no      | The tint (as a percentage) of the borders in the first alternating row strokes group. (Range: 0 to 100) Note: Valid when start row stroke count is 1 or greater. |
| StartRowStrokeType           | string    | no      | The stroke type of rows in the first alternating strokes group. |
| StartRowStrokeWeight         | double    | no      | The stroke weight of row borders in the first alternating row strokes group. Note: Valid when start row stroke count is 1 or greater. |
| StrokeOrder                     | StrokeOrderTypes_ EnumValue   | no      | The order in which to display row and column strokes at corners.Can be RowOnTop (Places row strokes in front of column strokes), Column OnTop (Places column strokes in front of row strokes), BestJoins (Places row strokes in front of column strokes when row and column strokes are different colors; joins striped strokes and connects crossing points), or Indesign2Compatibility (Places row strokes in front when row and column strokes are different colors; joins striped strokes only at points where strokes cross in a T-shape). |
| TopBorderStrokeColor          | string                        | no      | The color, specified as a swatch (color, gradient, tint, or mixed ink), of the table's top border stroke. |
| TopBorderStrokeGapColor       | string                        | no      | The gap color, specified as a swatch (color, gradient, tint, or mixed ink), of the table's top border stroke. Note: Valid only when top border stroke type is not solid. |
| TopBorderStrokeGapOverprint   | boolean                       | no      | If true, the gap of the top border stroke will overprint. Note: Valid only when top border stroke type is not solid. |
| TopBorderStrokeGapTint        | double                        | no      | The tint (as a percentage) of the gap color of the table's top border stroke. (Range: 0 to 100) Note: Valid only when top border stroke type is not solid. |
| TopBorderStrokeOverprint      | boolean                       | no      | If true, the top border strokes will overprint. |
| TopBorderStrokeTint           | double                        | no      | The tint (as a percentage) of the table's top border stroke. (Range: 0 to 100) |
| TopBorderStrokeType           | string                        | no      | The stroke type of the top border. |
| TopBorderStrokeWeight         | double                        | no      | The stroke weight of the table's top border stroke. |
