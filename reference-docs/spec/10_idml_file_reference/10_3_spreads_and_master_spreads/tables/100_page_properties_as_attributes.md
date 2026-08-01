| Attribute                 | Type                                                   | Req     | Description |
| ------------------------- | ------------------------------------------------------ | ------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AppliedAlternateLayout   | string                                                 | no      | The alternate layout section to which the page belongs. |
| AppliedTrapPreset         | string                                                 | no      | The name of the trapping preset applied to the page. |
| AppliedMaster             | string                                                 | no      | The master spread applied to the page. |
| GeometricBounds           | list of four doubles                                   | yes     | The bounds of the page, in the form y1, x1, y2, x2. |
| GridStartingPoint         | GridStartingPointOptions_EnumValue                   | no      | The starting point for the grid. Can be TopOutside, TopInside, BottomOutside, BottomInside, CenterVertical, CenterHorizontal, or CenterCompletely . |
| ItemTransform             | list of six doubles                                    | no      | The transformation matrix applied to the page. |
| LayoutRule                | LayoutRuleOptions_EnumValue                           | no      | The layout rule. |
| MasterPageTransform     | list of six doubles                                    | no      | The transformation matrix applied to master page items. |
| Name                      | string                                                 | no      | The name of the page. |
| OptionalPage              | boolean                                               | no      | The optional page for HTML5 pagination. |
| OverrideList              | list of strings as a space separated string           | no      | The overridden master page items on this page, as a series of references (using the value of the Self attribute of the overridden page items). For mreon overriding master page items on docu- ment pages, refer to the InDesign online help. |
| PageColor                 |PageColorOptions_EnumValue or list of three doubles   | no      | Can be Nothing (do not use the page color of the master spread), UseMasterColor (use the page color of the master spread), or a list of three doubles, each in the range 0 to 255 and repre- senting R, G, and B values. |
| SnapshotBlending Mode   | SnapshotBlending Modes_EnumValue                     | no      | The snapshot blending mode. |
| TabOrder                | string list of strings as a spaceseparated string   | no      | The order in which the focus in an exported PDF moves to different form fields when the tab but- ton is pressed, as a series of references (using the value of the Self attribute of the page items). |
| UseMasterGrid           | boolean                                              | no      | If true, use the master grid. |
