# frozen_string_literal: true

module Idml
  module Render
    # Resolves a page item's geometric placement on the PDF page.
    # Encapsulates the read of `geometric_bounds` and `item_transform`
    # from any page-item model and the subsequent transform into a
    # PDF-coordinate `{ x:, y:, width:, height: }` rect via `Geometry`.
    #
    # This is the single source of truth for "where does this item
    # draw" — every shape renderer goes through here instead of each
    # one re-implementing the bounds/transform dance.
    module Placement
      FALLBACK = { x: 72.0, y: 72.0, width: 400.0, height: 600.0 }.freeze

      # Returns the PDF-placement rect for the given page item, or
      # `nil` when the item has no geometric bounds. Pass
      # `fallback: true` to receive a default rect instead of nil
      # (used by text frames that need *somewhere* to render even
      # when geometry is absent).
      def self.box(item, page_height, fallback: false)
        bounds = item.geometric_bounds
        if bounds
          Geometry.placement_rect(bounds, item.item_transform, page_height)
        elsif fallback
          FALLBACK.dup.merge(y: page_height - FALLBACK[:height] - 72.0)
        end
      end
    end
  end
end
