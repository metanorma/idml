# frozen_string_literal: true

module Idml
  module Render
    # Maps IDML page-item classes to PDF structure types (PDF 1.7
    # §14.8.4). Each visible page item becomes one structure element
    # when tagged output is enabled.
    #
    # Mapping rationale:
    #   TextFrame → P (paragraph)
    #   Group     → Sect (section, contains children)
    #   Table     → Table
    #   Rectangle/Polygon with image → Figure
    #   Rectangle/Polygon without image → Path (decorative shape)
    #   GraphicLine → Path
    #
    # The PDF spec reserves lowercase for standard types; pdfrb's
    # `add_element(type:)` accepts a Symbol which is serialised as
    # `/Type`. We use Title-case Symbols to match the spec's typical
    # spelling (P, Sect, Table, Figure, Path).
    module StructureMapper
      def self.type_for(item)
        case item
        when Idml::Elements::TextFrame then :P
        when Idml::Elements::Group then :Sect
        when Idml::Elements::Table then :Table
        when Idml::Elements::GraphicLine then :Path
        when Idml::Elements::Rectangle, Idml::Elements::Polygon
          shape_type(item)
        end
      end

      def self.shape_type(item)
        image?(item) ? :Figure : :Path
      end
      private_class_method :shape_type

      # Optional `Alt` text for Figure elements. IDML doesn't have a
      # dedicated alt-text attribute on `<Image>`, but the parent
      # page item's `Name` (if present) is a useful fallback.
      def self.alt_for(item)
        case item
        when Idml::Elements::Rectangle, Idml::Elements::Polygon
          image?(item) ? item.name : nil
        end
      end

      def self.image?(item)
        Array(item.image).any?
      end
      private_class_method :image?
    end
  end
end
