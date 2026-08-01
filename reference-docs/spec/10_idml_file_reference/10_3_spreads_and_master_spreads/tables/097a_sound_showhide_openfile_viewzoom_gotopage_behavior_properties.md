| Name        | Type                        |Req     | Description |
| ----------- | --------------------------- | ------- | ---------------------------------------------------- |
| SoundItem   |string                     | no      | The path to the sound file. |
| Operation   |PlayOperations_EnumValue   | no      | Can be Play, Stop, Pause, Resume, or StopAll . |
| FieldsToShow     | list of strings as a space separated string     | no     | Alist of the fields to show, as a series of refer- ences (using the value of the Self attribute of the elements to refer to). |
| FieldsToHide     | list of strings as a space separated string     | no     | Alist of the fields to hide, as a series of references (using the value of the Self attribute of the ele- ments to refer to). |
| FilePath   | string   | no      | The file path to the file to open. |
| ViewZoomStyle   |ViewZoomStyle_EnumValue   | no      | Can be FullScreen, ZoomIn, ZoomOut, FitPage, ActualSize, FitWidth, FitVisible, SinglePage, OneColumn, or TwoColumn. |
| PageNumber   | int      | no      | The number of the page to display. |
