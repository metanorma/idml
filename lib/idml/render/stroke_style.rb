# frozen_string_literal: true

module Idml
  module Render
    # Maps IDML stroke-style attributes on a page item to the four
    # pdfrb Canvas setters that control PDF stroke rendering:
    # `line_cap=`, `line_join=`, `miter_limit=`, `dash_pattern=`.
    #
    # IDML → PDF enum mapping per PDF 32000-1 §8.4.3:
    #
    #   EndCap        → LineCap
    #     ButtEndCap        → 0
    #     RoundEndCap       → 1
    #     ProjectingEndCap  → 2
    #
    #   EndJoin       → LineJoin
    #     MiterEndJoin   → 0
    #     RoundEndJoin   → 1
    #     BevelEndJoin   → 2
    #
    # `StrokeDashAndGap` is a flat list `[d1, g1, d2, g2, ...]` — pdfrb
    # accepts the same shape as `dash_pattern=[array, phase]`.
    module StrokeStyle
      CAP_MAP = {
        "ButtEndCap" => 0,
        "RoundEndCap" => 1,
        "ProjectingEndCap" => 2,
      }.freeze

      JOIN_MAP = {
        "MiterEndJoin" => 0,
        "RoundEndJoin" => 1,
        "BevelEndJoin" => 2,
      }.freeze

      # True when the item has a renderable stroke: a non-None stroke
      # color and a positive stroke weight.
      def self.strokeable?(item)
        !!(item.stroke_color &&
          item.stroke_color != "Color/None" &&
          item.stroke_weight&.positive?)
      end

      # Apply stroke-style settings from `item` to `canvas` inside a
      # saved graphics state, then yield so the caller can emit the
      # path and call `canvas.stroke`. The save/restore ensures
      # cap/join/miter/dash settings don't bleed into subsequent
      # strokes on the same page.
      def self.apply(canvas, item)
        canvas.save_graphics_state do
          set_cap(canvas, item.end_cap)
          set_join(canvas, item.end_join)
          set_miter(canvas, item.miter_limit)
          set_dash(canvas, item.stroke_dash_and_gap)
          yield
        end
      end

      def self.set_cap(canvas, raw)
        code = CAP_MAP[raw]
        canvas.line_cap = code if code
      end
      private_class_method :set_cap

      def self.set_join(canvas, raw)
        code = JOIN_MAP[raw]
        canvas.line_join = code if code
      end
      private_class_method :set_join

      def self.set_miter(canvas, raw)
        return unless raw

        value = raw.to_f
        return unless value >= 1.0

        canvas.miter_limit = value
      end
      private_class_method :set_miter

      def self.set_dash(canvas, raw)
        return unless raw

        array = parse_dash_array(raw)
        return unless array.length >= 2

        canvas.dash_pattern = [array, 0]
      end
      private_class_method :set_dash

      def self.parse_dash_array(raw)
        raw.to_s.split(/\s+/).map(&:to_f)
      end
      private_class_method :parse_dash_array
    end
  end
end
