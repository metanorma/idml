| Name                     | Type                                         | Req     | Description |
| ------------------------ | -------------------------------------------- | ------- | ------------------------------------------------------------------------------------------------ |
| Name                     | string                                       | yes     | The name of the hyperlink. |
| Source                   | string                                       | yes     | Areference to the source of the hyperlink (as the value of the Self attribute of the element). |
| Visible                  | boolean                                      | no      | If true, they hyperlink will be visible in the exported PDF. |
| Highlight                | HyperlinkAppearanceHighlight_EnumValue   | no      | The highight of the hyperlink. Can be None, Invert, Outline or Inset. |
| Width                    | HyperlinkAppearanceWidth_EnumValue        |         | The width of the stroke applied to the hyperlink Can be Thin, Medium, or Thick. |
| BorderStyle              | HyperlinkAppearanceStyle_EnumValue        | no      | The border style of the hyperlink. Can be Solid or Dashed. |
| Hidden                   | boolean                                      | no      | If true, the hyperlink is hidden in the output PDF. |
| DestinationUniqueKey   | int                                          | no      | Aunique key identifying the hyperlink destina- tion. |
