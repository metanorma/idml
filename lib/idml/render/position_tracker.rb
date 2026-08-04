# frozen_string_literal: true

module Idml
  module Render
    # Accumulates positioned text ranges during TextFrame rendering.
    # Used by `HyperlinkEmitter` to compute precise per-source link
    # rects when text contains IDML hyperlinks.
    #
    # Lifecycle:
    #   1. Pipeline constructs one tracker per render.
    #   2. RenderContext carries it to renderers.
    #   3. TextFrameRenderer records each line's range after layout.
    #   4. HyperlinkEmitter queries for ranges overlapping each
    #      hyperlink source's character range.
    #
    # `PositionedRange` is a plain Struct so the data is trivially
    # shareable without coupling to any renderer implementation.
    class PositionTracker
      PositionedRange = Struct.new(
        :start_char, :end_char, :x, :y, :width, :height,
        keyword_init: true
      )

      def initialize
        @ranges_by_frame = {}
      end

      # Records a positioned range for a frame. `frame_self` is the
      # Self attribute of the TextFrame so multiple frames on the
      # same spread don't collide.
      def add(frame_self, start_char:, end_char:, x:, y:, width:, height:)
        bucket = @ranges_by_frame[frame_self] ||= []
        bucket << PositionedRange.new(
          start_char: start_char,
          end_char: end_char,
          x: x,
          y: y,
          width: width,
          height: height,
        )
      end

      # Returns the list of positioned ranges for a frame, or [].
      def ranges_for(frame_self)
        @ranges_by_frame[frame_self] || []
      end

      # Returns the bounding rect `[x1, y1, x2, y2]` covering all
      # ranges whose `[start_char, end_char]` intersects
      # `[from, to]`. Returns nil when no range overlaps.
      def rect_for_range(frame_self, from:, to:)
        matching = ranges_for(frame_self).select do |range|
          range.start_char < to && range.end_char > from
        end
        return nil if matching.empty?

        xs = matching.flat_map { |r| [r.x, r.x + r.width] }
        ys = matching.flat_map { |r| [r.y, r.y + r.height] }
        [xs.min, ys.min, xs.max, ys.max]
      end

      # Test helper: clears all recorded ranges.
      def clear
        @ranges_by_frame.clear
      end
    end
  end
end
