# frozen_string_literal: true

module Idml
  module Render
    # Resolves the document font and wraps it in a
    # `TextEngine::PdfrbFontMetrics` adapter. Encapsulates:
    #
    #   1. Finding the IDML document's first non-missing font file
    #      via `Pdfrb::FontResolver#find_by_ps_name`.
    #   2. Registering that file with pdfrb's Fonts collection.
    #   3. Wrapping the resulting Symbol resource in
    #      `PdfrbFontMetrics` for the text engine.
    #
    # Extracted from `Pipeline` for SRP — Pipeline orchestrates,
    # this object owns the font-setup dance.
    class FontSetup
      DEFAULT_FONT = Render::DEFAULT_FONT

      def initialize(package:, font_search_paths: nil)
        @package = package
        @font_search_paths = font_search_paths
      end

      # Registers the resolved font with `writer` and returns the
      # Symbol resource. Falls back to `Render::DEFAULT_FONT`
      # (`"Helvetica"`) when the document has no resolvable font.
      def register(writer)
        path = resolve_document_font_path
        return DEFAULT_FONT unless path

        writer.register_font(path)
      rescue StandardError
        DEFAULT_FONT
      end

      # Wraps a registered font resource in a PdfrbFontMetrics
      # adapter. Returns nil when the resource is the default
      # fallback (no real metrics available).
      def metrics_for(writer, font_resource)
        return nil if font_resource == DEFAULT_FONT

        TextEngine::PdfrbFontMetrics.new(writer.document.fonts, font_resource)
      rescue StandardError
        nil
      end

      private

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

          path = resolver.find_by_ps_name(font.post_script_name)
          return path if path
        end
        nil
      end

      def resolver
        @resolver ||= Pdfrb::FontResolver.new(
          search_paths: @font_search_paths || Pdfrb::FontResolver::DEFAULT_SEARCH_PATHS,
        )
      end
    end
  end
end
