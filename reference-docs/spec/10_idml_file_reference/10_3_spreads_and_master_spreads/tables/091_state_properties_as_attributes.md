| Name        | Type                     | Req     | Description |
| ----------- | ------------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Active      | boolean                  | no      | If true, the state is the active (or front most) state in the user interface. |
| Enabled     | boolean                  | no      | If true, objects that use the state appear in PDF documents. If false, objects that use the state do not appear in the document when the event that activates the state, such as a mouseover, occurs. |
| Name        | string                  | yes     | The name of the state. |
| Statetype   | StateTypes_EnumValue   | no      | The type of user action that dictates the button's appearance. Can be Up, Rollover, or Down . |
