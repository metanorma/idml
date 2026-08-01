| Name               | Type                        | Req     | Description |
| ------------------ | --------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AnchorPoint        | AnchorPoint_Enum Value     | no      | The point in the anchored object to posi- tion. Can be TopLeftAnchor , TopCenter Anchor , TopRightAnchor , LeftCenter Anchor , CenterAnchor , RightCenterAnchor , BottomLeftAnchor , BottomCenterAnchor , or BottomRightAnchor. |
| AnchorSpaceAbove   | double                      | no      | The space above an anchored object. Valid only when AnchoredPosition is AboveLine . |
| AnchorXoffset      | double                      | no      | The horizontal (x) offset of the anchored object. |
| AnchorYoffset      | double                      | no      | The vertical (y) offset of the anchored object. |
| AnchoredPosition   | AnchorPosition_ EnumValue   | no      | The position of the anchored object relative to the anchor. Can be InlinePosition , Above Line , or Anchored . |
| Horizontal Alignment        | Horizontal Alignment_Enum Value    | no      | When AnchoredPosition is AboveLine, the position of the anchored object is relative to the text area. Can be RightAlign, LeftAlign, CenterAlign, or TextAlign. Not valid when anchored position is InlinePosition. Can be |
| Horizontal ReferencePoint   | AnchoredRelative To_EnumValue       | no      | The horizontal reference point on the page. Valid only when AnchoredPosition is Anchored Position . |
| LockPosition                 | boolean                              | no      | If true, prevents manual positioning of the anchored object. |
| PinPosition                  | boolean                              | no      | If true, pins the position of the anchored object within the TextFrame top and bottom. |
| SpineRelative                | boolean                              | no      | If true, the position of the anchored object is rel- ative to the binding spine of the page or spread. |
| VerticalAlignment            | Vertical Alignment_Enum Value      | no      | The vertical alignment of the anchored object reference point with the vertical reference point on the page. Can be TopAlign , BottomAlign , or CenterAlign . Valid only when Anchored Position is AnchoredPosition . |
| Vertical ReferencePoint     | Vertically RelativeTo_Enum Value   | no      | The vertical reference point on the page. Valid only when AnchoredPosition is Anchored Position . |
