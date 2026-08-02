# frozen_string_literal: true

module Idml
  module Render
    # Resolves IDML font references (family names, font Self IDs, or
    # CharacterStyleRange#applied_font values) to PostScriptNames.
    # Built from the document's Fonts.xml (FontFamily → Font entries).
    # Used by TextFrameRenderer to select per-run fonts.
    class FontReferenceResolver
      def self.build(package)
        new(build_table(package))
      end

      def self.build_table(package)
        return {} unless package&.fonts

        table = {}
        package.fonts.font_family.each do |family|
          register_family(table, family)
        end
        table
      end

      def self.register_family(table, family)
        family.font.each do |font|
          next unless font.post_script_name

          # Map by FontFamily#name (e.g., "Minion Pro")
          table[family.name] = font.post_script_name if family.name
          # Map by Font#name (e.g., "Minion Pro Regular")
          table[font.name] = font.post_script_name if font.name
          # Map by Font#font_style_name (e.g., "Regular") within family
          table[font.font_style_name] = font.post_script_name if font.font_style_name
        end
      end
      private_class_method :register_family

      def initialize(table)
        @table = table
      end

      # Resolve a font reference (family name, font name, or Self ID).
      # Returns the PostScriptName or nil if not found.
      def resolve(reference)
        return nil unless reference

        @table[reference]
      end
    end
  end
end
