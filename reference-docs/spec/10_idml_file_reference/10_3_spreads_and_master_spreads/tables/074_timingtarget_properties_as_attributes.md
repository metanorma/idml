| Name               | Type      | Req     | Description |
| ------------------ | --------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DynamicTarget      | string    | no      | The animated page item, as a reference to the Self attribute of the animated page item, video, sound, or multi-state object. Video and buttons can also be animated. |
| DelaySeconds       | int       | no      | The time delay in seconds for this target, relative to the start of the current timing group. |
| ReverseAnimation   | boolean   | no      | If true, reverse the animation. Only valid when the DynamicTriggerEvent for the <TimingList> containing the <TimingGroup> of the <TimingTarget> is OnRolloff or OnSelfRolloff . |
| TargetRole     | int      | no      | The target in the timing as video, sound, anima- tion, or other suppported dynamic media type. |
| TargetAction   | int      | no      | The action associated with this target when exported to SWF. |
| Placement      | int      | no      | The placement of the timing target in the timing group. |
