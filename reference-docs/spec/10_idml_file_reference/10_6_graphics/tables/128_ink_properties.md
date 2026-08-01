| Name               | Type                   | Req     | Description |
| ------------------ | ---------------------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| AliasInkName       | string                 | no      | Areference to the unique ID ( Self attribute) of the alias ink. For more on ink aliases, refer to the InDesign documentation. |
| Angle              | double                 | no      | The screen angle of the ink. (Range: 0 to 360) |
| ConvertToProcess   | boolean                | no      | Converts spot colors to process inks (for print- ing or export). Setting this value to true changes the printing or output values of the colors; it does not affect the definition of the spot colors in the document. |
| Frequency          | double                 | no      | The screen frequency of the ink. (Range: 1 to 500) |
| InkType            | InkTypes_Enum Value   | no      | The trapping type of the ink. Can be Normal, Opaque, Transparent, OpaqueIgnore. |
| Name               | string                 | yes     | The name of the ink. |
| NeutralDensity     | double                 | no      | The neutral density of the ink used for trapping. (Range: 0.001 to 10.0) |
| PrintInk           | boolean                | no      | If true (the default), prints the ink. |
| TrapOrder          | int                    | no      | The place of the ink in the trapping sequence. |
