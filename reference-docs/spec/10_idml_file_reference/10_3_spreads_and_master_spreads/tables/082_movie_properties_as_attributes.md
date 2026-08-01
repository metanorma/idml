| Name                       | Type                                   | Req     | Description |
| -------------------------- | -------------------------------------- | ------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| CanChoosePosters           | boolean                                | no      | If true, the user can choose a poster image for the movie. |
| ControllerSkin             | string                                 | no      | Applicable to FLV/F4V clips only. The video con- troller skin name. Can be None, SkinOverAll, SkinOverAllNoCaption, SkinOverAllNoFullNoCaption, SkinOverAllNoFullscreen, SkinOverAllNoVolNoCaptionNoFull, SkinOverPlay . Uses None as a default value. |
| CustomPoster               | boolean                                | no      | If true, the movie has had a custom poster image applied to it. |
| Description                | string                                 | no      | Adescription of the movie. |
| EmbedInPDF                 | boolean                                | no      | If true, embed the movie in exported PDF. |
| FilePath                   | string                                 | no      | The file path to the movie file. |
| FloatingWindow             | boolean                               | no      | If true, display the movie in a floating window (on playback in an exported PDF or SWF docu- ment). |
| FloatingWindowPosition   | FloatingWindowPosition_EnumValue   | no      | The position of the floating window. Can be UpperLeft, UpperMiddle, UpperRight, CenterLeft, Center, CenterRight, LowerLeft, LowerMiddle, or LowerRight . |
| FloatingWindowSize       | FloatingWindowSize_EnumValue         | no      | The Size of the floating window. Can be OneFifth, OneFourth, OneHalf, Full, Double, Triple, Quadruple, or Max . Only valid when FloatingWindow is true. |
| IntrinsicBounds            | list of int                            | no      | The bounds of the movie file, as width, height. |
| MovieLoop         | boolean               | no      | If true, loop the movie in the exported PDF or SWF document. |
| PlayMode          | PlayMode_EnumValue   | no      | The play mode for the movie. Can be Once, StayOpen, or RepeatPlay . |
| PlayOnPageTurn    | boolean                | no      | If true, the movie plays automatically when a user views the page that contains the movie poster in the exported PDF or SWF document. |
| PosterAvailable   | boolean                | no      | If true, the movie file contains a poster image. |
| ShowController    | boolean                | no      | Applicable to FLV/F4V clips only. If true, dis- plays controller skin with mouse rollover. |
| ShowControls      | boolean                | no      | If true, show movie playback controls in the exported PDF or SWF document |
| URL               | string                 | no      | The URL of the movie. |
