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

      # Style names treated as the "Regular" default for body text,
      # in priority order. Used to pick the right font from a family
      # when no per-run `AppliedFont` is specified — matches
      # InDesign's default-text-font behavior.
      REGULAR_STYLE_NAMES = %w[Regular Normal Book Roman].freeze

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

      # Pre-registers every non-missing font in the document and
      # returns a map of family_name → pdfrb Symbol resource. Used
      # by the renderer to resolve per-run AppliedFont references.
      # Falls back to DEFAULT_FONT for families that can't be resolved.
      def font_map(writer)
        map = {}
        return map unless @package&.fonts

        @package.fonts.font_family.each do |family|
          next unless family.name

          map[family.name] = resource_for_family(writer, family)
        end
        map
      end

      # True if at least one non-missing font declared in the
      # document can be located on disk. Lets callers (and tests)
      # gate font-embedding assertions on the document's fonts
      # actually being installed, rather than silently falling
      # back to the default.
      def font_resolvable?
        !resolve_document_font_path.nil?
      end

      def resource_for_family(writer, family)
        path = find_font_file(family)
        return DEFAULT_FONT unless path

        writer.register_font(path)
      rescue StandardError
        DEFAULT_FONT
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
        regular = find_regular_font(family)
        return regular if regular

        # Fall back to the first non-missing font.
        family.font.each do |font|
          next unless font.post_script_name
          next if font.status == "Missing"

          path = resolver.find_by_ps_name(font.post_script_name)
          return path if path
        end
        nil
      end

      # Pick the first "Regular" / "Normal" / "Book" / "Roman" font
      # in the family. This matches InDesign's default body-text
      # behavior, which prefers Regular weight over the first font
      # listed in the family.
      def find_regular_font(family)
        family.font.each do |font|
          next unless font.post_script_name
          next if font.status == "Missing"
          next unless regular_style?(font.font_style_name)

          path = resolver.find_by_ps_name(font.post_script_name)
          return path if path
        end
        nil
      end

      def regular_style?(style_name)
        return false unless style_name

        REGULAR_STYLE_NAMES.any?(style_name)
      end

      def resolver
        @resolver ||= Pdfrb::FontResolver.new(
          search_paths: @font_search_paths || Pdfrb::FontResolver::DEFAULT_SEARCH_PATHS,
        )
      end
    end
  end
end
