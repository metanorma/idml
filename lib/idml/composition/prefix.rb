# frozen_string_literal: true

module Idml
  module Composition
    # Prefix every `Self` attribute value across every part of a package
    # so it can be safely composed with another package without ID
    # collisions. This is the foundation operation — every other
    # composition op (InsertIdml, AddPageFromIdml) prefixes the source
    # package first.
    #
    # Returns a new Package; the receiver is unchanged. Round-trips
    # through Package#each_part + Package.write — does not require typed
    # models to be complete.
    class Prefix
      def initialize(package)
        @package = package
      end

      def call(prefix:)
        parts = @package.each_part.to_a.to_h do |name, xml|
          [name, prefix_references(name, xml, prefix)]
        end
        Package.write(parts: parts, to: tmp_path)
      end

      private

      # Rewrite every Self reference in the package: the `Self="..."`
      # attribute, plus every attribute that holds a Self-id reference
      # (StoryList, ActiveLayer, FillColor, StrokeColor, ParentStory,
      # XMLContent, etc.). All are prefixed the same way to keep
      # cross-part references intact.
      def prefix_references(name, xml, prefix)
        return xml if name == "mimetype"

        # Space-separated Self id lists (StoryList, UnusedSwatches,
        # CMYKProfileList, etc.).
        xml = prefix_space_list(xml, prefix, "StoryList")
        xml = prefix_space_list(xml, prefix, "UnusedSwatches")
        xml = prefix_space_list(xml, prefix, "CMYKProfileList")
        xml = prefix_space_list(xml, prefix, "RGBProfileList")

        # Single Self-id references. XMLContent holds a Story Self when
        # an XMLElement points at a story. ActiveLayer is a layer Self.
        # The remaining graphic/style references point at color/gradient
        # Swatch Selfs.
        single_id_attrs = %w[
          Self ActiveLayer ParentStory XMLContent FillColor StrokeColor
          AppliedParagraphStyle AppliedCharacterStyle AppliedNamedGrid
          AppliedLayer AppliedTOCStyle
          AppliedObjectStyle AppliedCellStyle AppliedTableStyle
          GradientFillStartColor GradientFillEndColor StrokeColor
          MarkupTag
        ]
        single_id_attrs.each do |attr|
          xml = xml.gsub(/#{attr}="([^"]+)"/) do
            next %(#{attr}="#{Regexp.last_match(1)}") if Regexp.last_match(1).empty?
            next %(#{attr}="#{Regexp.last_match(1)}") if Regexp.last_match(1).start_with?("$ID/")

            %(#{attr}="#{prefix}#{Regexp.last_match(1)}")
          end
        end
        xml
      end

      def prefix_space_list(xml, prefix, attr)
        xml.gsub(/#{attr}="([^"]+)"/) do
          values = Regexp.last_match(1).split.map { |v| "#{prefix}#{v}" }
          %(#{attr}="#{values.join(' ')}")
        end
      end

      def tmp_path
        @tmp_path ||= File.join(Dir.mktmpdir, "prefixed.idml")
      end
    end
  end
end
