# frozen_string_literal: true

module Idml
  module Render
    # Top-level pipeline: IDML Package → PDF file using pdfrb.
    # All PDF assembly is delegated to Pdfrb::Document — no hand-rolled
    # PDF operators. Renderers receive a Pdfrb::Content::Canvas and
    # call drawing methods directly.
    class Pipeline
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      def initialize(package, output_path, font_search_paths = nil,
                     compliance: nil)
        @package = package
        @output_path = output_path
        @font_resolver = build_font_resolver(font_search_paths)
        @compliance = compliance
      end

      def call
        writer = PdfrbWriter.new
        writer.set_info(default_metadata)
        layer_filter = LayerFilter.from_designmap(@package.designmap)
        font_ref_resolver = FontReferenceResolver.build(@package)

        @package.spreads.each do |spread|
          render_spread_pages(writer, spread, layer_filter, font_ref_resolver)
        end

        writer.write(@output_path)
        @output_path
      end

      private

      def render_spread_pages(writer, spread, layer_filter, font_ref_resolver)
        pages = spread.spread.flat_map(&:page)

        pages.each do |page|
          dims = page_dimensions_for(page)
          canvas = writer.add_page(width: dims[:width], height: dims[:height])
          renderer = SpreadRenderer.new(
            font_resolver: @font_resolver,
            font_ps_name: Render::DEFAULT_FONT,
            package: @package,
            layer_filter: layer_filter,
            font_ref_resolver: font_ref_resolver,
          )
          renderer.render(canvas, spread, page_width: dims[:width],
                                        page_height: dims[:height])
        end
      end

      def page_dimensions_for(page)
        { width: page.width || DEFAULT_WIDTH,
          height: page.height || DEFAULT_HEIGHT }
      end

      def build_font_resolver(paths)
        search = paths || TextEngine::FontResolver::DEFAULT_SEARCH_PATHS
        TextEngine::FontResolver.new(search_paths: search)
      end

      def default_metadata
        {
          Producer: "idml gem v#{Idml::VERSION}",
          CreationDate: Time.now.utc.strftime("%Y-%m-%dT%H:%M:%SZ"),
        }
      end
    end
  end
end