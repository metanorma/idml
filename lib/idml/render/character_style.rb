# frozen_string_literal: true

module Idml
  module Render
    # Applies character-level styling from a `StyleResolver::StyledRun`
    # around a text-emitting block. Centralizes the IDML → PDF mapping
    # for run-level visual properties (text color, underline rule,
    # strike-through rule, capitalization, super/subscript position).
    #
    # Used by `TextFrameRenderer` so character-level effects live in
    # one place (DRY). The block typically calls `canvas.text` (or
    # `canvas.text_rich`); this helper sets the surrounding graphics
    # state and emits the rule lines after the block returns.
    module CharacterStyle
      UNDERLINE_THICKNESS_FACTOR = 0.05
      UNDERLINE_DROP_FACTOR = 0.10
      STRIKE_THICKNESS_FACTOR = 0.05
      STRIKE_RISE_FACTOR = 0.25

      # Yields with the run's fill color applied, then draws underline
      # and/or strike-through rules above/below the text baseline.
      # `x`, `y`, `width`, `size` describe the line's geometry so the
      # rules can be positioned correctly.
      def self.apply(canvas, run, context, x:, y:, width:, size:)
        apply_fill_color(canvas, run, context)
        yield
        draw_underline(canvas, run, x, y, width, size)
        draw_strike_through(canvas, run, x, y, width, size)
      end

      # Transforms the text per the CSR's Capitalization attribute.
      # AllCaps/SmallCaps → uppercase (true small-caps would require
      # an OpenType feature; deferred). Other values pass through.
      def self.transform_text(text, capitalization)
        return text unless %w[AllCaps SmallCaps].include?(capitalization)

        text.upcase
      end

      # Returns `[font_size, baseline_offset]` for the CSR's Position
      # attribute. Superscript/subscript shrink the font and shift
      # the baseline. Normal / nil returns the size unchanged.
      def self.position_scale(position, font_size)
        case position
        when "Superscript" then [font_size * 0.583, font_size * 0.333]
        when "Subscript" then [font_size * 0.583, -font_size * 0.0833]
        else [font_size, 0.0]
        end
      end

      def self.apply_fill_color(canvas, run, context)
        return unless run.fill_color
        return if run.fill_color == "Color/None"

        color = context.color_resolver&.resolve(run.fill_color)
        return unless color

        canvas.fill_color(ColorHelper.to_canvas(color))
      end
      private_class_method :apply_fill_color

      def self.draw_underline(canvas, run, x, y, width, size)
        return unless run.underline

        thickness = rule_thickness(run.underline_weight, size,
                                   UNDERLINE_THICKNESS_FACTOR)
        drop = rule_offset(run.underline_offset, size,
                           UNDERLINE_DROP_FACTOR)
        canvas.rectangle(x, y - drop, width, thickness)
        canvas.fill
      end
      private_class_method :draw_underline

      def self.draw_strike_through(canvas, run, x, y, width, size)
        return unless run.strike_thru

        thickness = rule_thickness(run.strike_through_weight, size,
                                   STRIKE_THICKNESS_FACTOR)
        rise = rule_offset(run.strike_through_offset, size,
                           STRIKE_RISE_FACTOR)
        canvas.rectangle(x, y + rise - thickness, width, thickness)
        canvas.fill
      end
      private_class_method :draw_strike_through

      def self.rule_thickness(declared, size, factor)
        declared&.positive? ? declared : (size * factor)
      end
      private_class_method :rule_thickness

      def self.rule_offset(declared, size, factor)
        return size * factor unless declared
        return size * factor if declared.zero?

        declared
      end
      private_class_method :rule_offset
    end
  end
end
