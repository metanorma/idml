| Name                     | Type                                            | Req     | Description |
| ------------------------ | ----------------------------------------------- | ------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| DestinationPageIndex   | int                                             | no      | The index of the destination page in the target document. Range: 1 to 9999. |
| DocumentPath             | string                                          | no      | The path to the target document of the hyper- link. |
| DestinationUniqueKey   | int                                             | no      | Aunique key identifying the hyperlink URL destination. |
| Name                     | string                                          | yes     | The name of the hyperlink external page desti- nation. |
| ViewSetting              | HyperlinkDestinationPageSetting_EnumValue   | no      | The view at which to view the content of the hyperlink. Can be Fixed, FitView, FitWindow, FitWidth, FitHeight, FitVisible, or InheritZoom. |
| ViewPercentage           | double                                          | no      | The view percentage, if ViewSetting is Fixed. |
