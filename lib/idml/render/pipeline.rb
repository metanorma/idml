# frozen_string_literal: true

module Idml
  module Render
    # Top-level pipeline: IDML Package → PDF file using pdfrb.
    # All PDF assembly is delegated to Pdfrb::Document. Renderers
    # receive a Pdfrb::Content::Canvas and call drawing methods.
    class Pipeline
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      def initialize(package, output_path, font_search_paths = nil,
                     compliance: nil, tagged: false)
        @package = package
        @output_path = output_path
        @font_resolver = build_font_resolver(font_search_paths)
        @compliance = compliance
        @tagged = tagged
      end

      def call
        writer = PdfrbWriter.new
        writer.set_info(default_metadata)
        writer.enable_tagged if @tagged
        layer_filter = LayerFilter.from_designmap(@package.designmap)
        font_ref_resolver = FontReferenceResolver.build(@package)
        base_dir = File.dirname(@package.path)
        font_name = register_font(writer)

        @package.spreads.each do |spread|
          render_spread_pages(writer, spread, base_dir, layer_filter,
                              font_ref_resolver, font_name)
        end

        writer.build_structure if @tagged
        writer.write(@output_path)
        @output_path
      end

      private

      def render_spread_pages(writer, spread, base_dir, layer_filter,
                              font_ref_resolver, font_name)
        pages = spread.spread.flat_map(&:page)
        image_refs = collect_images(writer, spread, base_dir, layer_filter)

        pages.each do |page|
          dims = page_dimensions_for(page)
          canvas = writer.add_page(width: dims[:width], height: dims[:height])
          renderer = SpreadRenderer.new(
            font_resolver: @font_resolver,
            font_ps_name: font_name,
            package: @package,
            layer_filter: layer_filter,
            font_ref_resolver: font_ref_resolver,
          )
          renderer.render(canvas, spread, page_width: dims[:width],
                                          page_height: dims[:height],
                                          image_refs: image_refs)
        end
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
        uri = image.resource_uri
        return nil unless uri

        existing = writer.image_name_for(uri)
        return reuse_image(writer, existing, image, parent) if existing

        load_new_image(writer, image, parent, base_dir, uri)
      end

      def reuse_image(_writer, name, image, parent)
        { name: name, placement: compute_placement(image, parent),
          clip_box: parent_clip_box(parent) }
      end

      def load_new_image(writer, image, parent, base_dir, uri)
        path = Image.resolve_path(uri, base_dir: base_dir)
        return nil unless File.exist?(path)

        data = File.binread(path)
        dims = image_dimensions(data)
        return nil unless dims

        name = writer.add_image(data: data)
        writer.register_image_name(uri, name)
        { name: name, placement: compute_placement(image, parent, dims[1]),
          clip_box: parent_clip_box(parent) }
      end

      def parent_clip_box(parent)
        return nil unless parent.geometric_bounds

        Geometry.placement_rect(parent.geometric_bounds,
                                parent.item_transform, DEFAULT_HEIGHT)
      end

      def image_dimensions(data)
        format = Image.detect_format(data)
        return nil unless format

        if format == :png
          Image.png_dimensions(data)
        else
          Image.jpeg_dimensions(data)
        end
      end

      def compute_placement(image, parent, pixel_height = 100)
        Image.compute_placement(
          image_transform: parse_transform_safe(image.item_transform),
          parent_transform: parse_transform_safe(parent.item_transform),
          pixel_height: pixel_height,
          page_height: DEFAULT_HEIGHT,
        )
      end

      def parse_transform_safe(str)
        Image.parse_transform(str) || Image.identity
      end

      def page_dimensions_for(page)
        { width: page.width || DEFAULT_WIDTH,
          height: page.height || DEFAULT_HEIGHT }
      end

      def build_font_resolver(paths)
        search = paths || TextEngine::FontResolver::DEFAULT_SEARCH_PATHS
        TextEngine::FontResolver.new(search_paths: search)
      end

      def register_font(writer)
        return Render::DEFAULT_FONT unless @font_resolver

        path = resolve_document_font_path
        return Render::DEFAULT_FONT unless path

        writer.register_font(path)
      rescue StandardError
        Render::DEFAULT_FONT
      end

      def resolve_document_font_path
        return nil unless @package&.fonts

        @package.fonts.font_family.each do |family|
          path = find_font_file(family)
          return path if path
        end
        nil
      end

      def find_font_file(family)
        family.font.each do |font|
          next unless font.post_script_name
          next if font.status == "Missing"

          metrics = @font_resolver.resolve_by_ps_name(font.post_script_name)
          return metrics.path if metrics
        end
        nil
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
