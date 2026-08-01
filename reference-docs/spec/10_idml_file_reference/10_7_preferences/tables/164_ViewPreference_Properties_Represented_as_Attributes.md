| Name | Type | Req | Description |
| ------------------------------ | ----------------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CursorKeyIncrement | double | no | The distance to move a specified object when an arrow key is pressed. (Range: 0.001 to 100.) |
| GuideSnaptoZone | int | no | The range (in pixels) within which an object snaps to guides. (Range: 1 to 36) Note: Snapping occurs only when guides are shown. |
| HorizontalCustomPoints | double | no | The distance (in points) between major tick marks on the horizontal ruler. (Range: 4 to 256) Valid only when horizontal measurement units is custom. |
| HorizontalMeasurementUnits | MeasurementUnits_EnumValue | no | The measurement unit for the horizontal ruler and other horizontally-measured spaces such as grid columns, horizontal offsets, column gutters, or others. Can be Points, Picas, Inches, InchesDecimal, Millimeters, Centimeters, Ciceros, Q, Ha, AmericanPoints, Custom, Agates, U, Bai, or Mil. |

| Name | Type | Req | Description |
| ------------------------------- | ----------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| LineMeasurementUnits | MeasurementUnits_EnumValue | no | Can be Points, Picas, Inches, InchesDecimal, Millimeters, Centimeters, Ciceros, Q, Ha, AmericanPoints, Custom, Agates, U, Bai, or Mil. |
| PointsPerInch | double | no | The number of points per inch, typically 72. (Range: 60 to 80) |
| PrintDialogMeasurementUnits | MeasurementUnits_EnumValue | no | The measurement units used in the Print dialog box. Can be Points, Picas, Inches, InchesDecimal, Millimeters, Centimeters, Ciceros, Q, Ha, AmericanPoints, Custom, Agates, U, Bai, or Mil. |
| RulerOrigin | RulerOrigin_EnumValue | no | The default zero point at the intersection of the vertical and horizontal rulers and the scope of the horizontal ruler. Can be SpreadOrigin, PageOrigin, SpineOrigin. |
| ShowFrameEdges | boolean | no | If true, displays borders of unselected frames and the diagonal lines in empty unselected frames. |
| ShowNotes | boolean | no | If true, notes are displayed. |
| ShowRulers | boolean | no | If true, displays the horizontal and vertical rulers. |
| TextSizeMeasurementUnits | MeasurementUnits_EnumValue | no | The measurement units used for text size. Can be Points, Picas, Inches, InchesDecimal, Millimeters, Centimeters, Ciceros, Q, Ha, AmericanPoints, Custom, Agates, U, Bai, or Mil. |
| TypographicMeasurementUnits | MeasurementUnits_EnumValue | no | The measurement units used for type formatting properties (other than text size). Can be Points, Picas, Inches, InchesDecimal, Millimeters, Centimeters, Ciceros, Q, Ha, AmericanPoints, Custom, Agates, U, Bai, or Mil. |
| VerticalCustomPoints | double | no | The distance (in points) between major tick marks on the vertical ruler. (Range: 4 to 256) Valid only when VerticalMeasurementUnits is custom. |
| VerticalMeasurementUnits | MeasurementUnits_EnumValue | no | The measurement unit for the vertical ruler and other vertically-measured spaces such as grid rows, vertical offsets, row heights, or others. Can be Points, Picas, Inches, InchesDecimal, Millimeters, Centimeters, Ciceros, Q, Ha, AmericanPoints, Custom, Agates, U, Bai, or Mil. |
