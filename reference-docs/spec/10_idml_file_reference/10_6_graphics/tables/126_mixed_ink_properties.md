| Name                          | Type                                                         | Req     | Description |
| ----------------------------- | ------------------------------------------------------------ | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BaseColor                     | string                                                       | yes     | The mixed ink group that a mixed ink swatch is based on. Use n for a standalone mixed ink. |
| InkList                       | list of ink references as a spaceseparated string           | yes     | The component inks. Each ink is represented by its unique ID (the value of its Self attribute). |
| InkNameList                   | list of ink names as a space separated string               | no      | The names of the component inks. |
| InkPercentages                | list of doubles as a space separated string                 | no      | The array of tint percentages for inks in the ink list (in the same order as the inks appear in the the InkList attribute). Note: Specify a value for each ink. |
| MixedInkSpotColorList       | list of spot color references as a space separated string   | no      | The spot colors used in the mixed ink. Each spot color is represented by its unique ID (the value of its Self attribute). |
| MixedInkSpotColorNameList   | list of color names as a space separated string             | no      | The names of the spot colors used in the mixed ink. |
| Model                         | ColorModel_Enum Value                                       | no      | The color model. Use Mixedinkmodel . |
| Space                         | ColorSpace_Enum Value                                       | no      | The color space. Use MixedInk . |
