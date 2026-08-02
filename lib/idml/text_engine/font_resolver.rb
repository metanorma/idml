# frozen_string_literal: true

module Idml
  module TextEngine
    # Maps IDML font references (family + style name) to .ttf/.otf
    # file paths on disk via Fontisan. Searches system font dirs and
    # any user-configured search paths.
    class FontResolver
      DEFAULT_SEARCH_PATHS = [
        "/System/Library/Fonts",
        "/Library/Fonts",
        File.expand_path("~/Library/Fonts"),
        "/usr/share/fonts",
        File.expand_path("~/.local/share/fonts"),
      ].freeze

      STYLE_ALIASES = {
        "Regular" => %w[Regular Normal Book Roman Medium],
        "Bold" => %w[Bold Semibold Heavy Black],
        "Italic" => %w[Italic Oblique Slanted],
        "Bold Italic" => %w[Bold\ Italic BoldOblique SemiboldItalic],
      }.freeze

      def initialize(search_paths: DEFAULT_SEARCH_PATHS)
        @search_paths = search_paths
        @cache = {}
      end

      def resolve(family_name:, style_name: "Regular")
        key = [family_name, style_name]
        @cache[key] ||= find_font(family_name, style_name)
      end

      # Search by PostScriptName (e.g., "MinionPro-Regular").
      # More precise than family+style — maps directly to the font's
      # internal PostScript name. Used when the IDML document references
      # a specific PostScriptName from Fonts.xml.
      def resolve_by_ps_name(ps_name)
        return nil unless ps_name

        @ps_cache ||= {}
        return @ps_cache[ps_name] if @ps_cache.key?(ps_name)

        @ps_cache[ps_name] = find_by_ps_name(ps_name)
      end

      private

      def find_by_ps_name(ps_name)
        @search_paths.each do |dir|
          next unless Dir.exist?(dir)

          Dir.glob(File.join(dir, "**", "*.ttf")).each do |path|
            font = safe_load(path)
            next unless font

            return FontMetrics.open(path) if font.postscript_name == ps_name
          end
          Dir.glob(File.join(dir, "**", "*.otf")).each do |path|
            font = safe_load(path)
            next unless font

            return FontMetrics.open(path) if font.postscript_name == ps_name
          end
        end
        nil
      end

      def find_font(family, style)
        candidates = STYLE_ALIASES[style] || [style]
        @search_paths.each do |dir|
          next unless Dir.exist?(dir)

          Dir.glob(File.join(dir, "**", "*.ttf")).each do |path|
            font = safe_load(path)
            next unless font

            return FontMetrics.open(path) if matches?(font, family, candidates)
          end
          Dir.glob(File.join(dir, "**", "*.otf")).each do |path|
            font = safe_load(path)
            next unless font

            return FontMetrics.open(path) if matches?(font, family, candidates)
          end
        end
        nil
      end

      def matches?(font, family, style_candidates)
        return false unless font.family_name.match?(/#{Regexp.escape(family)}/i)

        style_candidates.any? do |s|
          font.style_name.match?(/#{Regexp.escape(s)}/i)
        end
      end

      def safe_load(path)
        FontMetrics.open(path)
      rescue StandardError
        nil
      end
    end
  end
end
