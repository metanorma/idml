# frozen_string_literal: true

module Idml
  module Elements
    # `<InsetSpacing>` inside TextFramePreference's Properties —
    # the schema-faithful carrier of text frame insets (the
    # spec's examples 31/32): a single `type="unit"` value applies
    # to all sides; a `type="list"` of ListItems carries
    # [top, right, bottom, left].
    class InsetSpacing < Lutaml::Model::Serializable
      attribute :type, :string
      attribute :value, :string
      attribute :list_item, TypedValue, collection: true

      xml do
        root "InsetSpacing"
        map_attribute "type", to: :type
        map_content to: :value
        map_element "ListItem", to: :list_item
      end

      # [top, right, bottom, left] insets; nil components when the
      # document doesn't declare them.
      def sides
        return Array.new(4, value&.to_f) if list_item.empty?

        (0...4).map { |i| list_item[i]&.value&.to_f }
      end
    end
  end
end
