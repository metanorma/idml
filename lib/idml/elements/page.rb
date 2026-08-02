# frozen_string_literal: true

module Idml
  module Elements
    # `<Page>` — a single page within a Spread. Carries `GeometricBounds`
    # (y1 x1 y2 x2 in spread coordinates) and `ItemTransform` that maps
    # page-local coordinates to spread coordinates.
    class Page < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :geometric_bounds, :string
      attribute :item_transform, :string
      attribute :name, :string
      attribute :applied_master, :string
      attribute :master_page_transform, :string

      xml do
        root "Page"
        map_attribute "Self", to: :self_attr
        map_attribute "GeometricBounds", to: :geometric_bounds
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "Name", to: :name
        map_attribute "AppliedMaster", to: :applied_master
        map_attribute "MasterPageTransform", to: :master_page_transform
      end

      def bounds
        return [0.0, 0.0, 0.0, 0.0] unless geometric_bounds

        geometric_bounds.split(/\s+/).map(&:to_f)
      end

      def width
        b = bounds
        b[3] - b[1]
      end

      def height
        b = bounds
        b[2] - b[0]
      end
    end
  end
end
