# frozen_string_literal: true

module Idml
  module Render
    # Top-level pipeline: IDML Package → PDF file.
    # Orchestrates font resolution, spread rendering, and PDF writing.
    class Pipeline
      def initialize(package, output_path, font_search_paths = nil)
        @package = package
        @output_path = output_path
        @font_resolver = build_font_resolver(font_search_paths)
      end

      def call
        writer = PdfWriter.new
        spreads = @package.spreads

        spreads.each do |spread|
          content = render_spread(spread)
          writer.add_page(
            width: 612,
            height: 792,
            content: content,
            fonts: { "F1" => Render::DEFAULT_FONT },
          )
        end

        writer.write(@output_path)
        @output_path
      end

      private

      def render_spread(spread)
        renderer = SpreadRenderer.new(font_resolver: @font_resolver)
        renderer.render(spread, page_width: 612, page_height: 792)
      end

      def build_font_resolver(paths)
        search = paths || TextEngine::FontResolver::DEFAULT_SEARCH_PATHS
        TextEngine::FontResolver.new(search_paths: search)
      end
    end
  end
end
