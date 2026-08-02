# frozen_string_literal: true

module Idml
  module Render
    # Filters page items by layer visibility. Items on hidden layers
    # are excluded from rendering. Built from the Designmap's Layer
    # collection — each Layer has a Visible attribute.
    class LayerFilter
      PAGE_ITEM_TYPES = [
        Idml::Elements::Rectangle,
        Idml::Elements::TextFrame,
        Idml::Elements::Polygon,
        Idml::Elements::Group,
        Idml::Elements::GraphicLine,
      ].freeze

      def self.from_designmap(designmap)
        hidden = hidden_layer_ids(layers_for(designmap))
        hidden.empty? ? EXCLUDE_NONE : new(hidden)
      end

      def self.layers_for(designmap)
        return [] unless designmap

        designmap.layer || []
      end
      private_class_method :layers_for

      def self.hidden_layer_ids(layers)
        layers.reject(&:visible).map(&:self_attr)
      end
      private_class_method :hidden_layer_ids

      def initialize(hidden_layer_ids)
        @hidden = hidden_layer_ids.to_set
      end

      EXCLUDE_NONE = new([].freeze)

      def visible?(item)
        return true unless page_item?(item)

        layer_ref = item.item_layer
        return true if layer_ref.nil? || layer_ref.empty?

        !@hidden.include?(layer_ref)
      end

      def filter(items)
        items.select { |item| visible?(item) }
      end

      private

      def page_item?(item)
        PAGE_ITEM_TYPES.any? { |type| item.is_a?(type) }
      end
    end
  end
end
