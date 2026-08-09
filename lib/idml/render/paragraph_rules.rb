# frozen_string_literal: true

module Idml
  module Render
    # Emits paragraph-level rules (RuleAbove / RuleBelow) on a pdfrb
    # canvas. Centralizes the IDML → PDF mapping for the paragraph
    # rule attributes carried by `StyleResolver::Paragraph`.
    #
    # Each rule is a horizontal stroke above (RuleAbove) or below
    # (RuleBelow) the paragraph block. The rule's weight, color,
    # tint, offset, and indent come from the PSR's RuleAbove* /
    # RuleBelow* attributes; defaults approximate InDesign behavior
    # when an attribute is missing.
    #
    # Used by `TextFrameRenderer` so paragraph rules live in one
    # place (DRY).
    module ParagraphRules
      DEFAULT_LINE_WEIGHT = 0.5
      DEFAULT_TINT = 1.0
      DEFAULT_OFFSET = 0.0

      # Emits RuleAbove if `paragraph.rule_above` is true. The rule
      # sits above the paragraph's first line. `top_y` is the y of
      # the paragraph's top edge (before SpaceBefore is applied);
      # `frame_left` / `frame_right` are the column's text bounds.
      def self.emit_rule_above(canvas, paragraph, context, top_y,
                               frame_left, frame_right)
        return unless paragraph.rule_above

        emit_rule(canvas, paragraph, context, top_y, frame_left,
                  frame_right,
                  weight: paragraph.rule_above_line_weight,
                  color: paragraph.rule_above_color,
                  tint: paragraph.rule_above_tint,
                  offset: paragraph.rule_above_offset,
                  left_indent: paragraph.rule_above_left_indent,
                  right_indent: paragraph.rule_above_right_indent,
                  width_mode: paragraph.rule_above_width,
                  position: :above)
      end

      # Emits RuleBelow if `paragraph.rule_below` is true. The rule
      # sits below the paragraph's last line. `bottom_y` is the y of
      # the paragraph's bottom edge (after SpaceAfter is applied).
      def self.emit_rule_below(canvas, paragraph, context, bottom_y,
                               frame_left, frame_right)
        return unless paragraph.rule_below

        emit_rule(canvas, paragraph, context, bottom_y, frame_left,
                  frame_right,
                  weight: paragraph.rule_below_line_weight,
                  color: paragraph.rule_below_color,
                  tint: paragraph.rule_below_tint,
                  offset: paragraph.rule_below_offset,
                  left_indent: paragraph.rule_below_left_indent,
                  right_indent: paragraph.rule_below_right_indent,
                  width_mode: paragraph.rule_below_width,
                  position: :below)
      end

      def self.emit_rule(canvas, paragraph, context, anchor_y,
                         frame_left, frame_right,
                         weight:, color:, tint:, offset:,
                         left_indent:, right_indent:, width_mode:,
                         position:)
        thickness = (weight || DEFAULT_LINE_WEIGHT).to_f
        return unless thickness.positive?

        tint_value = (tint || DEFAULT_TINT).to_f
        return unless tint_value.positive?

        offset_value = (offset || DEFAULT_OFFSET).to_f
        x1, x2 = rule_extents(frame_left, frame_right, left_indent,
                              right_indent, width_mode, paragraph)
        y = rule_y(anchor_y, offset_value, position)

        apply_rule_color(canvas, color, tint_value, context)
        canvas.line_width = thickness
        canvas.move_to(x1, y)
        canvas.line_to(x2, y)
        canvas.stroke
      end
      private_class_method :emit_rule

      # Returns `[x1, x2]` for the rule. Width mode "Text" indents
      # the rule by the paragraph's left/right indent (matches the
      # text bounds); "Column" (default) spans the full column.
      def self.rule_extents(frame_left, frame_right, rule_left_indent,
                            rule_right_indent, width_mode, paragraph)
        left = frame_left
        right = frame_right
        if width_mode == "Text"
          left += (paragraph.left_indent || 0).to_f
          right -= (paragraph.right_indent || 0).to_f
        end
        left += (rule_left_indent || 0).to_f
        right -= (rule_right_indent || 0).to_f
        [left, right]
      end
      private_class_method :rule_extents

      def self.rule_y(anchor_y, offset, position)
        position == :above ? anchor_y + offset : anchor_y - offset
      end
      private_class_method :rule_y

      def self.apply_rule_color(canvas, color_name, tint_value, context)
        color = resolve_color(color_name, tint_value, context)
        canvas.stroke_color(color)
      end
      private_class_method :apply_rule_color

      def self.resolve_color(color_name, tint_value, context)
        return [:gray, 1.0 * tint_value] unless color_name
        return [:gray, 1.0 * tint_value] if color_name == "Color/None"

        color = context&.color_resolver&.resolve(color_name)
        return [:gray, 1.0 * tint_value] unless color

        ColorHelper.apply_tint(color, tint_value)
      end
      private_class_method :resolve_color
    end
  end
end
