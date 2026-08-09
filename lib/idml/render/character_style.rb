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
      # rules can be positioned correctly. The block's emitted text
      # gets the run's character-level adjustments baked in via
      # `text_kwargs` (caller passes the canvas.text kwargs in, and
      # CharacterStyle adds tracking/scale on top).
      def self.apply(canvas, run, context, x:, y:, width:, size:)
        apply_fill_color(canvas, run, context)
        yield
        draw_underline(canvas, run, x, y, width, size)
        draw_strike_through(canvas, run, x, y, width, size)
      end

      # Returns the canvas.text kwargs augmented with the run's
      # Tracking (PDF char_spacing). IDML Tracking is in points;
      # pdfrb's char_spacing is also in text-space units, so the
      # mapping is 1:1.
      def self.text_kwargs(run, base_kwargs)
        return base_kwargs unless run.tracking

        base_kwargs.merge(char_spacing: run.tracking.to_f)
      end

      # Yields within a transformed coordinate space when the run
      # declares glyph scaling. IDML HorizontalScale/VerticalScale
      # are percentages (100 = no scaling). When both are 100 / nil,
      # yields without transformation (no graphics-state push).
      def self.with_glyph_scaling(canvas, run, &)
        sx = scale_factor(run.horizontal_scale)
        sy = scale_factor(run.vertical_scale)
        return yield if scaling_identity?(sx, sy)

        canvas.scale(sx, sy, &)
      end

      def self.scaling_identity?(sx, sy)
        (sx - 1.0).abs < FLOAT_EPSILON && (sy - 1.0).abs < FLOAT_EPSILON
      end

      FLOAT_EPSILON = 1e-9
      private_constant :FLOAT_EPSILON

      # Returns the run's baseline shift (in PDF units). Positive
      # values shift up; negative shift down. Used to offset the
      # text's `at: y` for CSR's BaselineShift.
      def self.baseline_offset(run)
        run.baseline_shift&.nonzero? ? run.baseline_shift.to_f : 0.0
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

        tinted = ColorHelper.apply_tint(color, run.fill_tint)
        canvas.fill_color(ColorHelper.to_canvas(tinted))
      end
      private_class_method :apply_fill_color

      def self.scale_factor(declared)
        return 1.0 unless declared
        return 1.0 if declared <= 0

        declared.to_f / 100.0
      end
      private_class_method :scale_factor

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
