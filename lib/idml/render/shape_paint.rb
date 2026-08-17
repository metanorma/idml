# frozen_string_literal: true

module Idml
  module Render
    # Paints a page item's fill and stroke on a pdfrb canvas,
    # delegating path construction to the caller's block. The
    # single owner of the IDML → PDF paint mapping — solid fill,
    # gradient shading fill, stroke styling — shared by every
    # shape renderer. Callers choose the geometry (axis-aligned
    # rectangle, Bézier contour); this module chooses the paint
    # and the PDF paint op sequencing (fill, stroke, or
    # fill-and-stroke on one path).
    module ShapePaint
      # Paints the item. The block receives the canvas and must
      # construct the current path (move_to/line_to/curve_to/...).
      # The block may be called more than once (a path is consumed
      # by each paint op, so fill-then-stroke rebuilds it).
      # Returns nil when there is nothing to paint; truthy
      # otherwise.
      def self.paint(canvas, item, context, &build_path)
        fill = fill_style(item, context)
        stroke = stroke_style(item, context)
        return unless fill || stroke

        Blending.wrap(canvas, item.transparency_setting) do
          paint_styles(canvas, item, context, fill, stroke, &build_path)
        end
      end

      # Returns the fill plan: { kind: :solid, color: } for a
      # resolved color, { kind: :gradient, gradient:, stops: } for
      # a fill referencing a Gradient, nil when nothing fillable.
      def self.fill_style(item, context)
        return nil unless item.fill_color
        return nil if item.fill_color == "Color/None"

        if GradientResolver.gradient?(item.fill_color)
          gradient_fill_style(item, context)
        else
          solid_fill_style(item, context)
        end
      end
      private_class_method :fill_style

      def self.gradient_fill_style(item, context)
        gradient = gradient_for(item, context)
        return nil unless gradient

        stops = gradient_stops(gradient, context)
        return nil unless stops.length >= 2

        { kind: :gradient, gradient: gradient, stops: stops }
      end
      private_class_method :gradient_fill_style

      def self.solid_fill_style(item, context)
        color = context.color_resolver&.resolve(item.fill_color)
        return nil unless color

        { kind: :solid, color: ColorHelper.to_canvas(color) }
      end
      private_class_method :solid_fill_style

      def self.stroke_style(item, context)
        return nil unless StrokeStyle.strokeable?(item)

        color = context.color_resolver&.resolve(item.stroke_color)
        return nil unless color

        { color: ColorHelper.to_canvas(color) }
      end
      private_class_method :stroke_style

      def self.paint_styles(canvas, item, context, fill, stroke, &)
        if fill && stroke
          paint_fill_and_stroke(canvas, item, context, fill, stroke,
                                &)
        elsif fill
          paint_fill(canvas, item, context, fill, &)
        else
          paint_stroke(canvas, item, stroke, &)
        end
      end
      private_class_method :paint_styles

      def self.paint_fill(canvas, item, context, fill, &)
        yield(canvas)
        if fill[:kind] == :gradient
          canvas.fill_shading(shading_for(canvas, item, context, fill))
        else
          canvas.fill_color(fill[:color])
          canvas.fill
        end
      end
      private_class_method :paint_fill

      def self.paint_stroke(canvas, item, stroke, &)
        StrokeStyle.apply(canvas, item) do
          canvas.stroke_color(stroke[:color])
          canvas.line_width = item.stroke_weight
          yield(canvas)
          canvas.stroke
        end
      end
      private_class_method :paint_stroke

      # Fill and stroke on one path where possible (fill_stroke);
      # a gradient fill consumes the path, so the stroke rebuilds
      # it afterward.
      def self.paint_fill_and_stroke(canvas, item, context, fill, stroke,
                                     &)
        if fill[:kind] == :gradient
          paint_fill(canvas, item, context, fill, &)
          paint_stroke(canvas, item, stroke, &)
        else
          yield(canvas)
          canvas.fill_color(fill[:color])
          StrokeStyle.apply(canvas, item) do
            canvas.stroke_color(stroke[:color])
            canvas.line_width = item.stroke_weight
            canvas.fill_stroke
          end
        end
      end
      private_class_method :paint_fill_and_stroke

      def self.shading_for(canvas, item, context, fill)
        box = Placement.box(item, context.page_height)
        stops = fill[:stops]
        if fill[:gradient].type == "Radial"
          canvas.document.shadings.add_radial(
            from: radial_center(box, 0.0),
            to: radial_center(box, [box[:width], box[:height]].max / 2.0),
            stops: stops,
          )
        else
          canvas.document.shadings.add_axial(
            from: [box[:x], box[:y] + box[:height]],
            to: [box[:x] + box[:width], box[:y]],
            stops: stops,
          )
        end
      end
      private_class_method :shading_for

      def self.radial_center(box, radius)
        cx = box[:x] + (box[:width] / 2.0)
        cy = box[:y] + (box[:height] / 2.0)
        [cx, cy, radius]
      end
      private_class_method :radial_center

      def self.gradient_for(item, context)
        graphic = context.package&.graphic
        return nil unless graphic

        graphic.gradient.find { |g| g.self_attr == item.fill_color }
      end
      private_class_method :gradient_for

      def self.gradient_stops(gradient, context)
        gradient.gradient_stop.filter_map do |stop|
          color = context.color_resolver&.resolve(stop.stop_color)
          next unless color

          [stop.location || 0.0, ColorHelper.to_canvas(color)]
        end
      end
      private_class_method :gradient_stops
    end
  end
end
