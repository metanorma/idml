| Name              | Type      | Req     | Description |
| ----------------- | --------- | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ColorEditable     | boolean   | no      | If true, the swatch is editable. |
| ColorRemovable    | boolean   | no      | If true, the swatch can be deleted. If false, the swatch is used in an imported graphic file in the document. |
| Name              | string    | yes     | The name of the swatch. |
| SwatchCreatorID   | int       | no      | The unique ID of the creator (or vendor) of the swatch. SwatchCreatorID is useful when the swatch added is from a color library that InDesign shipped with. The SwatchCreatorID allows InDesign to load the proper color/swatch library quickly. If it is an user defined swatch, it simply defaults to the InDesign SwatchCreatorID. |
| Visible           | boolean   | no      | If true, the swatch is visible in the user interface. Unnamed process color and gradient swatches can have this attribute set to false. All named swatches should have this flag set to true. |
