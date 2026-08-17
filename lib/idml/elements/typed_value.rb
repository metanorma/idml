# frozen_string_literal: true

module Idml
  module Elements
    # Typed value child element — IDML's `(object_type, xsd:string) |
    # (string_type, xsd:string)` wrapper used inside Properties for
    # values like RuleAboveColor and ParagraphShadingColor: a `type`
    # attribute plus the value as text content.
    class TypedValue < Lutaml::Model::Serializable
      attribute :type, :string
      attribute :value, :string

      xml do
        root "TypedValue"
        map_attribute "type", to: :type
        map_content to: :value
      end
    end
  end
end
