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
                     compliance: nil, tagged: false, subset_fonts: true)
        @package = package
        @output_path = output_path
        @font_search_paths = font_search_paths
        @compliance = compliance
        @tagged = tagged
        @subset_fonts = subset_fonts
      end

      def call
        writer = PdfrbWriter.new
        metadata = combined_metadata
        writer.set_info(metadata)
        writer.enable_tagged if @tagged
        PdfaPacket.attach(writer.document, metadata) if pdfa_requested?
        structure = StructureTracker.new(enabled: @tagged)
        layer_filter = LayerFilter.from_designmap(@package.designmap)
        font_ref_resolver = FontReferenceResolver.build(@package)
        base_dir = File.dirname(@package.path)
        font_resource = register_font(writer)
        font_metrics = build_font_metrics(writer, font_resource)
        page_index = -1

        @package.spreads.each do |spread|
          page_index = render_spread_pages(writer, spread, base_dir,
                                           layer_filter, font_ref_resolver,
                                           font_resource, font_metrics,
                                           structure, page_index)
        end

        structure.flush(writer)
        writer.build_structure if @tagged
        writer.subset_fonts! if @subset_fonts
        writer.write(@output_path)
        @output_path
      end

      private

      def pdfa_requested?
        @compliance&.to_s&.start_with?("pdfa")
      end

      def render_spread_pages(writer, spread, base_dir, layer_filter,
                              font_ref_resolver, font_resource, font_metrics,
                              structure, page_offset)
        pages = spread.spread.flat_map(&:page)
        image_refs = ImageCollector.new(writer: writer, base_dir: base_dir,
                                        page_height: DEFAULT_HEIGHT).collect(spread)
        renderer = build_renderer(layer_filter, font_ref_resolver,
                                  font_resource, font_metrics, structure: structure)
        current = page_offset

        pages.each do |page|
          current += 1
          dims = page_dimensions_for(page)
          canvas = writer.add_page(width: dims[:width], height: dims[:height])
          renderer.render(canvas, spread, page_width: dims[:width],
                                          page_height: dims[:height],
                                          image_refs: image_refs,
                                          page_index: current)
        end
        current
      end

      def build_renderer(layer_filter, font_ref_resolver, font_resource,
                         font_metrics, structure:)
        SpreadRenderer.new(
          font_metrics: font_metrics,
          font_ps_name: font_resource,
          package: @package,
          layer_filter: layer_filter,
          font_ref_resolver: font_ref_resolver,
          structure: structure,
        )
      end

      def page_dimensions_for(page)
        { width: page.width || DEFAULT_WIDTH,
          height: page.height || DEFAULT_HEIGHT }
      end

      def build_font_metrics(writer, font_resource)
        return nil if font_resource == Render::DEFAULT_FONT

        TextEngine::PdfrbFontMetrics.new(writer.document.fonts, font_resource)
      rescue StandardError
        nil
      end

      def register_font(writer)
        path = resolve_document_font_path
        return Render::DEFAULT_FONT unless path

        writer.register_font(path)
      rescue StandardError
        Render::DEFAULT_FONT
      end

      def font_resolver
        @font_resolver ||= Pdfrb::FontResolver.new(
          search_paths: @font_search_paths || Pdfrb::FontResolver::DEFAULT_SEARCH_PATHS,
        )
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

          path = font_resolver.find_by_ps_name(font.post_script_name)
          return path if path
        end
        nil
      end

      def combined_metadata
        defaults = default_metadata
        xmp_metadata.each do |key, value|
          next if value.nil? || value.empty?

          defaults[key] = value
        end
        defaults
      end

      def xmp_metadata
        return {} unless @package.has_part?(XMP_PATH)

        xml = @package.read_part(XMP_PATH)
        meta = Parts::XmpMeta.from_xml(xml)
        rdf = meta.rdf
        return {} unless rdf

        {
          Title: rdf.title,
          Author: rdf.author,
          Subject: rdf.description,
          Keywords: rdf.keywords,
          Creator: rdf.creator_tool,
          CreationDate: pdf_date_string(rdf.create_date),
          ModDate: pdf_date_string(rdf.modify_date),
        }
      rescue StandardError
        {}
      end

      def pdf_date_string(iso8601)
        return nil unless iso8601

        time = Time.iso8601(iso8601)
        pdf_date(time)
      rescue ArgumentError
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

      XMP_PATH = "META-INF/metadata.xml"
      private_constant :XMP_PATH
    end
  end
end
