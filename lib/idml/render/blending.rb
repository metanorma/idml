# frozen_string_literal: true

module Idml
  module Render
    # Maps an `Elements::BlendingSetting` to the keyword arguments that
    # `Pdfrb::Content::Canvas#with_transparency` expects. IDML stores
    # opacity as 0–100 (percentage); pdfrb wants 0.0–1.0 alpha. Blend
    # mode names line up directly with PDF `BM` names; unknown modes
    # fall back to `Normal`.
    module Blending
      PDF_BLEND_MODES = %w[
        Normal Multiply Screen Overlay SoftLight HardLight Darken Lighten
        ColorDodge ColorBurn Difference Exclusion Hue Saturation Color
        Luminosity
      ].freeze

      def self.args_for(setting)
        return nil unless setting&.blending_setting

        build_args(setting.blending_setting)
      end

      def self.build_args(blending)
        opacity = normalize_opacity(blending.opacity)
        mode = normalize_mode(blending.blend_mode)
        return nil unless opacity || mode

        { opacity: opacity || 1.0, blend_mode: mode || "Normal" }
      end
      private_class_method :build_args

      # Wraps the given block in `Canvas#with_transparency` when the
      # page item has a BlendingSetting, otherwise yields directly.
      def self.wrap(canvas, setting, &)
        args = args_for(setting)
        if args
          canvas.with_transparency(**args, &)
        else
          yield
        end
      end

      def self.normalize_opacity(raw)
        return nil if raw.nil?

        (raw.to_f / 100.0).clamp(0.0, 1.0)
      end
      private_class_method :normalize_opacity

      def self.normalize_mode(raw)
        return nil if raw.nil? || raw == "Normal"

        camel = raw.to_s.dup
        camel[0] = camel[0].upcase
        PDF_BLEND_MODES.include?(camel) ? camel : nil
      end
      private_class_method :normalize_mode
    end
  end
end
