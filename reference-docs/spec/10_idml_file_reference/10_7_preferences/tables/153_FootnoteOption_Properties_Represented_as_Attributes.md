| Name | Type | Req | Description |
| ------------------------------ | --------- | ------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| ContinuingRuleGapOverprint | boolean | no | If true, overprints the gap color of the rule above continued footnote text. Note: Valid when continuing rule type is not solid. |
| ContinuingRuleGapTint | double | no | The tint (as a percentage) of the gap color of the rule above continued footnote text. (Range: 0 to 100) Note: Valid when continuing rule type is not solid. |
| ContinuingRuleLeftIndent | double | no | The amount to left indent the rule above continued footnote text. Note: Valid when continuing rule on is true. Range: -103680 to 103680. |
| ContinuingRuleLineWeight | double | no | The stroke weight of the rule above continued footnote text. (Range: 0 to 1000) Note: Valid when continuing rule on is true. |
| ContinuingRuleOffset | double | no | The vertical offset of the rule above continued footnote text. Note: Valid when continuing rule on is true. Range: -15552 to 15552. |
| ContinuingRuleOn | boolean | no | If true, draws a rule above footnote text that continues from a previous column. Note: Valid when no splitting is false or undefined. |
| ContinuingRuleOverprint | boolean | no | If true, overprints the rule above continued footnote text. Note: Valid when continuing rule on is true. |
| ContinuingRuleTint | double | no | The tint (as a percentage) of the rule above continued footnote text. (Range: 0 to 100) Note: Valid when continuing rule type is not solid. |
| ContinuingRuleWidth | double | no | The length of the rule above continued footnote text. Note: Valid when continuing rule on is true. Range: 0 to 103680. |
| EosPlacement | boolean | no | If true, footnotes at the end of the story are placed just below the text. If false, footnotes at the end of the story are placed at the bottom of the column. |
| FootnoteFirstBaselineOffset | FootnoteFirstBaseline_EnumValue | no | The distance between the top of the footnote container and the footnote text. Can be AscentOffset, CapHeight, LeadingOffset, EmboxHeight, XHeight, or FixedHeight. |
| FootnoteMarkerStyle | string | no | The CharacterStyle to apply to footnote reference numbers in the main text. |
| FootnoteMinimumFirstBaselineOffset | double | no | The minimum distance between the baseline of the text and the top of the footnote container. Range: 0 to 103680. |
| FootnoteTextStyle | string | no | The paragraph style to apply to footnotes. Note: The space before and after the paragraph defined in the paragraph style is ignored for footnotes. To define space above and between footnotes, see spacer and space between. |
| NoSplitting | boolean | no | If true, footnotes cannot split across columns. If false, footnotes flow into succeeding columns when the footnote text causes the footnote area to expand upward to reach the footnote reference number in the main text. |
| Prefix | string | no | The prefix text of the footnote. (Limit: 0 to 100 characters) |
| RuleGapOverprint | boolean | no | If true, overprints the gap color of the rule above the first footnote in the column. Note: Valid when rule type is not solid. |
| RuleGapTint | double | no | The tint (as a percentage) of the gap color of the rule above the first footnote in the column. (Range: 0 to 100) Note: Valid when rule type is not solid. |
| RuleLeftIndent | double | no | The amount to left indent the rule above the first footnote in the column. Note: Valid when rule on is true. Range: -103860 to 103860. |
| RuleLineWeight | double | no | The stroke weight of the rule above the first footnote in the column. (Range: 0 to 1000) Note: Valid when rule on is true. |
| RuleOffset | double | no | The vertical offset of the rule above the first footnote in the column. Note: Valid when rule on is true. Range: -15552 to 15552. |
| RuleOn | boolean | no | If true, draws a rule between the text and the first footnote in the column. |
| RuleOverprint | boolean | no | If true, overprints the rule above the first footnote in the column. Note: Valid when rule on is true. |
| RuleTint | double | no | The tint (as a percentage) of the rule above the first footnote in the column. (Range: 0 to 100) Note: Valid when rule on is true. |
| RuleWidth | double | no | The length of the rule above the first footnote in the column. Note: Valid when rule on is true. Range: 0 to 103680. |
| Self | string | yes | The unique ID of the object. |
| SeparatorText | string | no | The text to insert between the footnote marker number and the footnote text. (Range: 0 to 100 characters) |
| SpaceBetween | double | no | The amount of vertical space between footnotes. Note: The space before and SpaceAfter defined for the paragraph style applied to the footnote is ignored. For information on the applied paragraph style, see footnote text style. Range: 0 to 864. |
| Spacer | double | no | The minimum amount of vertical space between the bottom of the text column and the first footnote. Note: The space before amount defined in the paragraph style applied to the footnote is ignored for the first footnote. For information on the AppliedParagraphStyle, see footnote text style. Range: 0 to 864. |
| StartAt | int | no | The number at which to start footnote numbering. Range: 1 to 100000. |
| Suffix | string | no | The suffix text of the footnote. (Limit: 0 to 100 characters) |
