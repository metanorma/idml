# frozen_string_literal: true

module Idml
  module Elements
    # `<PathPointType>` — a single point in a path. The `Anchor`
    # attribute is a space-separated "x y" pair. LeftDirection and
    # RightDirection are Bézier control handles.
    class PathPointType < Lutaml::Model::Serializable
      attribute :anchor, :string
      attribute :left_direction, :string
      attribute :right_direction, :string

      xml do
        root "PathPointType"
        map_attribute "Anchor", to: :anchor
        map_attribute "LeftDirection", to: :left_direction
        map_attribute "RightDirection", to: :right_direction
      end

      def x
        coordinate(0)
      end

      def y
        coordinate(1)
      end

      private

      def coordinate(index)
        return 0.0 unless anchor

        parts = anchor.split(/\s+/)
        parts[index].to_f
      end
    end
  end
end
