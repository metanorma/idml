# frozen_string_literal: true

module Idml
  module Render
    # Emits PDF Link annotations for IDML hyperlinks. After a spread
    # renders, walk each visible text frame, look up its story's
    # hyperlink sources, resolve each to a URL via HyperlinkResolver,
    # and emit `/Subtype /Link` annotations.
    #
    # When a PositionTracker is supplied (render path), link rects
    # are computed from the tracker's recorded line positions —
    # giving per-source rect precision instead of frame-level.
    # Without a tracker, links fall back to the frame's bounding
    # box (the original TODO 78 behavior).
    class HyperlinkEmitter
      def initialize(writer:, package:, page_height:, layer_filter: nil,
                     position_tracker: nil)
        @writer = writer
        @package = package
        @resolver = HyperlinkResolver.new(package)
        @page_height = page_height
        @layer_filter = layer_filter
        @position_tracker = position_tracker
      end

      def emit_for(spread, page_index)
        each_text_frame_on(spread) do |frame|
          emit_for_frame(frame, page_index)
        end
      end

      private

      def each_text_frame_on(spread)
        spread.each_page_item do |item|
          next unless item.is_a?(Idml::Elements::TextFrame)
          next if @layer_filter && !@layer_filter.visible?(item)

          yield item
        end
      end

      def emit_for_frame(frame, page_index)
        sources = sources_for_frame(frame)
        return if sources.empty?

        if @position_tracker && frame.self_attr
          emit_precise_rects(frame, sources, page_index)
        else
          emit_frame_level_rect(frame, sources, page_index)
        end
      end

      def emit_precise_rects(frame, sources, page_index)
        frame_self = frame.self_attr
        source_ranges = source_char_ranges_for_frame(frame)

        sources.each do |source_self, url|
          range = source_ranges[source_self]
          rect = if range
                   @position_tracker.rect_for_range(
                     frame_self, from: range[0], to: range[1]
                   )
                 else
                   @position_tracker.rect_for_range(
                     frame_self, from: 0, to: 1_000_000
                   )
                 end || frame_level_rect(frame)
          next unless rect

          @writer.add_uri_link_annotation(page_index: page_index, rect: rect,
                                          url: url)
        end
      end

      # Returns a map of source_self -> [start_char, end_char] across
      # all CSRs in the frame's story. Character positions are
      # absolute within the story text, matching the cursor used by
      # `TextFrameRenderer#record_position`.
      def source_char_ranges_for_frame(frame)
        story = frame.parent_story ? @package.story_by_id(frame.parent_story) : nil
        return {} unless story&.inner

        cursor = [0]
        ranges = {}
        walk_attribution(story.inner, cursor, ranges)
        ranges
      end

      def walk_attribution(story_inner, cursor, ranges)
        story_inner.paragraph_style_range.each do |psr|
          psr.character_style_range.each do |csr|
            csr.attributed_text.each do |tuple|
              record_tuple(tuple, cursor, ranges)
            end
          end
        end
      end

      def record_tuple(tuple, cursor, ranges)
        source = tuple[:source_self]
        if source
          ranges[source] ||= [cursor[0], cursor[0]]
          ranges[source][1] = cursor[0] + 1
        end
        cursor[0] += 1
      end

      def emit_frame_level_rect(frame, sources, page_index)
        rect = frame_level_rect(frame)
        return unless rect

        sources.each_value do |url|
          @writer.add_uri_link_annotation(page_index: page_index, rect: rect,
                                          url: url)
        end
      end

      def frame_level_rect(frame)
        box = Placement.box(frame, @page_height)
        return nil unless box

        [box[:x], box[:y], box[:x] + box[:width], box[:y] + box[:height]]
      end

      def sources_for_frame(frame)
        story = frame.parent_story ? @package.story_by_id(frame.parent_story) : nil
        return [] unless story

        sources = hyperlink_sources_in(story)
        sources.filter_map do |source|
          url = @resolver.url_for_source(source.self_attr)
          next unless url

          [source.self_attr, url]
        end
      end

      def hyperlink_sources_in(story)
        inner = story&.inner
        return [] unless inner

        inner.paragraph_style_range.flat_map do |psr|
          psr.character_style_range.flat_map(&:hyperlink_text_source)
        end.compact
      end
    end
  end
end
