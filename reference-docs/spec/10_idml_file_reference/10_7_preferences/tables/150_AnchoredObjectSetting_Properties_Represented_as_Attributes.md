| Name | Type | Req | Description |
| ---------------------------- | ------------------------------------ | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AnchorPoint | AnchorPoint_EnumValue | no | The point in the anchored object to position. Can be TopLeftAnchor, TopCenterAnchor, TopRightAnchor, LeftCenterAnchor, CenterAnchor, RightCenterAnchor, BottomLeftAnchor, BottomCenterAnchor, or BottomRightAnchor. |
| AnchorSpaceAbove | double | no | The space above an above-line anchored object. |
| AnchorXoffset | double | no | The horizontal (x) offset of the anchored object. |
| AnchorYoffset | double | no | The vertical (y) offset of the anchored object. |
| AnchoredPosition | AnchorPosition_EnumValue | no | The position of the anchored object relative to the anchor. Can be InlinePosition, AboveLine, Anchored. |
| HorizontalAlignment | HorizontalAlignment_EnumValue | no | When anchored position is above line, the position of the anchored object is relative to the text area. When anchored position is custom, the horizontal alignment of the anchored object is set by the horizontal reference point. Note: Not valid when anchored position is InlinePosition. Can be RightAlign, LeftAlign, CenterAlign, TextAlign |
| HorizontalReferencePoint | AnchoredRelativeTo_EnumValue | no | The horizontal reference point on the page. Can be ColumnEdge, TextFrame, PageMargins, PageEdge, AnchorLocation |
| LockPosition | boolean | no | If true, prevents manual positioning of the anchored object. |
| PinPosition | boolean | no | If true, pins the position of the anchored object within the TextFrame top and bottom. |
| SpineRelative | boolean | no | If true, the position of the anchored object is relative to the binding spine of the page or spread. |
| VerticalAlignment | VerticalAlignment_EnumValue | no | The vertical alignment of the anchored object reference point with the vertical reference point on the page. Can be TopAlign, BottomAlign, or CenterAlign. |
| VerticalReferencePoint | VerticallyRelativeTo_EnumValue | no | The vertical reference point on the page. Can be ColumnEdge, TextFrame, PageMargins, PageEdge, LineBaseline, LineXheight, LineAscent, Capheight, TopOfLeading. |
