# frozen_string_literal: true

module Idml
  module Render
    # Emits PDF Link annotations for IDML hyperlinks. After a spread
    # renders, walk each visible text frame, look up its story's
    # hyperlink sources, resolve each to a URL via HyperlinkResolver,
    # and emit a `/Subtype /Link` annotation over the frame's box.
    #
    # Limitation: this implementation is frame-level, not text-range
    # level. The link covers the entire text frame rather than just
    # the source's TextRange. Precise per-range rects require deeper
    # integration with the text engine — see TODO 78.
    class HyperlinkEmitter
      def initialize(writer:, package:, page_height:, layer_filter: nil)
        @writer = writer
        @package = package
        @resolver = HyperlinkResolver.new(package)
        @page_height = page_height
        @layer_filter = layer_filter
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
        urls = urls_for_frame(frame)
        return if urls.empty?

        box = Placement.box(frame, @page_height)
        return unless box

        urls.each do |url|
          @writer.add_uri_link_annotation(
            page_index: page_index,
            rect: rect_for(box),
            url: url,
          )
        end
      end

      def urls_for_frame(frame)
        story = frame.parent_story ? @package.story_by_id(frame.parent_story) : nil
        return [] unless story

        sources = hyperlink_sources_in(story)
        sources.filter_map { |source| @resolver.url_for_source(source.self_attr) }
      end

      def hyperlink_sources_in(story)
        inner = story&.inner
        return [] unless inner

        inner.paragraph_style_range.flat_map do |psr|
          psr.character_style_range.flat_map(&:hyperlink_text_source)
        end.compact
      end

      def rect_for(box)
        [box[:x], box[:y], box[:x] + box[:width], box[:y] + box[:height]]
      end
    end
  end
end
