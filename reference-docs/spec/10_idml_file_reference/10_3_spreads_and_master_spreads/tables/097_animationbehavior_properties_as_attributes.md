| Name                     | Type                                   | Req     | Description |
| ------------------------ | -------------------------------------- |------- | ---------------------------------------------------------------------------------------------- |
| AnimatedPageItem         | string                                 | no      | The animation page item, as a reference to the Self attribute of the page item. |
| AutoReverseOnRollOff   | boolean                               |no      | If true, will automatically play the animation in reverse on roll off of the rollover event. |
| Operation                | AnimationPlayOperations_EnumValue   | no      | The playback mode. Can be Play, Stop, Pause, Resume, ReversePlayback, or StopAll . |
| MovieItem           | string                              | no      | The path to the movie file. |
| NavigationPointID   | int                                 | no      | The id of the navigation point to play from. This corresponds to the Id attribute of a <NavigationPoint> element of the <Movie> element, whose Self attribute is defined in the pre-existing <MoviBehavior> attribute MovieItem . This property is ignored for all operations other than PlayFromNavigationPoint . |
| Operation           | MoviePlayOperations_EnumValue   | no      | Can be Play, PlayFromNavigationPoint, Stop, Pause, Resume, or StopAll . |
