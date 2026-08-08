# frozen_string_literal: true

module Idml
  module Render
    # Top-level pipeline: IDML Package → PDF file using pdfrb.
    # All PDF assembly is delegated to pdfrb; this class orchestrates
    # the high-level flow:
    #
    #   1. Build writer + set metadata.
    #   2. Apply compliance (PDF/A XMP + ICC) if requested.
    #   3. Set up structure tracker for tagged PDF.
    #   4. Resolve document font.
    #   5. For each spread: collect images, render pages, emit hyperlinks.
    #   6. Flush structure, emit bookmarks, subset fonts, write.
    class Pipeline
      DEFAULT_WIDTH = 612
      DEFAULT_HEIGHT = 792

      def initialize(package, output_path, font_search_paths = nil,
                     compliance: nil, tagged: false, subset_fonts: true,
                     compress: false)
        @package = package
        @output_path = output_path
        @font_search_paths = font_search_paths
        @compliance = compliance
        @tagged = tagged
        @subset_fonts = subset_fonts
        @compress = compress
      end

      def call
        writer = PdfrbWriter.new(compress: @compress)
        metadata = MetadataBuilder.new(@package).build
        writer.set_info(metadata)
        writer.enable_tagged if @tagged
        apply_compliance(writer, metadata) if pdfa_requested?

        structure = StructureTracker.new(enabled: @tagged)
        position_tracker = PositionTracker.new
        layer_filter = LayerFilter.from_designmap(@package.designmap)
        font_ref_resolver = FontReferenceResolver.build(@package)
        font_setup = FontSetup.new(package: @package,
                                   font_search_paths: @font_search_paths)
        font_resource = font_setup.register(writer)
        font_metrics = font_setup.metrics_for(writer, font_resource)
        font_map = font_setup.font_map(writer)

        page_index = -1
        @package.spreads.each do |spread|
          page_index = render_spread(writer, spread, layer_filter,
                                     font_ref_resolver, font_resource,
                                     font_metrics, font_map, structure,
                                     position_tracker, page_index)
        end

        structure.flush(writer)
        writer.build_structure if @tagged
        emit_bookmarks(writer)
        writer.subset_fonts! if @subset_fonts
        writer.write(@output_path)
        @output_path
      end

      private

      def apply_compliance(writer, metadata)
        PdfaPacket.attach(writer.document, metadata)
        bytes = IccProfile.srgb_bytes
        return unless bytes

        writer.document.output_intents.embed_icc(
          bytes,
          identifier: "sRGB",
          condition: "sRGB IEC61966-2.1",
          subtype: :GTS_PDFA1,
        )
      rescue StandardError
        nil
      end

      def pdfa_requested?
        @compliance&.to_s&.start_with?("pdfa")
      end

      def emit_bookmarks(writer)
        BookmarkResolver.new(@package).each do |title, page_index|
          writer.add_bookmark(title, page_index)
        end
      end

      def render_spread(writer, spread, layer_filter, font_ref_resolver,
                        font_resource, font_metrics, font_map, structure,
                        position_tracker, page_offset)
        pages = spread.spread.flat_map(&:page)
        image_refs = ImageCollector.new(writer: writer,
                                        base_dir: File.dirname(@package.path),
                                        page_height: DEFAULT_HEIGHT).collect(spread)
        renderer = build_renderer(layer_filter, font_ref_resolver,
                                  font_resource, font_metrics, font_map,
                                  structure, position_tracker)
        current = page_offset

        pages.each do |page|
          current += 1
          dims = page_dimensions_for(page)
          canvas = writer.add_page(width: dims[:width], height: dims[:height])
          renderer.render(canvas, spread, page_width: dims[:width],
                                          page_height: dims[:height],
                                          image_refs: image_refs,
                                          page_index: current)
          emit_hyperlinks(writer, spread, current, layer_filter,
                          position_tracker)
        end
        current
      end

      def emit_hyperlinks(writer, spread, page_index, layer_filter,
                          position_tracker)
        HyperlinkEmitter.new(writer: writer, package: @package,
                             page_height: DEFAULT_HEIGHT,
                             layer_filter: layer_filter,
                             position_tracker: position_tracker)
          .emit_for(spread, page_index)
      rescue StandardError
        nil
      end

      def build_renderer(layer_filter, font_ref_resolver, font_resource,
                         font_metrics, font_map, structure, position_tracker)
        SpreadRenderer.new(
          font_metrics: font_metrics,
          font_ps_name: font_resource,
          font_map: font_map,
          package: @package,
          layer_filter: layer_filter,
          font_ref_resolver: font_ref_resolver,
          structure: structure,
          position_tracker: position_tracker,
        )
      end

      def page_dimensions_for(page)
        { width: page.width || DEFAULT_WIDTH,
          height: page.height || DEFAULT_HEIGHT }
      end
    end
  end
end
