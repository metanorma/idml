| Name                    | Type                                   | Req     | Description |
| ----------------------- | -------------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| BlackColorThreshold   | double                                 | no      | The minimum amount (as a percentage) of black ink required before the black width setting is applied. (Range: 0 to 100) |
| BlackDensity            | double                                 | no      | The neutral density value at or above which an ink is considered black. (Range: .001 to 10) |
| BlackWidth              | double                                 | no      | The black width. (Range: 0.0 to 8.0) |
| ColorReduction          | double                                 | no      | The degree (as a percentage) to which components from abutting colors are used to reduce the trap color. (Range: 0 to 100) Note: 0% creates a trap whose neutral density is equal to the neutral density of the darker color. |
| DefaultTrapWidth        | double                                 | no      | The default width for trapping all colors except those involving solid black. (Range: 0.0 to 8.0) |
| ImagePlacement          | TrapImagePlacementTypes_EnumValue           | no      | The trap placement between vector objects and bitmap images. Can be CenterEdges, Choke, ImageNeutralDensity, or ImagesOverSpread. |
| ImagesToImages          | boolean                                | no      | If true, turns on trapping along the boundary of overlapping or abutting bitmap images. |
| InternalImages          | boolean                                | no      | If true, turns on trapping among colors within individual bitmap images. |
| Name                     | string                                    | no      | The name of the TrapPreset. |
| ObjectsToImages          | boolean                                | no      | If true, ensures that vector objects overlap bitmap images. |
| OneBitImages             | boolean                                | no      | If true, ensures that one-bit images trap to abutting objects. |
| SlidingTrapThreshold   | double                                 | no      | The difference (as a percentage) between the neutral densities of abutting colors at which the trap is moved from the darker side of a color edge toward the centerline. (Range: 0 to 100) |
| StepThreshold            | double                                 | no      | The amount (as a percentage) that components of abutting colors must vary before a trap is created. (Range: 1 to 100) |
| TrapEnd                  | TrapEndTypes_EnumValue                   | no      | The shape to use at the intersection of three-way traps. Can be MiterTrapEnds or OverlapTrapEnds. |
| TrapJoin                 | EndJoin_EnumValue                        | no      | The join type of the TrapPreset. Can be MiterEndJoin, RoundEndJoin, or BevelEndJoin. |
