| Name                     | Type                                            | Req     | Description |
| ------------------------ | ----------------------------------------------- | ------- | --------------------------------------------------------------------------------------------------------------------------------------------------- |
| DestinationPage          | string                                          | no      | The destination (target) page of the hyperlink. |
| DestinationUniqueKey   | int                                             | no      | Aunique key identifying the hyperlink destina- tion. |
| Hidden                   | boolean                                         | no      | If true, the hyperlink is hidden in the PDF. |
| Name                     | string                                          | yes     | The name of the hyperlink page destination. The name must be unique within the IDML document. |
| NameManually             | boolean                                         | no      | If true, name the hyperlink page destination manually. |
| ViewPercentage           | double                                          | no      | The view percentage, if ViewSetting is Fixed. |
| ViewSetting              | HyperlinkDestinationPageSetting_EnumValue   | no      | The view at which to view the content of the hyperlink. Can be Fixed, FitView, FitWindow, FitWidth, FitHeight, FitVisible, or InheritZoom. |
