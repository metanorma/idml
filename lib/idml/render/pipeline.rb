# frozen_string_literal: true

module Idml
  module Render
    # Top-level pipeline: IDML Package → PDF file.
    # Orchestrates font resolution, spread rendering, and PDF writing.
    class Pipeline
      PAGE_WIDTH = 612
      PAGE_HEIGHT = 792

      def initialize(package, output_path, font_search_paths = nil)
        @package = package
        @output_path = output_path
        @font_resolver = build_font_resolver(font_search_paths)
      end

      def call
        writer = PdfWriter.new
        base_dir = File.dirname(@package.path)
        font_resource = register_font(writer)

        spread_names.each do |name|
          raw_xml = @package.read_part(name)
          image_refs = collect_images(writer, raw_xml, base_dir)
          content = render_spread(raw_xml, image_refs)
          writer.add_page(
            width: PAGE_WIDTH,
            height: PAGE_HEIGHT,
            content: content,
            fonts: { "F1" => font_resource },
            xobjects: image_refs.map { |r| r[:name] },
          )
        end

        writer.write(@output_path)
        @output_path
      end

      private

      # Returns the PS name to use in page font resources. When the
      # resolver finds a TrueType file for the default font, it is
      # embedded (FontFile2). Otherwise falls back to Type1 base-14.
      def register_font(writer)
        return Render::DEFAULT_FONT unless @font_resolver

        font = @font_resolver.resolve(
          family_name: Render::DEFAULT_FONT, style_name: "Regular",
        )
        return Render::DEFAULT_FONT unless font

        data = Render::FontEmbedder.raw_font_data(font)
        writer.register_embedded_font(metrics: font, data: data)
      rescue StandardError
        Render::DEFAULT_FONT
      end

      def spread_names
        @package.part_names.grep(%r{\ASpreads/Spread_})
      end

      # Extract image references, register each JPEG as a PDF XObject,
      # and compute placement for the renderer.
      def collect_images(writer, raw_xml, base_dir)
        Render::Image.extract_from_spread(raw_xml).filter_map do |ref|
          path = Render::Image.resolve_path(ref[:uri], base_dir: base_dir)
          next unless File.exist?(path)

          data = File.binread(path)
          dims = Render::Image.jpeg_dimensions(data)
          next unless dims

          name = writer.add_jpeg_image(
            data: data, width: dims[0], height: dims[1],
            colorspace: Render::Image.jpeg_colorspace(data) || :DeviceRGB
          )
          placement = Render::Image.compute_placement(
            image_transform: ref[:transform],
            parent_transform: ref[:parent_transform],
            pixel_height: dims[1],
            page_height: PAGE_HEIGHT,
          )
          { name: name, placement: placement }
        end
      end

      def render_spread(raw_xml, image_refs)
        renderer = SpreadRenderer.new(font_resolver: @font_resolver)
        renderer.render(raw_xml, page_width: PAGE_WIDTH,
                                 page_height: PAGE_HEIGHT,
                                 image_refs: image_refs)
      end

      def build_font_resolver(paths)
        search = paths || TextEngine::FontResolver::DEFAULT_SEARCH_PATHS
        TextEngine::FontResolver.new(search_paths: search)
      end
    end
  end
end
