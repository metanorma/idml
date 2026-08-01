| Name | Type | Req | Description |
| ---------------------- | --------------------------------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContourPathName | string | no | The name of the alpha channel or Photoshop path to use for the contour option. Valid only when the contour options is photoshop path or alpha channel. |
| ContourType | ContourOptionsTypes_EnumValue | no | The contour type. Can be BoundingBox, PhotoshopPath, DetectEdges, AlphaChannel, GraphicFrame, or SameAsClipping. |
| IncludeInsideEdges | boolean | no | If true, creates interior clipping paths within the surrounding clipping path. Note: Valid only when clipping type is AlphaChannel or DetectEdges. |
