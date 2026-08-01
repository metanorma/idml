| Name       | Type     | Req     | Description |
| ---------- | -------- | ------- | ---------------- |
| UserName   | string   | no      | The UserName. |

| Name                        | Type                                  | Req     | Description |
| --------------------------- | ------------------------------------- | ------- | --------------------------------------------------------------- |
| ExportOptions               | AssignmentExportOptions_EnumValue   | no      | Can be AssignedSpreads, EmptyFrames, or Everything. |
| IncludeLinksWhenPackage   | boolean                               | no      | If true, includes linked files when packaging the assignment. |
| FilePath                    | string                                | yes     | The file path to the saved assignment. |
