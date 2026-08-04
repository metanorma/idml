# frozen_string_literal: true

module Idml
  module Render
    # Resolves IDML bookmarks to (title, page_index) pairs ready for
    # `PdfrbWriter#add_bookmark`. Uses the document's designmap to
    # look up:
    #
    #   Bookmark#destination (Self) →
    #     HyperlinkPageDestination#destination_page (Page Self) →
    #       PDF page index (via spread iteration)
    #
    # Bookmarks whose destination chain cannot be resolved are
    # skipped silently.
    class BookmarkResolver
      def initialize(package)
        @package = package
      end

      # Yields [title, page_index] pairs for each resolvable bookmark.
      def each
        return enum_for(:each) unless block_given?

        bookmarks.each do |bookmark|
          entry = resolve(bookmark)
          yield entry if entry
        end
      end

      private

      def bookmarks
        designmap&.bookmark || []
      end

      def designmap
        @package&.designmap
      end

      def resolve(bookmark)
        destination = destination_by_self(bookmark.destination)
        return nil unless destination&.destination_page

        page_index = page_index_by_self(destination.destination_page)
        return nil unless page_index

        title = bookmark.name || destination.name || "Bookmark"
        [title, page_index]
      end

      def destination_by_self(self_attr)
        return nil unless self_attr

        destinations.find { |d| d.self_attr == self_attr }
      end

      def destinations
        designmap&.hyperlink_page_destination || []
      end

      def page_index_by_self(page_self)
        page_self_table[page_self]
      end

      def page_self_table
        @page_self_table ||= begin
          table = {}
          @package.spreads.each_with_index do |spread, spread_idx|
            spread_pages = spread.spread.flat_map(&:page)
            spread_pages.each_with_index do |page, page_idx|
              table[page.self_attr] = cumulative_page_index(spread_idx, page_idx)
            end
          end
          table
        end
      end

      def cumulative_page_index(spread_idx, page_idx)
        prior_pages = 0
        @package.spreads.first(spread_idx).each do |spread|
          prior_pages += spread.spread.flat_map(&:page).length
        end
        prior_pages + page_idx
      end
    end
  end
end
