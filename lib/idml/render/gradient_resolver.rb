# frozen_string_literal: true

module Idml
  module Render
    # Resolves IDML gradient references to discrete PDF gradient fills.
    # A gradient is rendered as N thin colored rectangles that
    # approximate the smooth gradient transition. This is not a true
    # PDF shading pattern (which requires Function dictionaries), but
    # produces a visually correct gradient without complex PDF structure.
    class GradientResolver
      SEGMENTS = 32

      def self.build(graphic)
        table = {}
        return new(table) unless graphic&.gradient

        graphic.gradient.each do |gradient|
          table[gradient.self_attr] = gradient
        end
        new(table)
      end

      def initialize(table)
        @table = table
        @color_resolver = nil
      end

      # Detect if a color reference is a gradient.
      def self.gradient?(name)
        name.is_a?(String) && name.start_with?("Gradient/")
      end

      # Render a gradient fill as PDF operators. Returns nil if the
      # color is not a gradient. The returned operators emit colored
      # rectangles from y2 down to y1 (matching PDF Y-up coords).
      def render_gradient(name, x:, y:, width:, height:, color_resolver:)
        @color_resolver = color_resolver
        gradient = @table[name]
        return nil unless gradient

        stops = gradient.gradient_stop
        return nil if stops.length < 2

        segment_height = height.to_f / SEGMENTS
        ops = []
        SEGMENTS.downto(1) do |i|
          offset = (i - 1) / SEGMENTS.to_f
          color = interpolate(stops, offset)
          next unless color

          ops << "q"
          ops << Idml::Render::ColorHelper.to_canvas(color)
          ops << format("%<x>.2f %<y>.2f %<w>.2f %<h>.2f re",
                        x: x,
                        y: y + ((SEGMENTS - i) * segment_height),
                        w: width,
                        h: segment_height + 0.1)
          ops << "f"
          ops << "Q"
        end
        ops.join("\n")
      end

      def interpolate(stops, offset)
        next_stop = stops.find { |s| s.location >= offset } || stops.last
        prev_stop = stops.reverse.find { |s| s.location <= offset } || stops.first
        return resolve_color(next_stop.stop_color) if next_stop == prev_stop

        blend_between(prev_stop, next_stop, offset)
      end

      def blend_between(prev_stop, next_stop, offset)
        range = (next_stop.location - prev_stop.location)
        range = 1.0 if range.zero?
        local = (offset - prev_stop.location) / range

        prev_color = resolve_color(prev_stop.stop_color)
        next_color = resolve_color(next_stop.stop_color)
        return prev_color unless prev_color && next_color
        return next_color if local >= 1.0

        blend(prev_color, next_color, local)
      end

      def resolve_color(name)
        return nil unless @color_resolver && name

        @color_resolver.resolve(name)
      end

      def blend(color_a, color_b, t)
        case color_a[:model]
        when :rgb
          {
            model: :rgb,
            r: color_a[:r] + ((color_b[:r] - color_a[:r]) * t),
            g: color_a[:g] + ((color_b[:g] - color_a[:g]) * t),
            b: color_a[:b] + ((color_b[:b] - color_a[:b]) * t),
          }
        when :cmyk
          {
            model: :cmyk,
            c: color_a[:c] + ((color_b[:c] - color_a[:c]) * t),
            m: color_a[:m] + ((color_b[:m] - color_a[:m]) * t),
            y: color_a[:y] + ((color_b[:y] - color_a[:y]) * t),
            k: color_a[:k] + ((color_b[:k] - color_a[:k]) * t),
          }
        end
      end
    end
  end
end
