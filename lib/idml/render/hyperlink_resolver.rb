# frozen_string_literal: true

module Idml
  module Render
    # Resolves IDML hyperlink definitions to URL destinations. Looks
    # up `Hyperlink#source` → `Hyperlink#destination` →
    # `HyperlinkURLDestination#destination_url` from the designmap.
    #
    # The renderer is responsible for mapping source Self IDs to
    # page-item rectangles; this resolver only handles the
    # destination lookup.
    class HyperlinkResolver
      def initialize(package)
        @package = package
      end

      # Returns the URL for the given hyperlink-source Self, or nil.
      def url_for_source(source_self)
        return nil unless source_self

        hyperlink = hyperlink_by_source(source_self)
        return nil unless hyperlink

        url_destination_by_self(hyperlink.destination)&.destination_url
      end

      # Yields [source_self, url] for every visible hyperlink whose
      # destination chain resolves to a URL.
      def each_visible
        return enum_for(:each_visible) unless block_given?

        hyperlinks.each do |hyperlink|
          entry = visible_entry(hyperlink)
          yield(*entry) if entry
        end
      end

      private

      def visible_entry(hyperlink)
        return nil if hyperlink.visible == false || hyperlink.hidden == true

        url = url_destination_by_self(hyperlink.destination)&.destination_url
        return nil unless url

        [hyperlink.source, url]
      end

      def hyperlinks
        @package&.designmap&.hyperlink || []
      end

      def hyperlink_by_source(source_self)
        hyperlinks.find { |h| h.source == source_self }
      end

      def url_destination_by_self(self_attr)
        return nil unless self_attr

        url_destinations.find { |d| d.self_attr == self_attr }
      end

      def url_destinations
        @package&.designmap&.hyperlink_url_destination || []
      end
    end
  end
end
