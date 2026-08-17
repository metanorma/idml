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

      # Emits the paragraph's shading: a fill rect behind the
      # paragraph block (top_y..bottom_y within the column). The
      # ParagraphShading* offsets expand the rect outward; tint
      # scales the color. Color comes from Properties >
      # ParagraphShadingColor (black when absent, per InDesign's
      # default shading color).
      def self.emit_shading(canvas, paragraph, context, top_y, bottom_y,
                            frame_left, frame_right)
        return unless paragraph.paragraph_shading_on
        return unless top_y > bottom_y

        tint_value = decoration_tint(paragraph.paragraph_shading_tint)
        return unless tint_value

        color = resolve_color(paragraph.paragraph_shading_color,
                              tint_value, context)
        return unless color

        left, right, top, bottom = decoration_rect(
          paragraph, top_y, bottom_y, frame_left, frame_right,
          left_offset: paragraph.paragraph_shading_left_offset,
          right_offset: paragraph.paragraph_shading_right_offset,
          top_offset: paragraph.paragraph_shading_top_offset,
          bottom_offset: paragraph.paragraph_shading_bottom_offset
        )
        canvas.fill_color(color)
        canvas.rectangle(left, bottom, right - left, top - bottom)
        canvas.fill
      end

      # Emits the paragraph's border: per-side strokes around the
      # paragraph block, each side with its own line weight, drawn
      # at the block rect expanded by the border offsets.
      def self.emit_border(canvas, paragraph, context, top_y, bottom_y,
                           frame_left, frame_right)
        return unless paragraph.paragraph_border_on
        return unless top_y > bottom_y

        tint_value = decoration_tint(paragraph.paragraph_border_tint)
        return unless tint_value

        color = resolve_color(paragraph.paragraph_border_color,
                              tint_value, context)
        return unless color

        left, right, top, bottom = decoration_rect(
          paragraph, top_y, bottom_y, frame_left, frame_right,
          left_offset: paragraph.paragraph_border_left_offset,
          right_offset: paragraph.paragraph_border_right_offset,
          top_offset: paragraph.paragraph_border_top_offset,
          bottom_offset: paragraph.paragraph_border_bottom_offset
        )
        apply_rule_color(canvas, paragraph.paragraph_border_color,
                         tint_value, context)
        stroke_border_sides(canvas, paragraph, left, right, top, bottom)
      end

      # Tint value for a decoration, or nil when zero/absent.
      def self.decoration_tint(tint)
        value = (tint || DEFAULT_TINT).to_f
        value.positive? ? value : nil
      end
      private_class_method :decoration_tint

      # The decoration rect [left, right, top, bottom]: the column
      # (or text) extents expanded outward by the given offsets.
      def self.decoration_rect(paragraph, top_y, bottom_y, frame_left,
                               frame_right, left_offset:, right_offset:,
                               top_offset:, bottom_offset:)
        left, right = decoration_extents(paragraph, frame_left, frame_right)
        [left - (left_offset || 0).to_f,
         right + (right_offset || 0).to_f,
         top_y + (top_offset || 0).to_f,
         bottom_y - (bottom_offset || 0).to_f]
      end
      private_class_method :decoration_rect

      def self.stroke_border_sides(canvas, paragraph, left, right,
                                   top, bottom)
        stroke_horizontal(canvas, left, right, top,
                          paragraph.paragraph_border_top_line_weight)
        stroke_horizontal(canvas, left, right, bottom,
                          paragraph.paragraph_border_bottom_line_weight)
        stroke_vertical(canvas, bottom, top, left,
                        paragraph.paragraph_border_left_line_weight)
        stroke_vertical(canvas, bottom, top, right,
                        paragraph.paragraph_border_right_line_weight)
      end
      private_class_method :stroke_border_sides

      def self.stroke_horizontal(canvas, x1, x2, y, weight)
        thickness = weight.to_f
        return unless thickness.positive?

        canvas.line_width = thickness
        canvas.move_to(x1, y)
        canvas.line_to(x2, y)
        canvas.stroke
      end
      private_class_method :stroke_horizontal

      def self.stroke_vertical(canvas, y1, y2, x, weight)
        thickness = weight.to_f
        return unless thickness.positive?

        canvas.line_width = thickness
        canvas.move_to(x, y1)
        canvas.line_to(x, y2)
        canvas.stroke
      end
      private_class_method :stroke_vertical

      # Horizontal extents for shading/border: the column width, or
      # the text width (indented by the paragraph's indents) when
      # the shading width mode is "TextWidth".
      def self.decoration_extents(paragraph, frame_left, frame_right)
        if paragraph.paragraph_shading_width == "TextWidth"
          [frame_left + (paragraph.left_indent || 0).to_f,
           frame_right - (paragraph.right_indent || 0).to_f]
        else
          [frame_left, frame_right]
        end
      end
      private_class_method :decoration_extents

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
