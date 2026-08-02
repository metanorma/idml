# frozen_string_literal: true

module Idml
  module Elements
    # `<TextFrame>` — a text container. Carries `ParentStory` (the Self
    # ID of the Story part that holds the text flow) and geometry.
    # Text flows across linked frames via `PreviousTextFrame`/`NextTextFrame`.
    class TextFrame < Lutaml::Model::Serializable
      attribute :self_attr, :string
      attribute :parent_story, :string
      attribute :item_transform, :string
      attribute :content_type, :string
      attribute :fill_color, :string
      attribute :fill_tint, :float
      attribute :stroke_color, :string
      attribute :stroke_weight, :float
      attribute :visible, :boolean
      attribute :previous_text_frame, :string
      attribute :next_text_frame, :string
      attribute :name, :string
      attribute :properties, Idml::Elements::Properties, collection: true

      xml do
        root "TextFrame"
        map_attribute "Self", to: :self_attr
        map_attribute "ParentStory", to: :parent_story
        map_attribute "ItemTransform", to: :item_transform
        map_attribute "ContentType", to: :content_type
        map_attribute "FillColor", to: :fill_color
        map_attribute "FillTint", to: :fill_tint
        map_attribute "StrokeColor", to: :stroke_color
        map_attribute "StrokeWeight", to: :stroke_weight
        map_attribute "Visible", to: :visible
        map_attribute "PreviousTextFrame", to: :previous_text_frame
        map_attribute "NextTextFrame", to: :next_text_frame
        map_attribute "Name", to: :name
        map_element "Properties", to: :properties
      end

      def text?
        content_type == "TextType" || !parent_story.nil?
      end

      def geometric_bounds
        properties.first&.first_geometry&.bounding_box
      end
    end
  end
end
