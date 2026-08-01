|Name              | Type                               | Req     | Description |
| --------------    |----------------------------------| ------- | ------------------------------------------------------------------------------- |
| DesignOption      |DesignOptions_EnumValue           | no      | Can be FromCurrentAppearance, ToCurrentAppearance, or ToCurrentLocation . |
| Duration          | double                             | no      | The duration of the animation, from .125 to 60 seconds. |
| EaseType          | AnimationEaseOptions_EnumValue   | no      | Can be NoEase, EaseIn . EaseOut . EaseInOut . or CustomEase . |
| HasCustomSettings | Boolean                            | no      | If true, the animated object has custom settings. |
| HiddenAfter       | Boolean                            | no      | If true, the animated object is hidden after playing. |
| InitiallyHidden   | Boolean                            | no      | If true, the animated object is hidden before playing. |
| Plays             | int                                | no      | The number of times to play the animation. |
| PlaysLoop         | Boolean                            | no      | If true, the animation loops. |
| TransformOffsets  | list of two doubles                | no      | The transform offset percentage from the target object bounding box's left-top corner. |
