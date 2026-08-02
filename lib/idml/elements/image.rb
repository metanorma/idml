# frozen_string_literal: true

module Idml
  module Elements
    # `<Image>` — a placed image inside a graphic page item (Rectangle,
    # Polygon). Carries the `ItemTransform` and contains a `<Link>`
    # child that points to the external image file.
    class Image < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :item_transform, :string
      attribute :image_type_name, :string
      attribute :space, :string
      attribute :actual_ppi, :string
      attribute :effective_ppi, :string
      attribute :link, Idml::Elements::Link, collection: true

      xml do
        root "Image"
        map_attribute "Self", to: :self_attr
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "ImageTypeName", to: :image_type_name
        map_attribute "Space", to: :space
        map_attribute "ActualPpi", to: :actual_ppi
        map_attribute "EffectivePpi", to: :effective_ppi
        map_element "Link", to: :link
      end

      def resource_uri
        link.first&.link_resource_uri
      end
    end
  end
end
