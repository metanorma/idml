# frozen_string_literal: true

module Idml
  module Render
    # Top-level pipeline: IDML Package → PDF file.
    # Orchestrates font resolution, image collection, spread rendering,
    # and PDF writing. All data flows through typed models — no raw
    # XML parsing.
    class Pipeline
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      def initialize(package, output_path, font_search_paths = nil)
        @package = package
        @output_path = output_path
        @font_resolver = build_font_resolver(font_search_paths)
      end

      def call
        writer = PdfWriter.new
        base_dir = File.dirname(@package.path)
        font_ps_name = register_font(writer)
        writer.set_info(default_metadata)
        layer_filter = LayerFilter.from_designmap(@package.designmap)

        @package.spreads.each do |spread|
          dims = spread.page_dimensions.first || { width: DEFAULT_WIDTH,
                                                   height: DEFAULT_HEIGHT }
          image_refs = collect_images(writer, spread, base_dir, layer_filter)
          content = render_spread(spread, dims, image_refs, font_ps_name,
                                  layer_filter)
          writer.add_page(
            width: dims[:width],
            height: dims[:height],
            content: content,
            fonts: { "F1" => font_ps_name },
            xobjects: image_refs.map { |r| r[:name] },
          )
        end

        writer.write(@output_path)
        @output_path
      end

      private

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

      def collect_images(writer, spread, base_dir, layer_filter)
        refs = []
        spread.each_page_item do |item|
          next unless layer_filter.visible?(item)

          images_for_item(item).each do |img|
            ref = register_image(writer, img, item, base_dir)
            refs << ref if ref
          end
        end
        refs
      end

      def images_for_item(item)
        case item
        when Idml::Elements::Rectangle, Idml::Elements::Polygon
          item.image
        else
          []
        end
      end

      def register_image(writer, image, parent, base_dir)
        path = resolve_image_path(image, base_dir)
        return nil unless path

        data = File.binread(path)
        format = Render::Image.detect_format(data)
        return nil unless format

        dims = image_dimensions_for(data, format)
        return nil unless dims

        name = writer.add_image(data: data)
        return nil unless name

        { name: name, placement: compute_placement_for(image, parent, dims[1]) }
      end

      def resolve_image_path(image, base_dir)
        uri = image.resource_uri
        return nil unless uri

        path = Render::Image.resolve_path(uri, base_dir: base_dir)
        File.exist?(path) ? path : nil
      end

      def image_dimensions_for(data, format)
        if format == :png
          Render::Image.png_dimensions(data)
        else
          Render::Image.jpeg_dimensions(data)
        end
      end

      def compute_placement_for(image, parent, pixel_height)
        Render::Image.compute_placement(
          image_transform: parse_transform_safe(image.item_transform),
          parent_transform: parse_transform_safe(parent.item_transform),
          pixel_height: pixel_height,
          page_height: DEFAULT_HEIGHT,
        )
      end

      def parse_transform_safe(str)
        Render::Image.parse_transform(str) || Render::Image.identity
      end

      def render_spread(spread, dims, image_refs, font_ps_name, layer_filter)
        renderer = SpreadRenderer.new(
          font_resolver: @font_resolver,
          font_ps_name: font_ps_name,
          package: @package,
          layer_filter: layer_filter,
        )
        renderer.render(spread, page_width: dims[:width],
                                page_height: dims[:height],
                                image_refs: image_refs)
      end

      def build_font_resolver(paths)
        search = paths || TextEngine::FontResolver::DEFAULT_SEARCH_PATHS
        TextEngine::FontResolver.new(search_paths: search)
      end

      def default_metadata
        {
          Producer: "idml gem v#{Idml::VERSION}",
          CreationDate: pdf_date(Time.now.utc),
        }
      end

      def pdf_date(time)
        time.strftime("D:%Y%m%d%H%M%S+00'00'")
      end
    end
  end
end
